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

OS="$(uname | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')"
cni_folder=${PKG_CNI_PLUGINS_FOLDER:-/opt/containernetworking/plugins}
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

function _install_flannel {
    local flannel_version=${PKG_FLANNEL_VERSION:-$(get_github_latest_release flannel-io/cni-plugin)}
    local url="https://github.com/flannel-io/cni-plugin/releases/download/v${flannel_version}/flannel-${ARCH}"

    if [[ ${PKG_DEBUG:-false} == "true" ]]; then
        $sudo_cmd curl -Lo "${cni_folder}/flannel" "$url"
    else
        $sudo_cmd curl -Lo "${cni_folder}/flannel" "$url" >/dev/null
    fi
    $sudo_cmd chmod +x "${cni_folder}/flannel"
}

function main {
    cmds=()
    for cmd in tar gzip; do
        if ! command -v $cmd >/dev/null; then
            cmds+=("$cmd")
        fi
    done
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

    $sudo_cmd mkdir -p "$cni_folder"
    if [ -z "$(ls -A "$cni_folder")" ]; then
        version=${PKG_CNI_PLUGINS_VERSION:-$(get_github_latest_release containernetworking/plugins)}
        echo "INFO: Installing CNI plugins $version version..."

        pushd "$(mktemp -d)" >/dev/null
        tarball="cni-plugins-$OS-$ARCH-v${version}.tgz"
        url="https://github.com/containernetworking/plugins/releases/download/v${version}/${tarball}"
        if [[ ${PKG_DEBUG:-false} == "true" ]]; then
            curl -Lo cni-plugins.tgz "$url"
            $sudo_cmd tar xvf cni-plugins.tgz -C "$cni_folder"
        else
            curl -Lo cni-plugins.tgz "$url" >/dev/null
            $sudo_cmd tar xf cni-plugins.tgz -C "$cni_folder"
        fi
        popd >/dev/null
    fi
    # Install flannel cni
    if [[ ${PKG_CNI_PLUGINS_INSTALL_FLANNEL:-false} == "true" ]] && [ ! -f "${cni_folder}/flannel" ]; then
        _install_flannel
    fi
    $sudo_cmd chown "$(whoami)" -R "$cni_folder"
}

main
