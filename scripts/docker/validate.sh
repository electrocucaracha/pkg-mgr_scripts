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

mgmt_nic=$(ip route | grep "^192.168.121.0/24\|10.0.2.0/24" | head -n1 | awk '{ print $3 }')
mgmt_ip=$(ip addr show "${mgmt_nic}" | awk "/${mgmt_nic}\$/ { sub(/\/[0-9]*/, \"\","' $2); print $2; exit}')

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
if ! command -v docker; then
    error "Docker command line wasn't installed"
fi

info "Validate autocomplete functions"
if declare -F | grep -q "_docker"; then
    error "Docker autocomplete functions weren't installed"
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
sudo docker run --rm "$docker_image" nslookup google.com

info "Validating Docker building process with $docker_image image"
pushd "$(mktemp -d)"
cat << EOF > Dockerfile
FROM $docker_image
RUN apk update && apk add bash
EOF
if ! sudo docker build --no-cache -t "$mgmt_ip:5000/bash:test" . ; then
    error "Docker build action doesn't work"
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
    curl -fsSL http://bit.ly/install_pkg | PKG="jq" bash
fi
if [ "$(curl -s -X GET http://localhost:5000/v2/_catalog | jq -r '.repositories | contains(["bash"])')" != "true" ]; then
    error "Bash docker image wasn't stored in a local registry"
fi

info "Validate Registry client installation"
if [ "$(sudo docker regctl image ratelimit "$docker_image" | jq -r '.Set')" != "true" ]; then
    warn "regctl wasn't installed properly"
fi

info "Validating root execution with root container execution"
sudo docker run --rm -d --name rootoutside-rootinside --net=none "$docker_image" sleep infinity
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
if systemctl --user daemon-reload >/dev/null 2>&1; then
    systemctl --user start docker
    systemctl --user enable docker
    sudo loginctl enable-linger "$(whoami)"
else
    # Only Ubuntu based distros support overlay filesystems in rootless mode.
    # https://medium.com/@tonistiigi/experimenting-with-rootless-docker-416c9ad8c0d6
    nohup bash -c "$HOME/bin/dockerd-rootless.sh --experimental --storage-driver vfs" > /tmp/dockerd-rootless.log 2>&1 &
    trap "kill -s SIGTERM \$(cat /run/user/1000/docker.pid)" EXIT
    until grep -q "Daemon has completed initialization" /tmp/dockerd-rootless.log; do
        sleep 2
    done
fi
docker context create rootless --description "for rootless mode" --docker "host=unix://$XDG_RUNTIME_DIR/docker.sock"

info "Validating root execution with rootless container execution"
sudo docker run --rm -d --user sync --name rootoutside-userinside --net=none "$docker_image" sleep infinity
if ! pgrep -u "$(id -u sync)" | grep -q "$(sudo docker inspect rootoutside-userinside --format "{{.State.Pid}}")"; then
    error "Running root container has different sync user than host"
fi
sudo docker stop rootoutside-userinside

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
