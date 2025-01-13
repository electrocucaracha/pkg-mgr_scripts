#!/bin/bash
# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2019
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

trap "make fmt" EXIT

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

rm -f ./ci/pinned_versions.env
blacklist="$(cat ./ci/blacklist_versions)"
while IFS= read -r line; do
    var=$(echo "${line#*\$\{}" | awk -F ':' '{ print $1}')
    if [[ ${blacklist} != *"${var}"* ]]; then
        func=$(echo "${line#*\$(}" | awk -F ')' '{ print $1}')
        echo "export ${var}=$($func)" >>./ci/pinned_versions.env
    fi
done < <(grep -r "_VERSION.*get_github_latest" src/ | awk -F '=' '{print $2}')
echo "$blacklist" | tee --append ./ci/pinned_versions.env
sort -o ./ci/pinned_versions.env ./ci/pinned_versions.env

# Update GitHub Action commit hashes
gh_actions=$(grep -r "uses: [a-zA-Z\-]*/[\_a-z\-]*@" .github/ | sed 's/@.*//' | awk -F ': ' '{ print $3 }' | sort -u)
for action in $gh_actions; do
    commit_hash=$(git ls-remote "https://github.com/$action" | grep 'refs/tags/[v]\?[0-9][0-9\.]*$' | sed 's|refs/tags/[vV]\?[\.]\?||g' | sort -u -k2 -V | tail -1 | awk '{ printf "%s # %s\n",$1,$2 }')
    # shellcheck disable=SC2267
    grep -ElRZ "uses: $action@" .github/ | xargs -0 -l sed -i -e "s|uses: $action@.*|uses: $action@$commit_hash|g"
done
