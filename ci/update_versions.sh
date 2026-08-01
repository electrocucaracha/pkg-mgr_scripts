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
        find . -name devcontainer-feature.json -exec sed -i "s/default\": \".* \/\/ $var/default\": \"$($func)\" \/\/ $var/g" {} \;
    fi
done < <(grep -r "_VERSION.*get_github_latest" src/ | awk -F '=' '{print $2}')
[[ -n $blacklist ]] && echo "$blacklist" | tee --append ./ci/pinned_versions.env
sort -o ./ci/pinned_versions.env ./ci/pinned_versions.env

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

update_github_action_hashes() {
    local gh_actions action is_exception ex commit_hash file
    gh_actions=$(grep -rhoE 'uses: [^@]+@' .github/ |
        sed -E 's/uses: ([^@]+)@/\1/' |
        sort -u)

    readonly exceptions=()

    for action in $gh_actions; do
        is_exception=false
        for ex in "${exceptions[@]}"; do
            if [[ $action == "$ex" ]]; then
                is_exception=true
                break
            fi
        done
        [[ $is_exception == true ]] && continue

        commit_hash=$(
            git ls-remote --tags "https://github.com/$action" |
                awk '
            {
                sha=$1
                ref=$2
                if (ref ~ /\^\{\}$/) {
                    tag=ref
                    sub(/\^\{\}$/, "", tag)
                    commits[tag]=sha
                } else {
                    tags[ref]=sha
                }
            }
            END {
                for (ref in tags) {
                    sha = (ref in commits ? commits[ref] : tags[ref])
                    tag = ref
                    sub(/^refs\/tags\//, "", tag)
                    if (tag ~ /^v?[0-9]+(\.[0-9]+)*$/) {
                        sortkey = tag
                        sub(/^v/, "", sortkey)
                        print sortkey "\t" sha "\t" tag
                    }
                }
            }' |
                sort -V |
                tail -1 |
                awk -F'\t' '{ printf "%s # %s\n", $2, $3 }'
        )

        if [[ -z $commit_hash ]]; then
            echo "WARNING: unable to resolve tag for $action; skipping" >&2
            continue
        fi

        while IFS= read -r -d '' file; do
            sed -i -e "s|uses: $action@.*|uses: $action@$commit_hash|g" "$file"
        done < <(grep -ElRZ "uses: $action@" .github/)
    done
}

update_github_action_hashes
