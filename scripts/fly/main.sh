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

function get_github_latest_tag {
    version=""
    attempt_counter=0
    max_attempts=5

    until [ "$version" ]; do
        tags="$(curl -s "https://api.github.com/repos/$1/tags")"
        if [ "$tags" ]; then
            version="$(echo "$tags" | grep -Po '"name":.*?[^\\]",' | awk -F '"' 'NR==1{print $4}')"
            break
        elif [ ${attempt_counter} -eq ${max_attempts} ]; then
            echo "Max attempts reached"
            exit 1
        fi
        attempt_counter=$((attempt_counter + 1))
        sleep $((attempt_counter * 2))
    done

    echo "${version#*v}"
}

function main {
    local version=${PKG_FLY_VERSION:-$(get_github_latest_tag concourse/concourse)}

    if ! command -v fly || [[ "$(fly --version)" != "$version" ]]; then
        echo "INFO: Installing fly $version version..."

        OS="$(uname | tr '[:upper:]' '[:lower:]')"
        ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')"
        tarball="fly-$version-$OS-$ARCH.tgz"
        url="https://github.com/concourse/concourse/releases/download/v$version/$tarball"
        pushd "$(mktemp -d)" >/dev/null
        if [[ ${PKG_DEBUG:-false} == "true" ]]; then
            curl -L -o fly.tgz "$url"
            tar xvf fly.tgz
        else
            curl -sL -o fly.tgz "$url" 2>/dev/null
            tar xf fly.tgz
        fi
        chmod +x ./fly
        sudo mkdir -p /usr/local/bin/
        sudo mv ./fly /usr/local/bin/fly
        export PATH=$PATH:/usr/local/bin/
        popd >/dev/null
    fi
    sudo mkdir -p /etc/bash_completion.d
    fly completion --shell bash | sudo tee /etc/bash_completion.d/fly >/dev/null
}

main
