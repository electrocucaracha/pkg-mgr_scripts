#!/bin/bash
# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2020
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

set -o nounset
set -o errexit
set -o pipefail

function info {
    _print_msg "INFO" "$1"
}

function error {
    _print_msg "ERROR" "$1"
    exit 1
}

function _print_msg {
    echo "$1: $2"
}

function get_version {
    local version=${PKG_CRUN_VERSION:-}
    attempt_counter=0
    max_attempts=5

    until [ "$version" ]; do
        url_effective=$(curl -sL -o /dev/null -w '%{url_effective}' "https://github.com/containers/crun/releases/latest")
        if [ "$url_effective" ]; then
            echo "${url_effective##*/}"
            break
        elif [ ${attempt_counter} -eq ${max_attempts} ];then
            echo "Max attempts reached"
            exit 1
        fi
        attempt_counter=$((attempt_counter+1))
        sleep 2
    done
}

info "Validating podman installation..."
if ! command -v podman; then
    error "podman command line wasn't installed"
fi

info "Validating crun installation..."
if ! command -v crun; then
    error "crun command line wasn't installed"
fi

info "Checking crun version"
if [ "$(crun --version | awk 'NR==1{ print $3}')" != "$(get_version)" ]; then
    error "crun version installed is different that expected"
fi

info "Validating podman service..."
if ! systemctl is-enabled --quiet podman.socket; then
    error "Podman is not enabled"
fi
if ! systemctl is-active --quiet podman.socket; then
    error "Podman is not active"
fi

info "Validating podman remote execution..."
if ! sudo podman --remote info; then
    error "Podman service wasn't started"
fi

info "Validate fetch image"
podman pull busybox

info "Validate pod creation"
pushd "$(mktemp -d)"
cat << EOF > pod.yml
apiVersion: v1
kind: Pod
metadata:
  name: single-pod
spec:
  containers:
    - name: test
      image: busybox
      command: ["sleep"]
      args: ["infity"]
EOF
if ! podman play kube pod.yml; then
    error "Podman can't create a pod using a yaml file"
fi
popd

if ! podman pod list | grep -q single-pod; then
    error "Podman doens't list the pod created thru yaml file"
fi
podman pod stop single-pod
podman pod rm single-pod

info "Validating crun exclusive features"
if ! sudo podman run --rm --pids-limit 1 --net=none busybox echo "it works"; then
    error "crun pids limit doesn't work"
fi

info "Validating root execution with root container execution"
sudo podman run --rm -d --name rootoutside-rootinside --net=none busybox sleep infinity
if ! pgrep -u "$(id -u root)" | grep -q "$(sudo podman inspect rootoutside-rootinside --format "{{.State.Pid}}")"; then
    error "Running root container has different root user than host"
fi
sudo podman stop rootoutside-rootinside

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

info "Validating root execution with rootless container execution"
sudo podman run --rm -d --user sync --name rootoutside-userinside --net=none busybox sleep infinity
if ! pgrep -u "$(id -u sync)" | grep -q "$(sudo podman inspect rootoutside-userinside --format "{{.State.Pid}}")"; then
    error "Running root container has different sync user than host"
fi
sudo podman stop rootoutside-userinside

info "Validating non-root execution with root container execution"
podman run --rm -d --name useroutside-rootinside busybox sleep infinity
if ! pgrep -u "$(id -u)" | grep -q "$(podman inspect useroutside-rootinside --format "{{.State.Pid}}")"; then
    error "Running non-root container has different $USER user than host"
fi
podman stop useroutside-rootinside

info "Validating non-root execution with rootless container execution"
podman run --rm -d --user sync --name useroutside-userinside busybox sleep infinity
# shellcheck disable=SC2009
if [ "$(ps -eo uname:20,pid,cmd | grep "$(podman inspect useroutside-userinside --format "{{.State.Pid}}")" | awk '{ print $1}')" == "$USER" ]; then
    error "Running non-root container has same $USER user than host"
fi
podman stop useroutside-userinside
