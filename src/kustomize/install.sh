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

# Some devcontainer test images execute feature installers as root without sudo.
# Provide a local fallback so the same script works in both contexts.
if ! command -v sudo >/dev/null && [ "$(id -u)" -eq 0 ]; then
    sudo() {
        while [[ "$1" == -* ]]; do
            shift
        done
        "$@"
    }
fi
if [[ ${PKG_DEBUG:-false} == "true" ]]; then
    set -o xtrace
fi

function get_github_latest_release {
    local repository="$1"
    local version=""
    local url_effective=""
    local attempt_counter=0
    local max_attempts=5

    until [ "$version" ]; do
        url_effective=$(curl -sL -o /dev/null -w '%{url_effective}' "https://github.com/$repository/releases/latest")
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
    local version=${PKG_KUSTOMIZE_VERSION:-$(get_github_latest_release kubernetes-sigs/kustomize)}

    if ! command -v kustomize || [[ "$(kustomize version 2>/dev/null)" != *"${version#*v}"* ]]; then
        echo "INFO: Installing kustomize ${version#*v} version..."

        OS="$(uname | tr '[:upper:]' '[:lower:]')"
        ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')"
        url="https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${version#*v}/kustomize_v${version#*v}_${OS}_$ARCH.tar.gz"
        if [[ ${PKG_DEBUG:-false} == "true" ]]; then
            curl -sL "$url" | sudo tar xz -C /usr/local/bin/
        else
            curl -sL "$url" 2>/dev/null | sudo tar xzv -C /usr/local/bin/
        fi
    fi
    sudo mkdir -p /etc/bash_completion.d
    kustomize completion bash | sudo tee /etc/bash_completion.d/kustomize >/dev/null
}

main
