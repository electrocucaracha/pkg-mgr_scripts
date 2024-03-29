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

info "Validating qemu installation..."
if ! command -v qemu-img; then
    error "QEMU command line wasn't installed"
fi

info "Validate QEMU image creation"
rm -f ~/ubuntu.img
if ! qemu-img create ~/ubuntu.img 10G >/dev/null; then
    error "Error during the QEMU image creation"
fi
qemu-img info ~/ubuntu.img

info "Validate QEMU x86_64 execution"
if ! qemu-system-x86_64 --version; then
    error "Error during the execution of qemu-system-x86_64 binary"
fi
