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

# _vercmp() - Function that compares two versions
function _vercmp {
    local v1=$1
    local op=$2
    local v2=$3
    local result

    # sort the two numbers with sort's "-V" argument.  Based on if v2
    # swapped places with v1, we can determine ordering.
    result=$(echo -e "$v1\n$v2" | sort -V | head -1)

    case $op in
    "==")
        [ "$v1" = "$v2" ]
        return
        ;;
    ">")
        [ "$v1" != "$v2" ] && [ "$result" = "$v2" ]
        return
        ;;
    "<")
        [ "$v1" != "$v2" ] && [ "$result" = "$v1" ]
        return
        ;;
    ">=")
        [ "$result" = "$v2" ]
        return
        ;;
    "<=")
        [ "$result" = "$v1" ]
        return
        ;;
    *)
        echo "unrecognised op: $op"
        exit 1
        ;;
    esac
}

function main {
    local version=${PKG_VAGRANT_VERSION:-$(get_github_latest_tag hashicorp/vagrant)}

    if ! command -v vagrant || [ "$(vagrant --version | awk '{ print $2}')" != "${version#*v}" ]; then
        echo "INFO: Installing vagrant $version version..."
        pushd "$(mktemp -d)" >/dev/null
        vagrant_pkg="vagrant_${version#*v}_$(uname -m)."
        if _vercmp "${version#*v}" '>=' "2.3.0"; then
            vagrant_pkg="vagrant-${version#*v}-1.$(uname -m)."
        fi
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
            if _vercmp "${version#*v}" '>=' "2.3.0"; then
                if _vercmp "$VERSION_ID" '<' "20.04"; then
                    echo "Vagrant ${version#*v} requires +GLIBC_2.25 and XCRYPT_2.0 not provided by $PRETTY_NAME"
                    exit 1
                fi
                vagrant_pkg="vagrant_${version#*v}_$(uname | tr '[:upper:]' '[:lower:]')_$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/').zip"
            else
                vagrant_pkg+="deb"
            fi
            if [[ ${PKG_DEBUG:-false} == "true" ]]; then
                curl -o "$vagrant_pkg" "$vagrant_url_pkg/$vagrant_pkg"
            else
                curl -o "$vagrant_pkg" "$vagrant_url_pkg/$vagrant_pkg" 2>/dev/null
            fi
            if [[ $vagrant_pkg == *".zip" ]]; then
                sudo unzip "$vagrant_pkg" -d /usr/bin
                sudo apt-get update
                sudo apt-get install -y --no-install-recommends libarchive-tools
            else
                if [[ ${PKG_DEBUG:-false} == "true" ]]; then
                    sudo dpkg -i "$vagrant_pkg"
                else
                    sudo dpkg -i "$vagrant_pkg" 2>/dev/null
                fi
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
