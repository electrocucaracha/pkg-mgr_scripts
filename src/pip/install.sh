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

# Some devcontainer test images execute feature installers as root without sudo.
# Provide a local fallback so the same script works in both contexts.
if ! command -v sudo >/dev/null && [ "$(id -u)" -eq 0 ]; then
    sudo() {
        while [[ "$1" == -* ]]; do
            shift
        done
        "$@"
    }
fi
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
    local major_python_version=${PKG_PYTHON_MAJOR_VERSION:-3}
    local min_pip_version="20"

    # shellcheck disable=SC1091
    source /etc/os-release || source /usr/lib/os-release
    case ${ID,,} in
    ubuntu | debian)
        INSTALLER_CMD="sudo -H -E apt-get -y "
        if [[ ${PKG_DEBUG:-false} == "false" ]]; then
            INSTALLER_CMD+="-q=3 "
        fi
        INSTALLER_CMD+=" --no-install-recommends install"
        ;;
    rhel | centos | fedora | rocky)
        PKG_MANAGER=$(command -v dnf || command -v yum)
        INSTALLER_CMD="sudo -H -E ${PKG_MANAGER} -y"
        if [[ ${PKG_DEBUG:-false} == "false" ]]; then
            INSTALLER_CMD+=" --quiet --errorlevel=0"
        fi
        INSTALLER_CMD+=" install"
        ;;
    esac

    case $major_python_version in
    2)
        if ! command -v python || _vercmp "$(python -V 2>&1 | awk '{print $2}')" '>' "3"; then
            echo "INFO: Installing python $major_python_version version..."
            case ${ID,,} in
            ubuntu | debian)
                pkgs="python-setuptools"
                if [ "${ID,,}" == "ubuntu" ]; then
                    # shellcheck disable=SC2086
                    $INSTALLER_CMD software-properties-common
                    sudo -H -E add-apt-repository -y ppa:deadsnakes/ppa
                    sudo apt-get update
                    if _vercmp "${VERSION_ID}" '<=' "18.04"; then
                        pkgs+=" python-minimal"
                    fi
                fi
                # shellcheck disable=SC2086
                $INSTALLER_CMD $pkgs || :
                ;;
            rhel | centos | fedora | rocky)
                $INSTALLER_CMD yum-utils python2
                for file in yum yum-config-manager; do
                    echo "INFO: Setting $file to use python 2"
                    if [ -f "/usr/bin/$file" ]; then
                        sudo sed -i "s|#\!/usr/bin/python|#!$(command -v python2)|g" "/usr/bin/$file"
                    fi
                done
                if [ -f /usr/libexec/urlgrabber-ext-down ]; then
                    echo "INFO: Setting urlgrabber-ext-down script to use python 2"
                    sudo sed -i "s|#\! /usr/bin/python|#!$(command -v python2)|g" /usr/libexec/urlgrabber-ext-down
                fi
                ;;
            esac
        fi
        ;;
    3)
        PYTHON_CMD=$(command -v python3 || command -v python || :)
        if [ -z "$PYTHON_CMD" ] || _vercmp "$($PYTHON_CMD -V 2>&1 | awk '{print $2}')" '<' "3"; then
            echo "INFO: Installing python $major_python_version version..."
            case ${ID,,} in
            debian)
                pkgs="python3-setuptools python3.4"
                sudo sed -i "s|#! /usr/bin/python|#! $(command -v python2)|g" "$(command -v lsb_release)"
                ;;
            rhel | centos | fedora | rocky)
                pkgs="python3"
                ;;
            esac
            # shellcheck disable=SC2086
            $INSTALLER_CMD $pkgs
        fi
        ;;
    *)
        echo "ERROR: Unsupported Python $major_python_version version"
        exit 1
        ;;
    esac

    echo "INFO: Setting python $major_python_version as default option"

    # Preserve backwards compatibility for tools expecting /usr/bin/python.
    if [ -x "/usr/bin/python${major_python_version}" ]; then
        sudo rm -f /usr/bin/python
        sudo ln -sf "/usr/bin/python${major_python_version}" /usr/bin/python
    fi

    # Preserve backwards compatibility for tools expecting a plain pip command.
    if ! command -v pip >/dev/null 2>&1; then
        PIP_CMD=$(command -v pip3 || :)
        if [ -n "$PIP_CMD" ]; then
            sudo ln -sf "$PIP_CMD" /usr/bin/pip
        fi
    fi

    # Determine which interpreter to use.
    PYTHON_CMD=$(command -v python"${major_python_version}" || command -v python3 || command -v python)

    echo "INFO: Using Python interpreter: $PYTHON_CMD"

    if ! command -v pip >/dev/null 2>&1 ||
        _vercmp "$(pip -V 2>/dev/null | awk '{print $2}')" '<' "$min_pip_version"; then
        if _vercmp "$($PYTHON_CMD -V 2>&1 | awk '{print $2}')" '>=' "3"; then
            case ${ID,,} in
            ubuntu | debian)
                if $INSTALLER_CMD python3-pip python3-venv; then
                    echo "INFO: Installed pip from distribution packages."
                    python3 -m pip config set global.break-system-packages true || :
                else
                    echo "INFO: Falling back to get-pip.py"

                    current_version="$($PYTHON_CMD -V | awk '{print $2}')"
                    url="https://bootstrap.pypa.io/get-pip.py"

                    if _vercmp "$current_version" '<' "3.9"; then
                        url="https://bootstrap.pypa.io/pip/$(echo "$current_version" | cut -d'.' -f1,2)/get-pip.py"
                    fi

                    curl -sL "$url" | sudo -H "$PYTHON_CMD"
                fi
                ;;
            rhel | centos | fedora | rocky)
                current_version="$($PYTHON_CMD -V | awk '{print $2}')"
                url="https://bootstrap.pypa.io/get-pip.py"

                if _vercmp "$current_version" '<' "3.9"; then
                    url="https://bootstrap.pypa.io/pip/$(echo "$current_version" | cut -d'.' -f1,2)/get-pip.py"
                fi

                curl -sL "$url" | sudo -H "$PYTHON_CMD"
                ;;
            esac
        else
            curl -sL https://bootstrap.pypa.io/pip/2.7/get-pip.py |
                sudo -H "$PYTHON_CMD"

        fi
    fi
}

main
