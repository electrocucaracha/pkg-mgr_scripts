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
    local version=${PKG_GOLANG_VERSION:-}

    attempt_counter=0
    max_attempts=5
    until [ "$version" ]; do
        stable_version="$(curl -s https://golang.org/VERSION?m=text)"
        if [ "$stable_version" ]; then
            version="${stable_version#go}"
            break
        elif [ ${attempt_counter} -eq ${max_attempts} ];then
            echo "Max attempts reached"
            exit 1
        fi
        attempt_counter=$((attempt_counter+1))
        sleep 2
    done
    echo "go$version"
}

info "Validating go installation..."
if ! command -v go; then
    error "Go command line wasn't installed"
fi

info "Validating go execution..."
go env

info "Checking go version"
if [ "$(go version | awk '{print $3}')" != "$(get_version)" ]; then
    error "Go version installed is different that expected"
fi
