#!/bin/bash
# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2021
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
    local version=${PKG_KN_VERSION:-}

    attempt_counter=0
    max_attempts=5
    until [ "$version" ]; do
        tags="$(curl -s https://api.github.com/repos/knative/client/tags)"
        if [ "$tags" ]; then
            version="$(echo "$tags" | grep -Po '"name":.*?[^\\]",' | awk -F  "\"" 'NR==1{print $4}')"
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

info "Validating kn installation..."
if ! command -v kn; then
    error "Knative command line wasn't installed"
fi

info "Validating autocomplete functions"
if declare -F | grep -q "_kn"; then
    error "kn autocomplete install failed"
fi

info "Checking kn version"
if [ "$(kn version | awk 'NR==1{print $2}')" != "v$(get_version)" ]; then
    error "Knative client version installed is different that expected"
fi
