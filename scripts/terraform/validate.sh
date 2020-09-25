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

info "Validating terraform installation..."
if ! command -v terraform; then
error "Terraform command line wasn't installed"
fi

info "Checking terraform version"
attempt_counter=0
max_attempts=5
version=""
until [ "$version" ]; do
    release="$(curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest)"
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
if [ "$(terraform version | awk '{ print $2}')" != "$version" ]; then
    error "Terraform version installed is different that expected"
fi
