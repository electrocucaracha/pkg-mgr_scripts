#!/bin/bash
# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2022
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

set -o errexit
set -o pipefail
if [[ ${DEBUG:-false} == "true" ]]; then
    set -o xtrace
fi

if ! command -v yq >/dev/null; then
    curl -s 'https://i.jpillora.com/mikefarah/yq!!' | bash
    export PATH=$PATH:/usr/local/bin/
fi
if ! command -v jq >/dev/null; then
    sudo apt-get update
    sudo apt-get install -y --no-install-recommends jq
fi

function get_query {
    local script="$1"
    local output="$2"

    if [ -f "src/$script/os-blacklist.conf" ]; then
        query=".linux[] | select("
        for os_alias in $(yq '.linux[].alias' distros_supported.yml); do
            if ! grep -q "$os_alias" "src/$script/os-blacklist.conf"; then
                query+=".alias == \"$os_alias\" or "
            fi
        done
        query="${query::-4}).$output"
    else
        query=".linux[].$output"
    fi
    printf "%s" "$query"
}

matrix_alias="[  "
matrix_image="[  "
for script in $(jq -r '.[]' <<<"$1"); do
    for _alias in $(yq "$(get_query "$script" "alias")" distros_supported.yml); do
        matrix_alias+="{ \"script\": \"$script\", \"name\": \"$_alias\"}, "
    done
    if [ -f "src/$script/devcontainer-feature.json" ]; then
        for _alias in $(yq "$(get_query "$script" "image")" distros_supported.yml); do
            matrix_image+="{ \"script\": \"$script\", \"image\": \"$_alias\"}, "
        done
    fi
done

echo "matrix-alias=$(jq . -c <<<"${matrix_alias::-2}]")" >>"$GITHUB_OUTPUT"
echo "matrix-image=$(jq . -c <<<"${matrix_image::-2}]")" >>"$GITHUB_OUTPUT"
