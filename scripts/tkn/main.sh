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
    local version=${PKG_TKN_VERSION:-$(get_github_latest_release tektoncd/cli)}

    if ! command -v tkn || [[ "$(tkn version | awk 'NR==1{print $(NF)}' )" != "$version" ]]; then
        echo "INFO: Installing tkn $version version..."
        tarball="tkn_${version}_$(uname)_$(uname -m).tar.gz"
        url="https://github.com/tektoncd/cli/releases/download/v$version/$tarball"
        pushd "$(mktemp -d)" > /dev/null
        if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
            curl -L -o tkn.tgz "$url"
            tar xvf tkn.tgz
        else
            curl -sL -o tkn.tgz "$url" 2> /dev/null
            tar xf tkn.tgz
        fi
        chmod +x ./tkn
        sudo mkdir -p  /usr/local/bin/
        sudo mv ./tkn /usr/local/bin/tkn
        export PATH=$PATH:/usr/local/bin/
        popd > /dev/null
    fi
    sudo mkdir -p /etc/bash_completion.d
    tkn completion bash | sudo tee /etc/bash_completion.d/fly > /dev/null
}

main
