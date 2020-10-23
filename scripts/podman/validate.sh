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

function get_version {
    local version=${PKG_CRUN_VERSION:-}
    attempt_counter=0
    max_attempts=5

    until [ "$version" ]; do
        release="$(curl -s "https://api.github.com/repos/containers/crun/releases/latest")"
        if [ "$release" ]; then
            version="$(echo "$release" | grep -Po '"name":.*?[^\\]",' | awk -F  "\"" 'NR==1{print $4}')"
            break
        elif [ ${attempt_counter} -eq ${max_attempts} ];then
            echo "Max attempts reached"
            exit 1
        fi
        attempt_counter=$((attempt_counter+1))
        sleep 2
    done

    echo "${version#*v}"
}

sudo tee /etc/cni/net.d/00-podman-bridge.conf << EOF
{
    "cniVersion": "0.4.0",
    "name": "podman",
    "type": "bridge",
    "bridge": "cni0",
    "isDefaultGateway": true,
    "ipMasq": true,
    "ipam": {
        "type": "host-local",
        "subnet": "10.10.0.0/24"
    }
}
EOF

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

info "Validating podman remote execution..."
if ! sudo podman --remote info; then
    warn "Podman service wasn't started"
fi

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
if ! sudo podman play kube pod.yml; then
    error "Podman can't create a pod using a yaml file"
fi
popd

if ! sudo podman pod list | grep -q single-pod; then
    error "Podman doens't list the pod created thru yaml file"
fi

info "Validating crun exclusive features"
if ! sudo podman run --rm --pids-limit 1 busybox echo "it works"; then
    error "crun pids limit doesn't work"
fi
