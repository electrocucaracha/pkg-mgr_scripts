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

function setup_ftrace {
    ftrace_analyzer_version="0.1.3"
    ftrace_folder_path="/usr/local/bin"
    ftrace_analyzer_path="$ftrace_folder_path/oci-ftrace-syscall-analyzer"

    ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')"
    curl -sL "https://github.com/KentaTada/oci-ftrace-syscall-analyzer/releases/download/v$ftrace_analyzer_version/oci-ftrace-syscall-analyzer-$ARCH.tar.gz" | sudo tar -xz -C "$ftrace_folder_path"
    sudo chmod a+x "$ftrace_analyzer_path"
    if command -v setcap > /dev/null; then
        sudo setcap CAP_DAC_OVERRIDE+ep /"$ftrace_analyzer_path"
    fi
    sudo mkdir -p /etc/containers/oci/hooks.d/
    sudo tee <<EOF /etc/containers/oci/hooks.d/ftrace-syscall-analyzer-prehook.json > /dev/null
    {
            "version": "1.0.0",
            "hook": {
                    "path": "$ftrace_analyzer_path",
                    "args": [
                            "record"
                    ]
            },
            "when": {
                    "annotations": {
                            "oci-ftrace-syscall-analyzer/trace": "true"
                    }
            },
            "stages": ["prestart"]
    }
EOF
    sudo tee <<EOF /etc/containers/oci/hooks.d/ftrace-syscall-analyzer-posthook.json > /dev/null
    {
            "version": "1.0.0",
            "hook": {
                    "path": "$ftrace_analyzer_path",
                    "args": [
                            "report",
                            "--seccomp-profile",
                            "/tmp/seccomp.json",
                            "--output",
                            "/tmp/ftrace_syscalls_dump.log"
                    ]
            },
            "when": {
                    "annotations": {
                            "oci-ftrace-syscall-analyzer/trace": "true"
                    }
            },
            "stages": ["poststop"]
    }
EOF
}

info "Validating podman installation..."
if ! command -v podman; then
    error "podman command line wasn't installed"
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
podman pull quay.io/quay/busybox:latest

runtimes_list=${PKG_PODMAN_RUNTIMES_LIST:-runc,crun,youki}
for runtime in ${runtimes_list//,/ }; do
    info "Validating $runtime installation..."
    if ! command -v "$runtime"; then
        warn "$runtime command line wasn't installed"
    else
        info "Checking $runtime version"
        if ! "$runtime" --version; then
            error "$runtime version command failure"
        fi
        if ! sudo podman --runtime "$runtime" run --rm quay.io/quay/busybox:latest ls; then
            error "$runtime failed execution"
        fi
    fi
done


info "Validate pod creation"
podman pod rm single-pod --ignore
pushd "$(mktemp -d)"
cat << EOF > pod.yml
apiVersion: v1
kind: Pod
metadata:
  name: single-pod
spec:
  containers:
    - name: test
      image: quay.io/quay/busybox:latest
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
if ! sudo podman run --rm --pids-limit 1 --net=none quay.io/quay/busybox:latest echo "it works"; then
    error "crun pids limit doesn't work"
fi

info "Validating root execution with root container execution"
sudo podman run --rm -d --name rootoutside-rootinside --net=none quay.io/quay/busybox:latest sleep infinity
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
sudo podman run --rm -d --user sync --name rootoutside-userinside --net=none quay.io/quay/busybox:latest sleep infinity
if ! pgrep -u "$(id -u sync)" | grep -q "$(sudo podman inspect rootoutside-userinside --format "{{.State.Pid}}")"; then
    error "Running root container has different sync user than host"
fi
sudo podman stop rootoutside-userinside

info "Validating non-root execution with root container execution"
podman run --rm -d --name useroutside-rootinside quay.io/quay/busybox:latest sleep infinity
if ! pgrep -u "$(id -u)" | grep -q "$(podman inspect useroutside-rootinside --format "{{.State.Pid}}")"; then
    error "Running non-root container has different $USER user than host"
fi
podman stop useroutside-rootinside

info "Validating non-root execution with rootless container execution"
podman run --rm -d --user sync --name useroutside-userinside quay.io/quay/busybox:latest sleep infinity
# shellcheck disable=SC2009
if [ "$(ps -eo uname:20,pid,cmd | grep "$(podman inspect useroutside-userinside --format "{{.State.Pid}}")" | awk '{ print $1}')" == "$USER" ]; then
    error "Running non-root container has same $USER user than host"
fi
podman stop useroutside-userinside

setup_ftrace
podman --hooks-dir /etc/containers/oci/hooks.d/ run --annotation oci-ftrace-syscall-analyzer/trace="true" quay.io/quay/busybox:latest ls
