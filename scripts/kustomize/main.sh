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
    local version=${PKG_KUSTOMIZE_VERSION:-$(get_github_latest_release kubernetes-sigs/kustomize)}

    if ! command -v kustomize || [ "$(kustomize version | grep -o -P '(?<={Version:kustomize/v).*(?= GitCommit:)')" != "$version" ]; then
        echo "INFO: Installing kustomize $version version..."

        url="https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${version}/kustomize_v${version}_$(uname | tr '[:upper:]' '[:lower:]')_$(get_cpu_arch).tar.gz"
        pushd "$(mktemp -d)" > /dev/null
        if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
            curl -sL -o kustomize.tgz "$url"
            tar -vxzf kustomize.tgz
        else
            curl -sL -o kustomize.tgz "$url" 2> /dev/null
            tar -xzf kustomize.tgz
        fi
        sudo mv kustomize /usr/local/bin/kustomize
        popd > /dev/null
        kustomize completion bash | sudo tee /etc/bash_completion.d/kustomize > /dev/null
    fi
}

main
