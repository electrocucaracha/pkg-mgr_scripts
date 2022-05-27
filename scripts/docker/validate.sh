#!/bin/bash
# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2019
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

set -o nounset
set -o errexit
set -o pipefail

mgmt_ip=$(ip route get 8.8.8.8 | grep "^8." | awk '{ print $7 }')

function info {
    _print_msg "INFO" "$1"
}

function warn {
    _print_msg "WARN" "$1"
}

function error {
    _print_msg "ERROR" "$1"
    exit 1
}

function _print_msg {
    echo "$1: $2"
}

info "Validating Docker installation..."
for cmd in docker docker-slim runsc dive; do
    if ! command -v "$cmd"; then
        error "$cmd command line wasn't installed"
    fi
done

info "Validate autocomplete functions"
if declare -F | grep -q "_docker"; then
    warn "Docker autocomplete functions weren't installed"
fi

docker_image="quay.io/openshifttest/alpine:latest"
for image in "$mgmt_ip:5000/bash:test" "$docker_image"; do
    docker_id=$(sudo docker images "$image" -q)
    if [[ -n "$docker_id" ]]; then
        info "Removing previous docker image with id = $docker_id"
        sudo docker rmi -f "$docker_id"
    fi
done
if [[ -n $(sudo docker ps -aqf "name=registry") ]]; then
    sudo docker rm -f registry
fi

info "Validating Docker pulling process with $docker_image image"
if ! sudo docker pull "$docker_image"; then
    error "Docker pull action doesn't work"
fi
info "Validating Docker size image"
if ! sudo "$(command -v dive)" --ci "$docker_image"; then
    error "Dive command doesn't work"
fi

info "Validating Docker running process with $docker_image image (runc runtime)"
sudo docker run --rm "$docker_image" ping -c 1 localhost

info "Validating Docker running process with $docker_image image (runsc runtime)"
sudo docker run --rm --runtime=runsc "$docker_image" ping -c 1 localhost

info "Validating Docker building process with $docker_image image"
pushd "$(mktemp -d)"
cat << EOF > Dockerfile
FROM $docker_image
RUN apk update && apk add bash
EOF
if ! sudo docker build --no-cache -t "$mgmt_ip:5000/bash:test" . ; then
    error "Docker build action doesn't work"
fi
export DSLIM_HTTP_PROBE=false
export DSLIM_CONTINUE_AFTER=1
if ! sudo -E docker-slim build "$mgmt_ip:5000/bash:test" --tag "$mgmt_ip:5000/bash:slim"; then
    error "Docker-slim build action doesn't work"
fi
popd

info "Validating Docker pushing process with $docker_image image"
if [[ -z $(sudo docker ps -aqf "name=registry") ]]; then
    info "Starting a local Docker registry"
    sudo docker run -d --name registry --restart=always \
    -p 5000:5000 -v registry:/var/lib/registry registry:2
fi
if ! sudo docker push "$mgmt_ip:5000/bash:test"; then
    error "Docker push action doesn't work"
fi
if ! command -v jq; then
    info "Installing jq requirement"
    curl -fsSL https://raw.githubusercontent.com/electrocucaracha/pkg-mgr_scripts/master/install.sh | PKG="jq" bash
fi
if [ "$(curl -s -X GET http://localhost:5000/v2/_catalog | jq -r '.repositories | contains(["bash"])')" != "true" ]; then
    error "Bash docker image wasn't stored in a local registry"
fi

info "Validate Registry client installation"
if [ "$(sudo docker regctl image ratelimit "$docker_image" | jq -r '.Set')" != "true" ]; then
    warn "regctl wasn't installed properly"
fi

info "Validating root execution with root container execution"
sudo docker run --rm -d --name rootoutside-rootinside --net=none --userns=host "$docker_image" sleep infinity
if ! pgrep -u "$(id -u root)" | grep -q "$(sudo docker inspect rootoutside-rootinside --format "{{.State.Pid}}")"; then
    error "Running root container has different root user than host"
fi
sudo docker stop rootoutside-rootinside

info "Ensuring that sync user has UID=4"
id -u sync &>/dev/null || sudo useradd -u 4 sync
if [ "$(id -un -- 4)" != "sync" ]; then
    sudo userdel --remove --force "$(id -un -- 4)"
    if id sync &>/dev/null; then
        sudo usermod -u 4 sync
    else
        sudo useradd -u 4 sync
    fi
fi
info "Setting rootless context"
XDG_RUNTIME_DIR="/run/user/$(id -u)/"
export XDG_RUNTIME_DIR
sudo mkdir -p "$XDG_RUNTIME_DIR"
sudo chown "$USER": "$XDG_RUNTIME_DIR"
"$HOME/bin/dockerd-rootless-setuptool.sh" install --force
if systemctl --user daemon-reload >/dev/null 2>&1; then
    systemctl --user start docker
    systemctl --user enable docker
    sudo loginctl enable-linger "$(whoami)"
    trap "systemctl --user stop docker" EXIT
else
    export PATH="$HOME/bin:/sbin/:$PATH"

    attempt_counter=0
    max_attempts=5
    # Only Ubuntu based distros support overlay filesystems in rootless mode.
    # https://medium.com/@tonistiigi/experimenting-with-rootless-docker-416c9ad8c0d6
    nohup bash -c "$HOME/bin/dockerd-rootless.sh --experimental --storage-driver vfs" > /tmp/dockerd-rootless.log 2>&1 &
    until [ -f /tmp/dockerd-rootless.log ] && grep -q "Daemon has completed initialization" /tmp/dockerd-rootless.log; do
        if [ "${attempt_counter}" -eq "${max_attempts}" ];then
            cat /tmp/dockerd-rootless.log
            error "Max attempts reached"
        fi
        attempt_counter=$((attempt_counter+1))
        sleep $((attempt_counter*5))
    done
    if [ -f /run/user/1000/docker.pid ]; then
        trap "kill -s SIGTERM \$(cat /run/user/1000/docker.pid)" EXIT
    elif [ -f "$HOME/.docker/run/docker.pid" ]; then
        trap 'kill -s SIGTERM $(cat $HOME/.docker/run/docker.pid)' EXIT
    fi
fi
if docker context ls | grep -q rootless; then
    docker context rm rootless
fi
docker context create rootless --description "for rootless mode" --docker "host=unix://$XDG_RUNTIME_DIR/docker.sock"

info "Saving $docker_image image"
sudo docker image save -o ~/docker.tar "$docker_image"
sudo chown "$USER": ~/docker.tar

info "Switching to rootless context"
docker context use rootless

info "Loading $docker_image image"
docker image load -i ~/docker.tar

info "Validating non-root execution with root container execution"
docker run --rm -d --name useroutside-rootinside "$docker_image" sleep infinity
if ! pgrep -u "$(id -u)" | grep -q "$(docker inspect useroutside-rootinside --format "{{.State.Pid}}")"; then
    error "Running non-root container has different $USER user than host"
fi
docker stop useroutside-rootinside

info "Validating non-root execution with rootless container execution"
docker run --rm -d --user sync --name useroutside-userinside "$docker_image" sleep infinity
# shellcheck disable=SC2009
if [ "$(ps -eo uname:20,pid,cmd | grep "$(docker inspect useroutside-userinside --format "{{.State.Pid}}")" | awk '{ print $1}')" == "$USER" ]; then
    error "Running non-root container has same $USER user than host"
fi
docker stop useroutside-userinside

info "Switching to default context"
docker context use default
