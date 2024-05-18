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

export PATH="$PATH:${KREW_ROOT:-${_REMOTE_USER_HOME-$HOME}/.krew}/bin"

info "Validating prof index addition"
if ! kubectl krew index list | grep -q "kubectl-prof"; then
    error "kubectl-prof index wasn't added"
fi

info "Validating prof Krew plugin installation..."
if ! kubectl prof --version; then
    error "prof Krew plugin wasn't installed"
fi
