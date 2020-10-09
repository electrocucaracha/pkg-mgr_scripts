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
    local version=${PKG_CNI_PLUGINS_VERSION:-}
    local cni_folder=${PKG_CNI_PLUGINS_FOLDER:-/opt/containernetworking/plugins}

    attempt_counter=0
    max_attempts=5
    until [ "$version" ]; do
        release="$(curl -s https://api.github.com/repos/containernetworking/plugins/releases/latest)"
        if [ "$release" ]; then
            version="$(echo "$release" | grep -Po '"tag_name":.*?[^\\]",' | awk -F  "\"" 'NR==1{gsub("v",""); print $4}')"
            break
        elif [ ${attempt_counter} -eq ${max_attempts} ];then
            echo "Max attempts reached"
            exit 1
        fi
        attempt_counter=$((attempt_counter+1))
        sleep 2
    done

    if [ ! -d "$cni_folder" ]; then
        echo "INFO: Installing CNI plugins $version version..."
        pushd "$(mktemp -d)" > /dev/null
        sudo mkdir -p "$cni_folder"
        tarball="cni-plugins-$(uname | awk '{print tolower($0)}')-$(get_cpu_arch)-v${version}.tgz"
        if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
            curl -Lo cni-plugins.tgz "https://github.com/containernetworking/plugins/releases/download/v${version}/${tarball}"
            sudo tar xvf cni-plugins.tgz -C "$cni_folder"
        else
            curl -Lo cni-plugins.tgz "https://github.com/containernetworking/plugins/releases/download/v${version}/${tarball}" > /dev/null
            sudo tar xf cni-plugins.tgz -C "$cni_folder"
        fi
        sudo chown "$USER" -R "$cni_folder"
        popd > /dev/null
    fi
}

main
