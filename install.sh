#!/bin/bash
# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2019
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

set -o errexit
set -o pipefail
set -o xtrace

PKG_MGR_UNSUPPORTED="unsupported"
PKG_MGR_SUPPORTED="supported"

declare -A pkg_mgr_supported

pkg_mgr_supported[openjdk]="{\"Suse\": \"openjdk-8-jre\",\"Debian\": \"openjdk-8-jre\",\"RedHat\": \"java-1.8.0-openjdk\",\"ClearLinux\": \"java-basic\"}"
pkg_mgr_supported[docker]="{\"Suse\": \"$PKG_MGR_UNSUPPORTED\",\"Debian\": \"$PKG_MGR_SUPPORTED\",\"RedHat\": \"$PKG_MGR_SUPPORTED\",\"ClearLinux\": \"$PKG_MGR_SUPPORTED\"}"

if ! sudo -n "true"; then
    echo ""
    echo "passwordless sudo is needed for '$(id -nu)' user."
    echo "Please fix your /etc/sudoers file. You likely want an"
    echo "entry like the following one..."
    echo ""
    echo "$(id -nu) ALL=(ALL) NOPASSWD: ALL"
    exit 1
fi

function _update_repos {
    case ${PKG_OS_FAMILY} in
        Suse)
        sudo zypper -n ref
        ;;
        Debian)
        sudo apt-get update
        ;;
        RedHat)
        PKG_MANAGER=$(command -v dnf || command -v yum)
        sudo "$PKG_MANAGER" updateinfo
        ;;
        ClearLinux)
        sudo swupd update --download
        ;;
    esac
}

# shellcheck disable=SC1091
source /etc/os-release || source /usr/lib/os-release
case ${ID,,} in
    *suse*)
    INSTALLER_CMD="sudo -H -E zypper -q install -y --no-recommends"
    PKG_OS_FAMILY="Suse"
    ;;
    ubuntu|debian)
    INSTALLER_CMD="sudo -H -E apt-get -y -q=3 install"
    PKG_OS_FAMILY="Debian"
    ;;
    rhel|centos|fedora)
    PKG_MANAGER=$(command -v dnf || command -v yum)
    INSTALLER_CMD="sudo -H -E ${PKG_MANAGER} -q -y install"
    PKG_OS_FAMILY="RedHat"
    ;;
    clear-linux-os)
    INSTALLER_CMD="sudo -H -E swupd bundle-add --quiet"
    PKG_OS_FAMILY="ClearLinux"
    ;;
esac

if [[ "${PKG_UDPATE:-false}" == "true" ]]; then
    _update_repos
fi

if [[ -n ${PKG+x} ]]; then
    json_pkg="${pkg_mgr_supported[$PKG]}"
    if [[ -n "${json_pkg}" ]]; then
        distro_pkg=$(echo "$json_pkg" | grep -oP "(?<=\"$PKG_OS_FAMILY\": \")[^\"]*")
        if [[ "$distro_pkg" == "$PKG_MGR_SUPPORTED" ]]; then
            curl -fsSL "https://raw.githubusercontent.com/electrocucaracha/pkg-mgr/master/${PKG}/main.sh" | bash
        elif [[ "$distro_pkg" != "$PKG_MGR_UNSUPPORTED" ]]; then
            $INSTALLER_CMD "$distro_pkg"
        fi
    else
        $INSTALLER_CMD "$PKG"
    fi
fi
