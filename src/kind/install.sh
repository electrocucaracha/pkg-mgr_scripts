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
if [[ ${PKG_DEBUG:-false} == "true" ]]; then
    set -o xtrace
fi

sudo_cmd=$(whoami | grep -q "root" || echo "sudo -H -E")

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
    rhel | centos | fedora)
        INSTALLER_CMD+="$(command -v dnf || command -v yum) -y"
        if [[ ${PKG_DEBUG:-false} == "false" ]]; then
            INSTALLER_CMD+=" --quiet --errorlevel=0"
        fi
        # shellcheck disable=SC2068
        $INSTALLER_CMD install $@
        ;;
    esac
}

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

function main {
    if ! command -v curl >/dev/null; then
        install_pkgs curl ca-certificates
        $sudo_cmd update-ca-certificates
    fi

    local version=${PKG_KIND_VERSION:-$(get_github_latest_release kubernetes-sigs/kind)}

    if ! command -v kind || [[ "v$(kind --version | awk '{print $3}')" != "$version" ]]; then
        OS="$(uname | tr '[:upper:]' '[:lower:]')"
        ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')"
        binary="kind-$OS-$ARCH"
        url="https://github.com/kubernetes-sigs/kind/releases/download/v${version}/$binary"

        echo "INFO: Installing kind $version version..."
        if [[ ${PKG_DEBUG:-false} == "true" ]]; then
            curl -Lo ./kind "$url"
        else
            curl -Lo ./kind "$url" 2>/dev/null
        fi
        chmod +x ./kind
        $sudo_cmd mkdir -p /usr/local/bin/
        $sudo_cmd mv ./kind /usr/local/bin/kind
        export PATH=$PATH:/usr/local/bin/
    fi
    $sudo_cmd mkdir -p /etc/bash_completion.d
    kind completion bash | $sudo_cmd tee /etc/bash_completion.d/kind >/dev/null
}

main
