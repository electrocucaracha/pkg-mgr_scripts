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

function main {
    local version=${PKG_TERRAFORM_VERSION:-0.12.18}
    local tarball="terraform_${version}_linux_amd64.zip"

    if command -v terraform; then
        return
    fi

    pushd "$(mktemp -d)"
    curl -o "$tarball" "https://releases.hashicorp.com/terraform/$version/$tarball"
    if ! command -v unzip; then
        curl -fsSL http://bit.ly/install_pkg | PKG=unzip bash
    fi
    unzip "$tarball"
    sudo mkdir -p /usr/local/bin/
    sudo mv terraform /usr/local/bin/
    rm "$tarball"
    mkdir -p ~/.terraform.d/plugins
    popd
}

main
