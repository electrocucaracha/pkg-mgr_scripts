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
    local version=${PKG_HADOLINT_VERSION:-}
    attempt_counter=0
    max_attempts=5

    until [ "$version" ]; do
        url_effective=$(curl -sL -o /dev/null -w '%{url_effective}' "https://github.com/hadolint/hadolint/releases/latest")
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
    echo "${version#*v}"
}

info "Validating hadolint installation..."
if ! command -v hadolint; then
    error "Haskell Dockerfile Linter command line wasn't installed"
fi

info "Validating linting process..."
pushd "$(mktemp -d)"
cat << EOF > Dockerfile
FROM alpine:3.12

RUN apk add --no-cache tini=0.19.0
ENTRYPOINT ["/sbin/tini", "--"]
EOF
if ! hadolint Dockerfile; then
    error "Hadolint validation failed"
fi
popd
