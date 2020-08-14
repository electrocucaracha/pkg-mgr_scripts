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
    local version=${PKG_KIND_VERSION:-$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)}

    if ! command -v kubectl; then
        echo "INFO: Installing kubectl..."

        pushd "$(mktemp -d)" > /dev/null
        if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
            curl -o kubectl "https://storage.googleapis.com/kubernetes-release/release/$version/bin/linux/$(get_cpu_arch)/kubectl"
        else
            curl -o kubectl "https://storage.googleapis.com/kubernetes-release/release/$version/bin/linux/$(get_cpu_arch)/kubectl" 2> /dev/null
        fi
        chmod +x kubectl
        sudo mkdir -p /usr/local/bin/
        sudo mv kubectl /usr/local/bin/kubectl
        popd > /dev/null
    fi

    if ! kubectl krew version &>/dev/null; then
        echo "INFO: Installing krew..."

        pushd "$(mktemp -d)" > /dev/null
        if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
            curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.{tar.gz,yaml}"
            tar -vxzf krew.tar.gz
        else
            curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.{tar.gz,yaml}" 2> /dev/null
            tar -xzf krew.tar.gz
        fi
        ./krew-"$(uname | tr '[:upper:]' '[:lower:]')_$(get_cpu_arch)" install --manifest=krew.yaml --archive=krew.tar.gz

        sudo mkdir -p /etc/profile.d/
        # shellcheck disable=SC2016
        echo 'export PATH=$PATH:${KREW_ROOT:-$HOME/.krew}/bin' | sudo tee /etc/profile.d/krew_path.sh > /dev/null
        export PATH="$PATH:${KREW_ROOT:-$HOME/.krew}/bin"
        popd > /dev/null
    fi
    if ! command -v git; then
        curl -fsSL http://bit.ly/install_pkg | PKG=git bash
    fi
    kubectl krew update
    kubectl krew install tree
}

main
