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
if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
    set -o xtrace
fi

function get_cpu_arch {
    if [ -z "${PKG_CPU_ARCH:-}" ]; then
        case "$(uname -m)" in
            x86_64)
                PKG_CPU_ARCH=amd64
            ;;
            armv8*)
                PKG_CPU_ARCH=arm64
            ;;
            aarch64*)
                PKG_CPU_ARCH=arm64
            ;;
            armv*)
                PKG_CPU_ARCH=armv7
            ;;
        esac
    fi
    echo "$PKG_CPU_ARCH"
}

function main {
    local version=${PKG_TERRAFORM_VERSION:-}

    attempt_counter=0
    max_attempts=5
    until [ "$version" ]; do
        release="$(curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest)"
        if [ "$release" ]; then
            version="$(echo "$release" | grep -Po '"name":.*?[^\\]",' | awk -F  "\"" 'NR==1{print $4}')"
            break
        elif [ ${attempt_counter} -eq ${max_attempts} ];then
            echo "Max attempts reached"
            exit 1
        fi
        attempt_counter=$((attempt_counter+1))
        sleep 2
    done

    if ! command -v terraform || [ "$(terraform version | awk '{ print $2}')" != "$version" ]; then
        echo "INFO: Installing terraform $version version..."
        pushd "$(mktemp -d)" > /dev/null
        if ! command -v unzip; then
            INSTALLER_CMD="sudo -H -E "
            # shellcheck disable=SC1091
            source /etc/os-release || source /usr/lib/os-release
            case ${ID,,} in
                *suse*)
                    INSTALLER_CMD+="zypper "
                    if [[ "${PKG_DEBUG:-false}" == "false" ]]; then
                        INSTALLER_CMD+="-q "
                    fi
                    INSTALLER_CMD+="install -y --no-recommends"
                ;;
                ubuntu|debian)
                    INSTALLER_CMD+="apt-get -y "
                    if [[ "${PKG_DEBUG:-false}" == "false" ]]; then
                        INSTALLER_CMD+="-q=3 "
                    fi
                    INSTALLER_CMD+=" --no-install-recommends install"
                ;;
                rhel|centos|fedora)
                    INSTALLER_CMD+="$(command -v dnf || command -v yum) -y"
                    if [[ "${PKG_DEBUG:-false}" == "false" ]]; then
                        INSTALLER_CMD+=" --quiet --errorlevel=0"
                    fi
                    INSTALLER_CMD+=" install"
                ;;
            esac
            $INSTALLER_CMD unzip
        fi
        url="https://releases.hashicorp.com/terraform/${version#*v}/terraform_${version#*v}_$(uname | awk '{print tolower($0)}')_$(get_cpu_arch).zip"
        if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
            curl -o terraform.zip "$url"
            unzip terraform.zip
        else
            curl -o terraform.zip "$url" 2>/dev/null
            unzip -qq terraform.zip
        fi
        sudo mkdir -p /usr/local/bin/
        sudo mv terraform /usr/local/bin/
        mkdir -p ~/.terraform.d/plugins
        popd > /dev/null
    fi
}

main
