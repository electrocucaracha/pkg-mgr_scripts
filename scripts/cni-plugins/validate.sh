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

function info {
    _print_msg "INFO" "$1"
}

function error {
    _print_msg "ERROR" "$1"
    exit 1
}

function _print_msg {
    echo "$1: $2"
}

function _get_version {
    local version=${PKG_CNI_PLUGINS_VERSION-}
    attempt_counter=0
    max_attempts=5

    until [ "$version" ]; do
        url_effective=$(curl -sL -o /dev/null -w '%{url_effective}' "https://github.com/containernetworking/plugins/releases/latest")
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
    echo "v${version#*v}"
}

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

info "Validating CNI plugin folder creation..."
if [ ! -d "${PKG_CNI_PLUGINS_FOLDER:-/opt/containernetworking/plugins}" ]; then
    error "CNI plugins folder wasn't created"
fi

info "Validating CNI plugin binaries installation..."
cni_version="$(_get_version)"
for plugin in bandwidth bridge dhcp firewall flannel host-device host-local ipvlan loopback macvlan portmap ptp sbr static tuning vlan; do
    if [ ! -f "${PKG_CNI_PLUGINS_FOLDER:-/opt/containernetworking/plugins}/$plugin" ]; then
        error "$plugin CNI binary doesn't exist"
    fi
    cni_versions_supported="$(CNI_COMMAND=VERSION "${PKG_CNI_PLUGINS_FOLDER:-/opt/containernetworking/plugins}/$plugin")"
    if [ -z "$cni_versions_supported" ]; then
        error "$plugin CNI binary doesn't support CNI version command"
    fi
    info "$plugin plugin supports $(echo "$cni_versions_supported" | awk -F ":" '{ gsub(/["\[\]}]/,""); gsub(/,/,", "); print $3}') CNI versions"
    if [ "$plugin" != "flannel" ] || _vercmp "$cni_version" '<' "0.9.1" && [[ "$("${PKG_CNI_PLUGINS_FOLDER:-/opt/containernetworking/plugins}/$plugin" --help 2>&1)" != *$cni_version* ]]; then
        error "$plugin CNI binary version is different than expected"
    fi
done
