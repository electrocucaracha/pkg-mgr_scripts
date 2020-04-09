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
if [[ "${PKG_MGR_DEBUG:-false}" == "true" ]]; then
    set -o xtrace
fi

function main {
    local version=${PKG_GOLANG_VERSION:-1.14}
    local os=linux
    local arch=amd64
    local tarball=go$version.$os-$arch.tar.gz

    if command -v go; then
        return
    fi
    echo "INFO: Installing go $version version..."

    pushd "$(mktemp -d)" > /dev/null
    if [[ "${PKG_MGR_DEBUG:-false}" == "true" ]]; then
        curl -o "$tarball" "https://dl.google.com/go/$tarball"
        sudo tar -C /usr/local -vxzf "$tarball"
    else
        curl -o "$tarball" "https://dl.google.com/go/$tarball" 2> /dev/null
        sudo tar -C /usr/local -xzf "$tarball"
    fi
    popd > /dev/null

    sudo mkdir -p /etc/profile.d/
    # shellcheck disable=SC2016
    echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/path.sh > /dev/null
}

main