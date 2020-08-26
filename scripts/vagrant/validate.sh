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

info "Validating vagrant installation..."
if ! command -v vagrant; then
    error "Vagrant command line wasn't installed"
fi

info "Validating Vagrant operation"
pushd "$(mktemp -d)"
vagrant init centos/7
if ! [ -f Vagrantfile ]; then
    error "Vagrantfile wasn't created"
fi
popd

info "Validate autocomplete functions"
if declare -F | grep -q "_vagrant"; then
    error "Vagrant autocomplete install failed"
fi
