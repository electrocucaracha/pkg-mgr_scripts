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

# _vercmp() - Function that compares two versions
function _vercmp {
    local v1=$1
    local op=$2
    local v2=$3
    local result

    # sort the two numbers with sort's "-V" argument.  Based on if v2
    # swapped places with v1, we can determine ordering.
    result=$(echo -e "$v1\n$v2" | sort -V | head -1)

    case $op in
        "==")
            [ "$v1" = "$v2" ]
            return
            ;;
        ">")
            [ "$v1" != "$v2" ] && [ "$result" = "$v2" ]
            return
            ;;
        "<")
            [ "$v1" != "$v2" ] && [ "$result" = "$v1" ]
            return
            ;;
        ">=")
            [ "$result" = "$v2" ]
            return
            ;;
        "<=")
            [ "$result" = "$v1" ]
            return
            ;;
        *)
            die $LINENO "unrecognised op: $op"
            ;;
    esac
}

function get_github_latest_release {
    version=""
    attempt_counter=0
    max_attempts=5

    until [ "$version" ]; do
        url_effective=$(curl -sL -o /dev/null -w '%{url_effective}' "https://github.com/$1/releases/latest")
        if [ "$url_effective" ]; then
            version="${url_effective##*/}"
            break
        elif [ ${attempt_counter} -eq ${max_attempts} ];then
            echo "Max attempts reached"
            exit 1
        fi
        attempt_counter=$((attempt_counter+1))
        sleep $((attempt_counter*2))
    done
    echo "${version#v}"
}

function main {
    local version=${PKG_KUBECTL_VERSION:-$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)}
    local krew_version=${PKG_KREW_VERSION:-$(get_github_latest_release kubernetes-sigs/krew)}
    krew_plugins_list=${PKG_KREW_PLUGINS_LIST:-tree,access-matrix,score,sniff,view-utilization}

    OS="$(uname | tr '[:upper:]' '[:lower:]')"
    ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')"

    if ! command -v kubectl || [[ "$(kubectl version --short --client | awk '{print $3}')" != "$version" ]]; then
        echo "INFO: Installing kubectl $version version..."

        pushd "$(mktemp -d)" > /dev/null
        if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
            curl -o kubectl "https://storage.googleapis.com/kubernetes-release/release/$version/bin/$OS/$ARCH/kubectl"
        else
            curl -o kubectl "https://storage.googleapis.com/kubernetes-release/release/$version/bin/$OS/$ARCH/kubectl" 2> /dev/null
        fi
        chmod +x kubectl
        mkdir -p ~/{.local,}/bin
        sudo mkdir -p /snap/bin
        sudo mkdir -p /usr/local/bin/
        sudo mv kubectl /usr/local/bin/kubectl
        popd > /dev/null
        kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null
    fi

    if ! kubectl krew version &>/dev/null || [[ "$(kubectl krew version | grep GitTag | awk '{ print $2}')" != v"$krew_version" ]]; then
        echo "INFO: Installing krew..."

        krew_assets="krew.{tar.gz,yaml}"
        tarball="krew.tar.gz"
        if _vercmp "$krew_version" '>' '0.4.1'; then
            krew_assets="krew{-${OS}_${ARCH}.tar.gz,.yaml}"
            tarball="krew-${OS}_${ARCH}.tar.gz"
        fi
        pushd "$(mktemp -d)" > /dev/null
        if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
            curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/download/v${krew_version}/$krew_assets"
            tar -vxzf "$tarball"
        else
            curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/download/v${krew_version}/$krew_assets" 2> /dev/null
            tar -xzf "$tarball"
        fi
        ./krew-"${OS}_$ARCH" install --manifest=krew.yaml --archive="$tarball"

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
        kubectl krew install "$plugin" || true
    done
}

main
