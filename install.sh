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
PKG_MGR_PIP_REQUIRED="pip_required"

declare -A pkg_mgr_supported

pkg_mgr_supported[bind-utils]="{\"Suse\": \"$PKG_MGR_UNSUPPORTED\",\"Debian\": \"$PKG_MGR_UNSUPPORTED\",\"RedHat\": \"bind-utils\",\"ClearLinux\": \"$PKG_MGR_UNSUPPORTED\"}"
pkg_mgr_supported[gpgme]="{\"Suse\": \"$PKG_MGR_UNSUPPORTED\",\"Debian\": \"$PKG_MGR_UNSUPPORTED\",\"RedHat\": \"gpgme\",\"ClearLinux\": \"$PKG_MGR_UNSUPPORTED\"}"
pkg_mgr_supported[gpgme-devel]="{\"Suse\": \"$PKG_MGR_UNSUPPORTED\",\"Debian\": \"$PKG_MGR_UNSUPPORTED\",\"RedHat\": \"gpgme-devel\",\"ClearLinux\": \"$PKG_MGR_UNSUPPORTED\"}"
pkg_mgr_supported[krb5-devel]="{\"Suse\": \"$PKG_MGR_UNSUPPORTED\",\"Debian\": \"libkrb5-dev\",\"RedHat\": \"krb5-devel\",\"ClearLinux\": \"$PKG_MGR_UNSUPPORTED\"}"
pkg_mgr_supported[libassuan]="{\"Suse\": \"$PKG_MGR_UNSUPPORTED\",\"Debian\": \"$PKG_MGR_UNSUPPORTED\",\"RedHat\": \"libassuan\",\"ClearLinux\": \"$PKG_MGR_UNSUPPORTED\"}"
pkg_mgr_supported[libassuan-devel]="{\"Suse\": \"$PKG_MGR_UNSUPPORTED\",\"Debian\": \"$PKG_MGR_UNSUPPORTED\",\"RedHat\": \"libassuan-devel\",\"ClearLinux\": \"$PKG_MGR_UNSUPPORTED\"}"
pkg_mgr_supported[mkpasswd]="{\"Suse\": \"$PKG_MGR_UNSUPPORTED\",\"Debian\": \"mkpasswd\",\"RedHat\": \"expect\",\"ClearLinux\": \"sysadmin-basic\"}"
pkg_mgr_supported[python-devel]="{\"Suse\": \"python-devel\",\"Debian\": \"python-dev\",\"RedHat\": \"python3-devel\",\"ClearLinux\": \"python-basic\"}"
pkg_mgr_supported[tito]="{\"Suse\": \"$PKG_MGR_UNSUPPORTED\",\"Debian\": \"$PKG_MGR_UNSUPPORTED\",\"RedHat\": \"tito\",\"ClearLinux\": \"$PKG_MGR_UNSUPPORTED\"}"

pkg_mgr_supported[docker]="{\"Suse\": \"$PKG_MGR_SUPPORTED\",\"Debian\": \"$PKG_MGR_SUPPORTED\",\"RedHat\": \"$PKG_MGR_SUPPORTED\",\"ClearLinux\": \"$PKG_MGR_SUPPORTED\"}"
pkg_mgr_supported[golang]="{\"Suse\": \"$PKG_MGR_SUPPORTED\",\"Debian\": \"$PKG_MGR_SUPPORTED\",\"RedHat\": \"$PKG_MGR_SUPPORTED\",\"ClearLinux\": \"$PKG_MGR_SUPPORTED\"}"
pkg_mgr_supported[pip]="{\"Suse\": \"$PKG_MGR_SUPPORTED\",\"Debian\": \"$PKG_MGR_SUPPORTED\",\"RedHat\": \"$PKG_MGR_SUPPORTED\",\"ClearLinux\": \"$PKG_MGR_SUPPORTED\"}"
pkg_mgr_supported[vagrant]="{\"Suse\": \"$PKG_MGR_SUPPORTED\",\"Debian\": \"$PKG_MGR_SUPPORTED\",\"RedHat\": \"$PKG_MGR_SUPPORTED\",\"ClearLinux\": \"$PKG_MGR_SUPPORTED\"}"
pkg_mgr_supported[virtualbox]="{\"Suse\": \"$PKG_MGR_SUPPORTED\",\"Debian\": \"$PKG_MGR_SUPPORTED\",\"RedHat\": \"$PKG_MGR_SUPPORTED\",\"ClearLinux\": \"$PKG_MGR_UNSUPPORTED\"}"
pkg_mgr_supported[terraform]="{\"Suse\": \"$PKG_MGR_SUPPORTED\",\"Debian\": \"$PKG_MGR_SUPPORTED\",\"RedHat\": \"$PKG_MGR_SUPPORTED\",\"ClearLinux\": \"$PKG_MGR_SUPPORTED\"}"

pkg_mgr_supported[ansible]="{\"Suse\": \"$PKG_MGR_PIP_REQUIRED\",\"Debian\": \"$PKG_MGR_PIP_REQUIRED\",\"RedHat\": \"$PKG_MGR_PIP_REQUIRED\",\"ClearLinux\": \"$PKG_MGR_PIP_REQUIRED\"}"
pkg_mgr_supported[docker-compose]="{\"Suse\": \"$PKG_MGR_PIP_REQUIRED\",\"Debian\": \"$PKG_MGR_PIP_REQUIRED\",\"RedHat\": \"$PKG_MGR_PIP_REQUIRED\",\"ClearLinux\": \"$PKG_MGR_PIP_REQUIRED\"}"

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
        if ! sudo "$PKG_MANAGER" repolist | grep "epel/"; then
            sudo -H -E "$PKG_MANAGER" -q -y install epel-release
        fi
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
    sanity_pkgs=""
    for pkg in $PKG; do
        json_pkg="${pkg_mgr_supported[$pkg]}"
        if [[ -n "${json_pkg}" ]]; then
            distro_pkg=$(echo "$json_pkg" | grep -oP "(?<=\"$PKG_OS_FAMILY\": \")[^\"]*")
            if [[ "$distro_pkg" == "$PKG_MGR_SUPPORTED" ]]; then
                curl -fsSL "https://raw.githubusercontent.com/electrocucaracha/pkg-mgr/master/${pkg}/main.sh" | bash
            elif [[ "$distro_pkg" == "$PKG_MGR_PIP_REQUIRED" ]]; then
                if ! command -v pip; then
                    curl -fsSL "https://raw.githubusercontent.com/electrocucaracha/pkg-mgr/master/pip/main.sh" | bash
                fi
                PIP_CMD="sudo -E $(command -v pip) install"
                $PIP_CMD "$pkg"
            elif [[ "$distro_pkg" != "$PKG_MGR_UNSUPPORTED" ]]; then
                sanity_pkgs+=" $distro_pkg"
            fi
        else
            sanity_pkgs+=" $pkg"
        fi
    done
    if [[ -n "${sanity_pkgs}" ]]; then
        eval "$INSTALLER_CMD $sanity_pkgs"
    fi
fi
