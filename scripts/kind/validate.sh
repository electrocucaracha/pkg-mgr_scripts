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

info "Validating kind installation..."
if ! command -v kind; then
    error "Kubernetes IN Docker command line wasn't installed"
fi

info "Validating autocomplete functions"
if declare -F | grep -q "_kind"; then
    error "Kind autocomplete install failed"
fi

info "Checking kind version"
attempt_counter=0
max_attempts=5
version=""
until [ "$version" ]; do
    release="$(curl -s https://api.github.com/repos/kubernetes-sigs/kind/releases/latest)"
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
if [ "v$(kind --version | awk '{print $3}')" != "$version" ]; then
    error "Kind version installed is $(kind --version) but $version expected"
fi
