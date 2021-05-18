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
    echo "INFO: Installing NFS packages..."
    # shellcheck disable=SC1091
    source /etc/os-release || source /usr/lib/os-release
    case ${ID,,} in
        *suse*)
            sudo -H -E zypper install -y --no-recommends nfs-kernel-server
        ;;
        ubuntu|debian)
            sudo -H -E apt-get -y install --no-install-recommends nfs-kernel-server
        ;;
        rhel|centos|fedora)
            INSTALLER_CMD="sudo -H -E $(command -v dnf || command -v yum) -y install nfs-utils"
            if _vercmp "${VERSION_ID}" '<=' "7"; then
                INSTALLER_CMD+=" nfs-utils-lib"
            fi
            $INSTALLER_CMD
        ;;
        clear-linux-os)
            sudo -H -E swupd bundle-add nfs-utils
        ;;
    esac

    for service in rpc-statd nfs-server; do
        echo "INFO: Starting $service service..."
        if ! systemctl is-enabled --quiet "$service"; then
            sudo systemctl enable "$service"
        fi
        sudo systemctl start "$service"
    done

    if command -v firewall-cmd && systemctl is-active --quiet firewalld; then
        for svc in nfs rpc-bind mountd; do
            echo "INFO: Enabiling $svc service in FirewallD service..."
            sudo firewall-cmd --permanent --add-service="${svc}" --zone=trusted
        done
        sudo firewall-cmd --set-default-zone=trusted
        sudo firewall-cmd --reload
    fi
}

main
