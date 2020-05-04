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
if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
    set -o xtrace
fi

function main {
    local version=${PKG_TERRAFORM_VERSION:-0.12.24}
    local tarball="terraform_${version}_linux_amd64.zip"

    if command -v terraform; then
        return
    fi

    pushd "$(mktemp -d)" > /dev/null
    if ! command -v unzip; then
        curl -fsSL http://bit.ly/install_pkg | PKG=unzip bash
    fi
    if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
        curl -o "$tarball" "https://releases.hashicorp.com/terraform/$version/$tarball"
        unzip "$tarball"
    else
        curl -o "$tarball" "https://releases.hashicorp.com/terraform/$version/$tarball" 2>/dev/null
        unzip -qq "$tarball"
    fi
    sudo mkdir -p /usr/local/bin/
    sudo mv terraform /usr/local/bin/
    rm "$tarball"
    mkdir -p ~/.terraform.d/plugins
    popd > /dev/null
}

main
