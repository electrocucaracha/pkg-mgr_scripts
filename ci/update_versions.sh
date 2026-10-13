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

function bump_devcontainer_feature_version {
    local file current_version major minor patch new_version

    current_version="$(sed -nE 's/^[[:space:]]*"version":[[:space:]]*"([0-9]+\.[0-9]+\.[0-9]+)".*/\1/p' "${file}" | head -n1)"
    if [[ -z ${current_version} ]]; then
        echo "WARNING: unable to parse version in ${file}; skipping bump" >&2
        return
    fi

    IFS='.' read -r major minor patch <<<"${current_version}"
    patch=$((patch + 1))
    new_version="${major}.${minor}.${patch}"

    sed -i -E "0,/\"version\":[[:space:]]*\"[0-9]+\.[0-9]+\.[0-9]+\"/s//\"version\": \"${new_version}\"/" "${file}"
}

rm -f ./ci/pinned_versions.env
devcontainer_checksums_file="$(mktemp)"
find ./src -name devcontainer-feature.json -type f -exec sh -c '
    for file; do
        checksum="$(shasum "$file" | awk "{print \\$1}")"
        printf "%s\t%s\n" "$checksum" "$file"
    done
' sh {} + >"${devcontainer_checksums_file}"

blacklist="$(cat ./ci/blacklist_versions)"
while IFS= read -r line; do
    var=$(echo "${line#*\$\{}" | awk -F ':' '{ print $1}')
    if [[ ${blacklist} != *"${var}"* ]]; then
        func=$(echo "${line#*\$(}" | awk -F ')' '{ print $1}')
        value="$($func)"
        echo "export ${var}=${value}" >>./ci/pinned_versions.env
        find . -name devcontainer-feature.json -exec sed -i "s/default\": \".* \/\/ $var/default\": \"${value}\" \/\/ $var/g" {} \;
    fi
done < <(grep -r "_VERSION.*get_github_latest" src/ | awk -F '=' '{print $2}')
[[ -n $blacklist ]] && echo "$blacklist" | tee --append ./ci/pinned_versions.env
sort -o ./ci/pinned_versions.env ./ci/pinned_versions.env

while IFS=$'\t' read -r previous_checksum file; do
    [[ -z ${file} ]] && continue
    current_checksum="$(shasum "${file}" | awk '{print $1}')"
    if [[ ${previous_checksum} != "${current_checksum}" ]]; then
        bump_devcontainer_feature_version "${file}"
    fi
done <"${devcontainer_checksums_file}"
rm -f "${devcontainer_checksums_file}"

go_version="$(curl -sL https://golang.org/VERSION?m=text | sed -n 's/go//;s/\..$//;1p')"
find .github/workflows -type f \( -name '*.yml' -o -name '*.yaml' \) \
    -exec grep -l 'go-version:' {} + \
    -exec env go_version="${go_version}" bash -s {} + <<'EOF'
    for file; do
        sed -i \
            "s|^\([[:space:]]*go-version:[[:space:]]*\).*|\
\1\"^${go_version}\"|" \
            "${file}"
    done
EOF

if ! command -v uvx >/dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi
uvx pre-commit autoupdate
uv run --no-project --with git+https://github.com/electrocucaracha/gh-updater.git gh-updater .
uvx --refresh zizmor --offline --min-severity low .github/ --fix=all
