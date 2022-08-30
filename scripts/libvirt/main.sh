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
        echo "unrecognised op: $op"
        exit 1
        ;;
    esac
}

function main {
    local libvirt_group="libvirt"

    pkgs=""
    # shellcheck disable=SC1091
    source /etc/os-release || source /usr/lib/os-release
    case ${ID,,} in
    *suse*)
        INSTALLER_CMD="zypper"
        if [[ ${PKG_DEBUG:-false} == "false" ]]; then
            INSTALLER_CMD+=" -q"
        fi
        INSTALLER_CMD+=" install -y --no-recommends"
        pkgs+=" libvirt libvirt-devel zlib-devel"
        pkgs+=" libxml2-devel libxslt-devel"
        sudo zypper -n ref
        ;;
    ubuntu | debian)
        INSTALLER_CMD="apt-get -y --no-install-recommends"
        if [[ ${PKG_DEBUG:-false} == "false" ]]; then
            INSTALLER_CMD+=" -q=3"
        fi
        INSTALLER_CMD+=" install"
        if _vercmp "${VERSION_ID}" '<=' "16.04"; then
            libvirt_group+="d"
        fi
        if _vercmp "${VERSION_ID}" '<' "20.04"; then
            pkgs+=" libvirt-bin"
        else
            pkgs+=" libvirt-daemon-system"
        fi
        pkgs+=" libvirt-dev libxslt-dev libxml2-dev"
        pkgs+=" zlib1g-dev cpu-checker"
        echo '* libraries/restart-without-asking boolean true' | sudo debconf-set-selections
        sudo apt-get update
        ;;
    rhel | centos | fedora)
        PKG_MANAGER=$(command -v dnf || command -v yum)
        INSTALLER_CMD="${PKG_MANAGER} -y"
        if [[ ${PKG_DEBUG:-false} == "false" ]]; then
            INSTALLER_CMD+=" --quiet --errorlevel=0"
        fi
        INSTALLER_CMD+=" install"
        pkgs+=" libvirt libvirt-devel"
        sudo "$PKG_MANAGER" updateinfo --assumeyes
        ;;
    *)
        # MacOS
        if command -v sw_vers; then
            if ! command -v brew; then
                ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
            fi
            brew install qemu libvirt
            sudo sed -i '' 's|^#unix_sock_rw_perms = .*$|unix_sock_rw_perms = "0770"|g' /usr/local/etc/libvirt/libvirtd.conf
            sudo brew services start libvirt
            sudo ln -sf /usr/local/var/run/libvirt /var/run/libvirt
        fi
        ;;
    esac
    echo "INFO: Installing libvirt packages ($pkgs)..."
    # shellcheck disable=SC2086
    sudo -H -E $INSTALLER_CMD $pkgs
    sudo usermod -a -G $libvirt_group "$USER"
    if [ -f /etc/apparmor.d/usr.sbin.libvirtd ] && ! grep -q "/usr/local/bin/* PUx," /etc/apparmor.d/usr.sbin.libvirtd; then
        echo "INFO: Enable discrete profile execution of local binaries"
        sudo sed -i '/\/usr\/bin\/\* PUx,/a\/usr\/local\/bin\/\* PUx,' /etc/apparmor.d/usr.sbin.libvirtd
        if systemctl is-active --quiet apparmor; then
            sudo systemctl reload apparmor
        fi
    fi

    # Start libvirt service
    echo "INFO: Starting libvirt service..."
    if ! systemctl is-enabled --quiet libvirtd; then
        sudo systemctl enable libvirtd
    fi
    sudo systemctl start libvirtd
}

main
