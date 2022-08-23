#!/bin/bash
# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2019
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
    local version=${PKG_VAGRANT_VERSION:-$(get_github_latest_tag hashicorp/vagrant)}

    if ! command -v vagrant || [ "$(vagrant --version | awk '{ print $2}')" != "${version#*v}" ]; then
        echo "INFO: Installing vagrant $version version..."
        pushd "$(mktemp -d)" >/dev/null
        vagrant_pkg="vagrant_${version#*v}_$(uname -m)."
        vagrant_url_pkg="https://releases.hashicorp.com/vagrant/${version#*v}"
        # shellcheck disable=SC1091
        source /etc/os-release || source /usr/lib/os-release
        case ${ID,,} in
        opensuse*)
            vagrant_pgp="pgp_keys.asc"
            vagrant_pkg+="rpm"
            if [[ ${PKG_DEBUG:-false} == "true" ]]; then
                curl -o "$vagrant_pgp" "https://keybase.io/hashicorp/$vagrant_pgp"
                curl -o "$vagrant_pkg" "$vagrant_url_pkg/$vagrant_pkg"
                gpg --with-fingerprint "$vagrant_pgp"
            else
                curl -o "$vagrant_pgp" "https://keybase.io/hashicorp/$vagrant_pgp" 2>/dev/null
                curl -o "$vagrant_pkg" "$vagrant_url_pkg/$vagrant_pkg" 2>/dev/null
                gpg --quiet --with-fingerprint "$vagrant_pgp"
            fi
            sudo rpm --import "$vagrant_pgp"
            sudo rpm --checksig "$vagrant_pkg"
            sudo rpm --install "$vagrant_pkg"
            ;;
        ubuntu | debian)
            vagrant_pkg+="deb"
            if [[ ${PKG_DEBUG:-false} == "true" ]]; then
                curl -o "$vagrant_pkg" "$vagrant_url_pkg/$vagrant_pkg"
                sudo dpkg -i "$vagrant_pkg"
            else
                curl -o "$vagrant_pkg" "$vagrant_url_pkg/$vagrant_pkg" 2>/dev/null
                sudo dpkg -i "$vagrant_pkg" 2>/dev/null
            fi
            ;;
        rhel | centos | fedora)
            vagrant_pkg+="rpm"
            PKG_MANAGER=$(command -v dnf || command -v yum)
            if [[ ${PKG_DEBUG:-false} == "true" ]]; then
                curl -o "$vagrant_pkg" "$vagrant_url_pkg/$vagrant_pkg"
                sudo -H -E "${PKG_MANAGER}" -y install "$vagrant_pkg"
            else
                curl -o "$vagrant_pkg" "$vagrant_url_pkg/$vagrant_pkg" 2>/dev/null
                sudo -H -E "${PKG_MANAGER}" -y install --quiet --errorlevel=0 "$vagrant_pkg"
            fi
            ;;
        esac
        vagrant autocomplete install
        popd >/dev/null
    fi
}

main
