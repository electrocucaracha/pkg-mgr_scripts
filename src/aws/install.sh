#!/bin/bash
# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2021
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

# @file AWS installer
# @brief Installs AWS command-line tools.
# @description This reference describes the script entry point and its implementation helpers. Configure optional behavior with PKG_ environment variables documented in the component README.
set -o nounset
set -o errexit
set -o pipefail
if [[ ${PKG_DEBUG:-false} == "true" ]]; then
    set -o xtrace
fi

sudo_cmd=$(whoami | grep -q "root" || echo "sudo -H -E")

# @description Installs supplied packages with the detected operating system package manager.
# @arg $@ string Package names to install.
# @set INSTALLER_CMD string Command used to install packages.
function install_pkgs {
    INSTALLER_CMD="$sudo_cmd "
    # shellcheck disable=SC1091
    source /etc/os-release || source /usr/lib/os-release
    case ${ID,,} in
    *suse*)
        INSTALLER_CMD+="zypper "
        if [[ ${PKG_DEBUG:-false} == "false" ]]; then
            INSTALLER_CMD+="-q "
        fi
        # shellcheck disable=SC2068
        $INSTALLER_CMD install -y --no-recommends $@
        ;;
    ubuntu | debian)
        $sudo_cmd apt update
        INSTALLER_CMD+="apt-get -y --force-yes "
        if [[ ${PKG_DEBUG:-false} == "false" ]]; then
            INSTALLER_CMD+="-q=3 "
        fi
        # shellcheck disable=SC2068
        $INSTALLER_CMD --no-install-recommends install $@
        ;;
    rhel | centos | fedora | rocky)
        INSTALLER_CMD+="$(command -v dnf || command -v yum) -y"
        if [[ ${PKG_DEBUG:-false} == "false" ]]; then
            INSTALLER_CMD+=" --quiet --errorlevel=0"
        fi
        # shellcheck disable=SC2068
        $INSTALLER_CMD install $@
        ;;
    esac
    export INSTALLER_CMD
}

# @description Resolves the latest GitHub tag for a repository.
# @arg $1 string GitHub repository in owner/repository form.
# @stdout Latest tag version without the v prefix.
# @exitcode 1 When the latest tag cannot be resolved after retries.
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

# @description Runs this script's installation or validation workflow.
# @noargs
# @exitcode 0 When the workflow completes successfully.
# @exitcode 1 When a required command fails.
function main {
    cmds=()
    if ! command -v unzip >/dev/null; then
        cmds+=(unzip)
    fi
    if ! command -v curl >/dev/null; then
        cmds+=(curl ca-certificates)
    fi
    if [ ${#cmds[@]} != 0 ]; then
        # shellcheck disable=SC2068
        install_pkgs ${cmds[@]}
    fi
    if command -v update-ca-certificates >/dev/null; then
        $sudo_cmd update-ca-certificates
    fi
    local version=${PKG_AWS_VERSION:-$(get_github_latest_tag aws/aws-cli)}

    if ! command -v aws || [ "$(aws --version | awk '{ print $1}' | sed 's|.*/||g')" != "${version#*v}" ]; then
        echo "INFO: Installing aws cli $version version..."
        pushd "$(mktemp -d)" >/dev/null
        zip_file="awscli-exe-$(uname | tr '[:upper:]' '[:lower:]')-$(uname -m)-${version}.zip"
        url="https://awscli.amazonaws.com/$zip_file"
        if [[ ${PKG_DEBUG:-false} == "true" ]]; then
            curl -o aws.zip "$url"
            unzip aws.zip
        else
            curl -o aws.zip "$url" 2>/dev/null
            unzip -qq aws.zip
        fi
        $sudo_cmd ./aws/install --update
        popd >/dev/null
    fi
}

main
