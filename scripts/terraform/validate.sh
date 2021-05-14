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

function get_version {
    local version=${PKG_TERRAFORM_VERSION:-}
    attempt_counter=0
    max_attempts=5

    until [ "$version" ]; do
        url_effective=$(curl -sL -o /dev/null -w '%{url_effective}' "https://github.com/hashicorp/terraform/releases/latest")
        if [ "$url_effective" ]; then
            version="${url_effective##*/v}"
            break
        elif [ ${attempt_counter} -eq ${max_attempts} ];then
            echo "Max attempts reached"
            exit 1
        fi
        attempt_counter=$((attempt_counter+1))
        sleep 2
    done
    echo "v${version}"
}

info "Validating terraform installation..."
if ! command -v terraform; then
    error "Terraform command line wasn't installed"
fi
if ! command -v terraform-docs; then
    error "Terraform Documentation command line wasn't installed"
fi

info "Checking terraform version"
if [ "$(terraform version | awk 'NR==1{ print $2}')" != "$(get_version)" ]; then
    error "Terraform version installed is different that expected"
fi

info "Validating autocomplete functions"
if declare -F | grep -q "_terraform-docs"; then
    error "terraform-docs autocomplete install failed"
fi
