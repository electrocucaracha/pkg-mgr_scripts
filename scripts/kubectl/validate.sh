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

function get_version {
    local version=${PKG_KREW_VERSION:-}
    attempt_counter=0
    max_attempts=5

    until [ "$version" ]; do
        url_effective=$(curl -sL -o /dev/null -w '%{url_effective}' "https://github.com/kubernetes-sigs/krew/releases/latest")
        if [ "$url_effective" ]; then
            version="${url_effective##*/}"
            break
        elif [ ${attempt_counter} -eq ${max_attempts} ];then
            echo "Max attempts reached"
            exit 1
        fi
        attempt_counter=$((attempt_counter+1))
        sleep 2
    done
    echo "v${version#*v}"
}

info "Validating kubectl installation..."
if ! command -v kubectl; then
    error "Kubectl command line wasn't installed"
fi

info "Validating autocomplete functions"
if declare -F | grep -q "_kubectl"; then
    error "Kubectl autocomplete install failed"
fi

info "Validating krew installation..."
if ! kubectl plugin list | grep "kubectl-krew"; then
    error "Krew plugin wasn't installed"
fi

info "Checking krew version"
if [ "$(kubectl krew version | grep GitTag | awk '{ print $2}')" != "$(get_version)" ]; then
    error "Krew version installed is different that expected"
fi
