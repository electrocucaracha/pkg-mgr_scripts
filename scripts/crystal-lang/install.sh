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

function main {
    if command -v crystal; then
        return
    fi
    echo "INFO: Installing crystal..."

    # shellcheck disable=SC1091
    source /etc/os-release || source /usr/lib/os-release
    case ${ID,,} in
    *suse*)
        INSTALLER_CMD="sudo -H -E zypper "
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
    ubuntu | debian)
        sudo apt-get update
        INSTALLER_CMD="apt-get -y "
        if [[ ${PKG_DEBUG:-false} == "false" ]]; then
            INSTALLER_CMD+="-q=3 "
        fi
        eval "sudo -H -E $INSTALLER_CMD --no-install-recommends install wget"
        ;&
    *)
        curl -fsSL https://crystal-lang.org/install.sh | sudo bash
        ;;
    esac
}

main
