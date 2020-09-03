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
    local major_python_version=${PKG_PYTHON_MAJOR_VERSION:-3}
    local min_pip_version="20"

    if ! command -v python  || _vercmp "$(python -V 2>&1 | awk '{print $2}')" '<' "$major_python_version"; then
        # shellcheck disable=SC1091
        source /etc/os-release || source /usr/lib/os-release
        case ${ID,,} in
            *suse*)
                INSTALLER_CMD="sudo -H -E zypper "
                if [[ "${PKG_DEBUG:-false}" == "false" ]]; then
                    INSTALLER_CMD+="-q "
                fi
                if ! $INSTALLER_CMD repos | grep "openSUSE_Leap_15.1_Update"; then
                    $INSTALLER_CMD addrepo https://download.opensuse.org/repositories/openSUSE:Leap:15.1:Update/standard/openSUSE:Leap:15.1:Update.repo
                fi
                $INSTALLER_CMD --gpg-auto-import-keys refresh
                $INSTALLER_CMD install -y --no-recommends python38
            ;;
            ubuntu|debian)
                INSTALLER_CMD="apt-get -y "
                if [[ "${PKG_DEBUG:-false}" == "false" ]]; then
                    INSTALLER_CMD+="-q=3 "
                fi
                INSTALLER_CMD+=" --no-install-recommends install"
                # shellcheck disable=SC2086
                sudo -H -E $INSTALLER_CMD software-properties-common
                sudo -H -E add-apt-repository -y ppa:deadsnakes/ppa
                sudo apt-get update
                pkgs="python3.7 python3-setuptools python-setuptools"
                if _vercmp "${VERSION_ID}" '<=' "18.04"; then
                    pkgs+=" python-minimal"
                fi
                # shellcheck disable=SC2086
                sudo -H -E $INSTALLER_CMD $pkgs
            ;;
            rhel|centos|fedora)
                PKG_MANAGER=$(command -v dnf || command -v yum)
                INSTALLER_CMD="sudo -H -E ${PKG_MANAGER} -y"
                if [[ "${PKG_DEBUG:-false}" == "false" ]]; then
                    INSTALLER_CMD+=" --quiet --errorlevel=0"
                fi
                INSTALLER_CMD+=" install"
                $INSTALLER_CMD python36 yum-utils python2
                for file in yum yum-config-manager; do
                    if [ -f "/usr/bin/$file" ]; then
                        sudo sed -i "s|#\!/usr/bin/python|#!$(command -v python2)|g" "/usr/bin/$file"
                    fi
                done
                if [ -f /usr/libexec/urlgrabber-ext-down ]; then
                    sudo sed -i "s|#\! /usr/bin/python|#!$(command -v python2)|g" /usr/libexec/urlgrabber-ext-down
                fi
            ;;
        esac
    fi
    sudo rm -f /usr/bin/python
    sudo ln -s "/usr/bin/python${major_python_version}" /usr/bin/python
    if ! command -v pip || _vercmp "$(pip -V | awk '{print $2}')" '<' "$min_pip_version"; then
        curl -sL https://bootstrap.pypa.io/get-pip.py | sudo python
    fi
}

main
