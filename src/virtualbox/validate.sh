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

# Some devcontainer test images execute feature installers as root without sudo.
# Provide a local fallback so the same script works in both contexts.
if ! command -v sudo >/dev/null && [ "$(id -u)" -eq 0 ]; then
    sudo() {
        "$@"
    }
fi

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

info "Validating VirtualBox installation..."
if ! command -v VBoxManage; then
    error "VirtualBox command line wasn't installed"
fi

if command -v systemctl >/dev/null && systemctl list-unit-files | grep -q '^vboxdrv\.service'; then
    sudo systemctl restart vboxdrv
fi
info "Validating VirtualBox execution"
VBoxManage -v
