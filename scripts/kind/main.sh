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
    local version=${PKG_KIND_VERSION:-}

    attempt_counter=0
    max_attempts=5
    until [ "$version" ]; do
        release="$(curl -s https://api.github.com/repos/kubernetes-sigs/kind/releases/latest)"
        if [ "$release" ]; then
            version="$(echo "$release" | grep -Po '"name":.*?[^\\]",' | awk -F  "\"" 'NR==1{print $4}')"
            break
        elif [ ${attempt_counter} -eq ${max_attempts} ];then
            echo "Max attempts reached"
            exit 1
        fi
        attempt_counter=$((attempt_counter+1))
        sleep 2
    done

    if ! command -v kind || [[ "v$(kind --version | awk '{print $3}')" != "$version" ]]; then
        echo "INFO: Installing kind $version version..."
        binary="kind-$(uname | tr '[:upper:]' '[:lower:]')-$(get_cpu_arch)"
        url="https://github.com/kubernetes-sigs/kind/releases/download/v${version#*v}/$binary"
        if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
            curl -Lo ./kind "$url"
        else
            curl -Lo ./kind "$url" 2> /dev/null
        fi
        chmod +x ./kind
        sudo mkdir -p  /usr/local/bin/
        sudo mv ./kind /usr/local/bin/kind
        export PATH=$PATH:/usr/local/bin/
    fi
    kind completion bash | sudo tee /etc/bash_completion.d/kind > /dev/null
}

main
