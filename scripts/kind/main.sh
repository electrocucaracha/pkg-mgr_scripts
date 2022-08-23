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
if [[ ${PKG_DEBUG:-false} == "true" ]]; then
    set -o xtrace
fi

function get_github_latest_release {
    version=""
    attempt_counter=0
    max_attempts=5

    until [ "$version" ]; do
        url_effective=$(curl -sL -o /dev/null -w '%{url_effective}' "https://github.com/$1/releases/latest")
        if [ "$url_effective" ]; then
            version="${url_effective##*/}"
            break
        elif [ ${attempt_counter} -eq ${max_attempts} ]; then
            echo "Max attempts reached"
            exit 1
        fi
        attempt_counter=$((attempt_counter + 1))
        sleep $((attempt_counter * 2))
    done
    echo "${version#v}"
}

function main {
    local version=${PKG_KIND_VERSION:-$(get_github_latest_release kubernetes-sigs/kind)}

    if ! command -v kind || [[ "v$(kind --version | awk '{print $3}')" != "$version" ]]; then
        OS="$(uname | tr '[:upper:]' '[:lower:]')"
        ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')"
        binary="kind-$OS-$ARCH"
        url="https://github.com/kubernetes-sigs/kind/releases/download/v${version}/$binary"

        echo "INFO: Installing kind $version version..."
        if [[ ${PKG_DEBUG:-false} == "true" ]]; then
            curl -Lo ./kind "$url"
        else
            curl -Lo ./kind "$url" 2>/dev/null
        fi
        chmod +x ./kind
        sudo mkdir -p /usr/local/bin/
        sudo mv ./kind /usr/local/bin/kind
        export PATH=$PATH:/usr/local/bin/
    fi
    sudo mkdir -p /etc/bash_completion.d
    kind completion bash | sudo tee /etc/bash_completion.d/kind >/dev/null
}

main
