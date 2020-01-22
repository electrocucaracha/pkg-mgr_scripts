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
    local min_python_version="3.5"
    local min_pip_version="20"

    if ! command -v python  || _vercmp "$(python -V 2>&1 | awk '{print $2}')" '<' "$min_python_version"; then
        # shellcheck disable=SC1091
        source /etc/os-release || source /usr/lib/os-release
        case ${ID,,} in
            *suse*)
                sudo -H -E zypper -q addrepo https://download.opensuse.org/repositories/openSUSE:Leap:15.1:Update/standard/openSUSE:Leap:15.1:Update.repo
                sudo zypper --gpg-auto-import-keys refresh
                sudo -H -E zypper -q install -y --no-recommends python3
            ;;
            ubuntu|debian)
                sudo -H -E apt-get -y -q=3 install software-properties-common
                sudo -H -E add-apt-repository -y ppa:deadsnakes/ppa
                sudo apt update
                sudo -H -E apt-get -y -q=3 install python3.7
            ;;
            rhel|centos|fedora)
                PKG_MANAGER=$(command -v dnf || command -v yum)
                sudo -H -E "${PKG_MANAGER}" -q -y install python36 yum-utils
                for file in yum yum-config-manager; do
                    sudo sed -i "s|#\!/usr/bin/python|#!$(command -v python2)|g" "/usr/bin/$file"
                done
                sudo sed -i "s|#\! /usr/bin/python|#!$(command -v python2)|g" /usr/libexec/urlgrabber-ext-down
            ;;
        esac
        sudo rm -f /usr/bin/python
        sudo ln -s /usr/bin/python3 /usr/bin/python
    fi
    if ! command -v pip || _vercmp "$(pip -V | awk '{print $2}')" '<' "$min_pip_version"; then
        curl -sL https://bootstrap.pypa.io/get-pip.py | sudo python
    fi
}

main
