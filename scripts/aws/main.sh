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
    local version=${PKG_AWS_VERSION:-$(get_github_latest_tag aws/aws-cli)}

    if ! command -v aws || [ "$(aws --version | awk '{ print $1}' | sed 's|.*/||g')" != "${version#*v}" ]; then
        echo "INFO: Installing aws cli $version version..."
        pushd "$(mktemp -d)" >/dev/null
        if ! command -v unzip; then
            INSTALLER_CMD="sudo -H -E "
            # shellcheck disable=SC1091
            source /etc/os-release || source /usr/lib/os-release
            case ${ID,,} in
            *suse*)
                INSTALLER_CMD+="zypper "
                if [[ ${PKG_DEBUG:-false} == "false" ]]; then
                    INSTALLER_CMD+="-q "
                fi
                INSTALLER_CMD+="install -y --no-recommends"
                ;;
            ubuntu | debian)
                INSTALLER_CMD+="apt-get -y "
                if [[ ${PKG_DEBUG:-false} == "false" ]]; then
                    INSTALLER_CMD+="-q=3 "
                fi
                INSTALLER_CMD+=" --no-install-recommends install"
                ;;
            rhel | centos | fedora)
                INSTALLER_CMD+="$(command -v dnf || command -v yum) -y"
                if [[ ${PKG_DEBUG:-false} == "false" ]]; then
                    INSTALLER_CMD+=" --quiet --errorlevel=0"
                fi
                INSTALLER_CMD+=" install"
                ;;
            esac
            $INSTALLER_CMD unzip
        fi
        zip_file="awscli-exe-$(uname | tr '[:upper:]' '[:lower:]')-$(uname -m)-${version}.zip"
        url="https://awscli.amazonaws.com/$zip_file"
        if [[ ${PKG_DEBUG:-false} == "true" ]]; then
            curl -o aws.zip "$url"
            unzip aws.zip
        else
            curl -o aws.zip "$url" 2>/dev/null
            unzip -qq aws.zip
        fi
        sudo ./aws/install --update
        popd >/dev/null
    fi
}

main
