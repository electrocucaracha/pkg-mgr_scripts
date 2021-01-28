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
    local version=${PKG_QAT_DRIVER_VERSION:-"1.7.l.4.11.0-00001"} # Sep 17, 2020 https://01.org/intel-quick-assist-technology/downloads
    local qat_driver_tarball="qat${version}.tar.gz"

    if systemctl is-active --quiet qat_service; then
        return
    fi

    pkgs=""
    # shellcheck disable=SC1091
    source /etc/os-release || source /usr/lib/os-release
    case ${ID,,} in
        opensuse*)
            INSTALLER_CMD="zypper"
            if [[ "${PKG_DEBUG:-false}" == "false" ]]; then
                INSTALLER_CMD+=" -q"
            fi
            INSTALLER_CMD+=" install -y"
            sudo -H -E "$INSTALLER_CMD" -t pattern devel_C_C++
            INSTALLER_CMD+=" --no-recommends"
            pkgs="pciutils libudev-devel openssl-devel gcc-c++ kernel-source kernel-syms"
            echo "WARN: QAT driver is not supported in openSUSE $VERSION_ID"
            return
        ;;
        ubuntu|debian)
            if _vercmp "${VERSION_ID}" '>=' "20.04"; then
                echo "WARN: QAT driver is not supported in Ubuntu $VERSION_ID"
                return
            fi
            INSTALLER_CMD="apt-get -y --no-install-recommends"
            if [[ "${PKG_DEBUG:-false}" == "false" ]]; then
                INSTALLER_CMD+=" -q=3"
            fi
            INSTALLER_CMD+=" install"
            pkgs="linux-headers-$(uname -r) pciutils libudev-dev pkg-config build-essential"
            echo '* libraries/restart-without-asking boolean true' | sudo debconf-set-selections
            sudo apt-get update
        ;;
        rhel|centos|fedora)
            PKG_MANAGER=$(command -v dnf || command -v yum)
            sudo "${PKG_MANAGER}" groups mark install -y "Development Tools"
            sudo "${PKG_MANAGER}" groups install -y "Development Tools"
            INSTALLER_CMD="${PKG_MANAGER} -y"
            if [[ "${PKG_DEBUG:-false}" == "false" ]]; then
                INSTALLER_CMD+=" --quiet --errorlevel=0"
            fi
            INSTALLER_CMD+=" install"
            pkgs="kernel-devel-$(uname -r) pciutils libudev-devel gcc openssl-devel"
            if [[ "${VERSION_ID}" == *7* ]]; then
                pkgs+=" yum-plugin-fastestmirror"
            fi
        ;;
        clear-linux-os)
            INSTALLER_CMD="swupd bundle-add"
            if [[ "${PKG_DEBUG:-false}" == "false" ]]; then
                INSTALLER_CMD+=" --quiet"
            fi
            pkgs="linux-firmware-qat"
            sudo swupd update --download
            sudo tee /etc/systemd/system/qat_service.service << EOF
[Unit]
Description=Intel QuickAssist Technology service

[Service]
Type=forking
Restart=no
TimeoutSec=5min
IgnoreSIGPIPE=no
KillMode=process
GuessMainPID=no
RemainAfterExit=yes
ExecStart=/etc/init.d/qat_service start
ExecStop=/etc/init.d/qat_service stop

[Install]
WantedBy=multi-user.target
EOF
            return
        ;;
    esac
    echo "INFO: Installing building packages ($pkgs)"
    # shellcheck disable=SC2086
    sudo -H -E $INSTALLER_CMD $pkgs

    echo "INFO: Removing old QAT Kernel modules"
    for mod in $(lsmod | grep "^intel_qat" | awk '{print $4}'); do
        sudo rmmod "$mod"
    done
    if lsmod | grep "^intel_qat"; then
        sudo rmmod intel_qat
    fi

    sudo mkdir -p /lib/modprobe.d/
    sudo tee /lib/modprobe.d/quickassist-blacklist.conf  << EOF
### Blacklist in-kernel QAT drivers to avoid kernel boot problems.
# Lewisburg QAT PF
blacklist qat_c62x
# Common QAT driver
blacklist intel_qat
EOF

    if [ ! -d /tmp/qat ]; then
        echo "INFO: Getting QAT driver's Tarball"
        curl -o "$qat_driver_tarball" "https://01.org/sites/default/files/downloads/${qat_driver_tarball}"
        sudo mkdir -p /tmp/qat
        sudo tar -C /tmp/qat -xzf "$qat_driver_tarball"
        rm "$qat_driver_tarball"
    fi
    pushd /tmp/qat
    sudo ./configure
    for action in clean uninstall install; do
        echo "INFO: Performing $action make action"
        sudo make $action
    done
    popd

    echo "INFO: Starting QAT service"
    sudo systemctl --now enable qat_service
    sudo systemctl start qat_service
}

main
