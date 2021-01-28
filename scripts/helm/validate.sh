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

info "Validating helm installation..."
if ! command -v helm; then
    error "Helm command line wasn't installed"
fi

helm_version=$(helm version 2>/dev/null | awk -F '"' '{print substr($2,2); exit}' || true)
info "Validating helm $helm_version version"
if [[ "$helm_version" == "2"* ]]; then
    info "Validating helm service"
    if ! systemctl is-enabled --quiet helm-serve; then
        error "Helm service is not enabled"
    fi
    if ! systemctl is-active --quiet helm-serve; then
        error "Helm service is not active"
    fi

    info "Validating helm local repo"
    if ! sudo su helm -c "helm repo list" | grep -q "^local"; then
        error "Helm repository list doesn't include local"
    fi
fi

info "Validating autocomplete functions"
if declare -F | grep -q "_helm"; then
    error "Helm autocomplete install failed"
fi
