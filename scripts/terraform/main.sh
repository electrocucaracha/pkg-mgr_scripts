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

function get_github_latest_release {
    version=""
    attempt_counter=0
    max_attempts=5

    until [ "$version" ]; do
        url_effective=$(curl -sL -o /dev/null -w '%{url_effective}' "https://github.com/$1/releases/latest")
        if [ "$url_effective" ]; then
            version="${url_effective##*/}"
            break
        elif [ ${attempt_counter} -eq ${max_attempts} ];then
            echo "Max attempts reached"
            exit 1
        fi
        attempt_counter=$((attempt_counter+1))
        sleep $((attempt_counter*2))
    done
    echo "${version#v}"
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
            die $LINENO "unrecognised op: $op"
            ;;
    esac
}

function main {
    local version=${PKG_TERRAFORM_VERSION:-$(get_github_latest_release hashicorp/terraform)}
    local docs_version=${PKG_TERRAFORM_DOCS_VERSION:-$(get_github_latest_release terraform-docs/terraform-docs)}

    OS="$(uname | tr '[:upper:]' '[:lower:]')"
    ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')"

    if ! command -v terraform || [ "$(terraform version | awk 'NR==1{print $2}')" != "v${version#*v}" ]; then
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
        zip_file="terraform_${version#*v}_${OS}_$ARCH.zip"
        url="https://releases.hashicorp.com/terraform/${version#*v}/$zip_file"
        if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
            curl -o terraform.zip "$url"
            unzip terraform.zip
        else
            curl -o terraform.zip "$url" 2>/dev/null
            unzip -qq terraform.zip
        fi
        sudo mkdir -p /usr/local/bin/
        sudo mv terraform /usr/local/bin/
        if _vercmp "$version" '<' "0.13"; then
            mkdir -p ~/.terraform.d/plugins
        else
            mkdir -p ~/.local/share/terraform/plugins/registry.terraform.io/
        fi
        popd > /dev/null
    fi
    if ! command -v terraform-docs || [ "$(terraform-docs version | awk '{ print $3}')" != "${docs_version#*v}" ]; then
        echo "INFO: Installing terraform-docs $docs_version version..."

        curl -s "https://i.jpillora.com/terraform-docs/terraform-docs@v${docs_version#*v}!!" | bash
        terraform-docs completion bash | sudo tee /etc/bash_completion.d/terraform-docs > /dev/null
    fi
}

main
