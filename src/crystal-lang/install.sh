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

function main {
    if command -v crystal; then
        return
    fi
    cmds=()
    if ! command -v sudo >/dev/null; then
        cmds+=(sudo)
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
    echo "INFO: Installing crystal..."

    # shellcheck disable=SC1091
    source /etc/os-release || source /usr/lib/os-release
    case ${ID,,} in
    *suse*)
        INSTALLER_CMD="$sudo_cmd zypper "
        if [[ ${PKG_DEBUG:-false} == "false" ]]; then
            INSTALLER_CMD+="-q "
        fi
        if [[ ${ID,,} == *leap* ]]; then
            $INSTALLER_CMD ar -f https://download.opensuse.org/repositories/devel:/languages:/crystal/openSUSE_Leap_15.2/devel:languages:crystal.repo
        elif [[ ${ID,,} == *tumbleweed* ]]; then
            $INSTALLER_CMD ar -f https://download.opensuse.org/repositories/devel:/languages:/crystal/openSUSE_Tumbleweed/devel:languages:crystal.repo
        fi
        $INSTALLER_CMD --gpg-auto-import-keys install -y --no-recommends crystal
        ;;
    *)
        curl -fsSL https://crystal-lang.org/install.sh | sudo bash
        ;;
    esac
}

main
