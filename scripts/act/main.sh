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
    local version=${PKG_ACT_VERSION:-$(get_github_latest_release nektos/act)}

    if ! command -v act || [[ "$(act --version | awk '{print $3}')" != "$version" ]]; then
        echo "INFO: Installing GitHub actions client $version version..."

        url="https://github.com/nektos/act/releases/download/v$version/act_$(uname)_$(uname -m).tar.gz"
        pushd "$(mktemp -d)" > /dev/null
        if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
            curl -Lo act.tgz "$url"
            sudo tar xvf act.tgz
        else
            curl -Lo act.tgz "$url" > /dev/null
            sudo tar xf act.tgz
        fi
        sudo mkdir -p /usr/local/bin/
        sudo mv ./act /usr/local/bin/act
        export PATH=$PATH:/usr/local/bin/
        popd > /dev/null
    fi
}

main
