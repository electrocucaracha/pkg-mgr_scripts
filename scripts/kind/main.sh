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

function get_cpu_arch {
    if [ -z "${PKG_CPU_ARCH:-}" ]; then
        case "$(uname -m)" in
            x86_64)
                PKG_CPU_ARCH=amd64
            ;;
            armv8*)
                PKG_CPU_ARCH=arm64
            ;;
            aarch64*)
                PKG_CPU_ARCH=arm64
            ;;
            armv*)
                PKG_CPU_ARCH=armv7
            ;;
        esac
    fi
    echo "$PKG_CPU_ARCH"
}

function main {
    local version=${PKG_KIND_VERSION:-0.8.1}

    if command -v kind; then
        return
    fi

    echo "INFO: Installing kind..."
    if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
        curl -Lo ./kind "https://github.com/kubernetes-sigs/kind/releases/download/v${version}/kind-$(uname)-$(get_cpu_arch)"
    else
        curl -Lo ./kind "https://github.com/kubernetes-sigs/kind/releases/download/v${version}/kind-$(uname)-$(get_cpu_arch)" 2> /dev/null
    fi
    chmod +x ./kind
    sudo mkdir -p  /usr/local/bin/
    sudo mv ./kind /usr/local/bin/kind
}

main
