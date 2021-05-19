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

function get_github_latest_tag {
    version=""
    attempt_counter=0
    max_attempts=5

    until [ "$version" ]; do
        tags="$(curl -s "https://api.github.com/repos/$1/tags")"
        if [ "$tags" ]; then
            version="$(echo "$tags" | grep -Po '"name":.*?[^\\]",' | awk -F  "\"" 'NR==1{print $4}')"
            break
        elif [ ${attempt_counter} -eq ${max_attempts} ];then
            echo "Max attempts reached"
            exit 1
        fi
        attempt_counter=$((attempt_counter+1))
        sleep 2
    done

    echo "${version#*v}"
}

function main {
    local version=${PKG_KN_VERSION:-$(get_github_latest_tag knative/client)}

    if ! command -v kn || [[ "v$(kn version | awk 'NR==1{print $2}')" != "$version" ]]; then
        echo "INFO: Installing Knative client $version version..."

        OS="$(uname | tr '[:upper:]' '[:lower:]')"
        ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')"
        binary="kn-$OS-$ARCH"
        url="https://github.com/knative/client/releases/download/v${version}/$binary"
        if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
            curl -Lo ./kn "$url"
        else
            curl -Lo ./kn "$url" 2> /dev/null
        fi
        chmod +x ./kn
        sudo mkdir -p /usr/local/bin/
        sudo mv ./kn /usr/local/bin/kn
        export PATH=$PATH:/usr/local/bin/
    fi
    kn completion bash | sudo tee /etc/bash_completion.d/kn > /dev/null
}

main
