#!/bin/bash
# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2024
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

info "Validating qat-driver installation..."
if ! command -v lspci >/dev/null || ! lspci 2>/dev/null | grep -qi "quick assist"; then
    info "No QAT hardware detected, skipping qat_service check"
elif ! command -v qat_service; then
    error "qat_service command line wasn't installed"
fi
