#!/bin/bash
# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2021
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
        sleep 2
    done
    echo "${version#v}"
}

function main {
    local version=${GOMPLATE_VERSION:-$(get_github_latest_release hairyhenderson/gomplate)}

    if ! command -v gomplate || [[ "$(gomplate --version | awk '{print $3}')" != "$version" ]]; then
        echo "INFO: Installing gomplate $version version..."
        binary="gomplate_$(uname | tr '[:upper:]' '[:lower:]')-$(get_cpu_arch)-slim"
        url="https://github.com/hairyhenderson/gomplate/releases/download/v${version}/$binary"
        if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
            curl -Lo ./gomplate "$url"
        else
            curl -Lo ./gomplate "$url" 2> /dev/null
        fi
        chmod +x ./gomplate
        sudo mkdir -p  /usr/local/bin/
        sudo mv ./gomplate /usr/local/bin/gomplate
        export PATH=$PATH:/usr/local/bin/
    fi
}

main
