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
    # shellcheck disable=SC1091
    source /etc/os-release || source /usr/lib/os-release
    case ${ID,,} in
        *suse*|ubuntu|debian)
            PKG="nfs-kernel-server"
        ;;
        rhel|centos|fedora)
            PKG="nfs-utils"
            if _vercmp "${VERSION_ID}" '<=' "7"; then
                PKG+=" nfs-utils-lib"
            fi
        ;;
        clear-linux-os)
            PKG="nfs-utils"
        ;;
    esac
    export PKG
    echo "INFO: Installing NFS packages ($PKG)..."
    curl -fsSL http://bit.ly/install_pkg | PKG_UPDATE=true bash

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
