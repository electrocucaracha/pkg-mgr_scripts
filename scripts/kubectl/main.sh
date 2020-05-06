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
    local version=${PKG_KIND_VERSION:-$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)}
    local krew_version="v0.3.4"

    cpu_arch="amd64"
    if command -v dpkg; then
        cpu_arch=$(dpkg --print-architecture)
    fi
    if [ -n "${PKG_CPU_ARCH:-}" ]; then
        cpu_arch="$PKG_CPU_ARCH"
    fi

    if ! command -v kubectl; then
        echo "INFO: Installing kubectl..."

        if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
            curl -o ./kubectl "https://storage.googleapis.com/kubernetes-release/release/$version/bin/linux/$cpu_arch/kubectl"
        else
            curl -o ./kubectl "https://storage.googleapis.com/kubernetes-release/release/$version/bin/linux/$cpu_arch/kubectl" 2> /dev/null
        fi
        chmod +x ./kubectl
        sudo mkdir -p  /usr/local/bin/
        sudo mv ./kubectl /usr/local/bin/kubectl
    fi

    if ! kubectl krew version &>/dev/null; then
        echo "INFO: Installing krew..."

        pushd "$(mktemp -d)" > /dev/null
        if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
            curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/download/${krew_version}/krew.{tar.gz,yaml}"
            tar -vxzf krew.tar.gz
        else
            curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/download/${krew_version}/krew.{tar.gz,yaml}" 2> /dev/null
            tar -xzf krew.tar.gz
        fi
        ./krew-"$(uname | tr '[:upper:]' '[:lower:]')_$cpu_arch" install --manifest=krew.yaml --archive=krew.tar.gz

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
