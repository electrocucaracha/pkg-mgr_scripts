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
    case "$(uname -m)" in
        x86_64)
            echo "amd64"
        ;;
        armv8*|aarch64*)
            echo "arm64"
        ;;
        armv*)
            echo "armv7"
        ;;
    esac
}

function main {
    local version=${PKG_KUBECTL_VERSION:-$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)}
    krew_plugins_list=${PKG_KREW_PLUGINS_LIST:-tree,access-matrix,access-matrix,score,sniff,view-utilization}

    if ! command -v kubectl || [[ "$(kubectl version --short --client | awk '{print $3}')" != "$version" ]]; then
        echo "INFO: Installing kubectl $version version..."

        pushd "$(mktemp -d)" > /dev/null
        if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
            curl -o kubectl "https://storage.googleapis.com/kubernetes-release/release/$version/bin/linux/$(get_cpu_arch)/kubectl"
        else
            curl -o kubectl "https://storage.googleapis.com/kubernetes-release/release/$version/bin/linux/$(get_cpu_arch)/kubectl" 2> /dev/null
        fi
        chmod +x kubectl
        mkdir -p ~/{.local,}/bin
        sudo mkdir -p /snap/bin
        sudo mkdir -p /usr/local/bin/
        sudo mv kubectl /usr/local/bin/kubectl
        popd > /dev/null
        kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null
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
        INSTALLER_CMD="sudo -H -E "
        # shellcheck disable=SC1091
        source /etc/os-release || source /usr/lib/os-release
        case ${ID,,} in
            *suse*)
                INSTALLER_CMD+="zypper "
                if [[ "${PKG_DEBUG:-false}" == "false" ]]; then
                    INSTALLER_CMD+="-q "
                fi
                $INSTALLER_CMD install -y --no-recommends git
            ;;
            ubuntu|debian)
                INSTALLER_CMD+="apt-get -y "
                if [[ "${PKG_DEBUG:-false}" == "false" ]]; then
                    INSTALLER_CMD+="-q=3 "
                fi
                $INSTALLER_CMD --no-install-recommends install git
            ;;
            rhel|centos|fedora)
                INSTALLER_CMD+="$(command -v dnf || command -v yum) -y"
                if [[ "${PKG_DEBUG:-false}" == "false" ]]; then
                    INSTALLER_CMD+=" --quiet --errorlevel=0"
                fi
                $INSTALLER_CMD install git
            ;;
        esac
    fi
    kubectl krew update
    for plugin in ${krew_plugins_list//,/ }; do
        kubectl krew install "$plugin"
    done
}

main
