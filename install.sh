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

function _check_requirements {
    if ! sudo -n "true"; then
        echo ""
        echo "passwordless sudo is needed for '$(id -nu)' user."
        echo "Please fix your /etc/sudoers file. You likely want an"
        echo "entry like the following one..."
        echo ""
        echo "$(id -nu) ALL=(ALL) NOPASSWD: ALL"
        exit 1
    fi
}

function update_repos {
    _check_requirements

    # shellcheck disable=SC1091
    source /etc/os-release || source /usr/lib/os-release
    case ${ID,,} in
        *suse*)
            sudo zypper -n ref
        ;;
        ubuntu|debian)
            echo '* libraries/restart-without-asking boolean true' | sudo debconf-set-selections
            sudo apt-get update
        ;;
        rhel|centos|fedora)
            PKG_MANAGER=$(command -v dnf || command -v yum)
            if ! sudo "$PKG_MANAGER" repolist | grep "epel/"; then
                sudo -H -E "$PKG_MANAGER" -q -y install epel-release
            fi
            sudo "$PKG_MANAGER" updateinfo --assumeyes
        ;;
    esac
}

function main {
    PKG_MGR_UNSUPPORTED="unsupported"
    PKG_MGR_SUPPORTED="supported"
    PKG_MGR_PIP_REQUIRED="pip_required"

    declare -A pkg_mgr_supported

    pkg_mgr_supported[bind-utils]="{\"Suse\": \"$PKG_MGR_UNSUPPORTED\",\"Debian\": \"$PKG_MGR_UNSUPPORTED\",\"RedHat\": \"bind-utils\"}"
    pkg_mgr_supported[bridge-utils]="{\"Suse\": \"bridge-utils\",\"Debian\": \"bridge-utils\",\"RedHat\": \"bridge-utils\"}"
    pkg_mgr_supported[dnsmasq]="{\"Suse\": \"dnsmasq\",\"Debian\": \"dnsmasq-base\",\"RedHat\": \"dnsmasq\"}"
    pkg_mgr_supported[ebtables]="{\"Suse\": \"ebtables\",\"Debian\": \"ebtables\",\"RedHat\": \"ebtables\"}"
    pkg_mgr_supported[gpgme]="{\"Suse\": \"$PKG_MGR_UNSUPPORTED\",\"Debian\": \"$PKG_MGR_UNSUPPORTED\",\"RedHat\": \"gpgme\"}"
    pkg_mgr_supported[gpgme-devel]="{\"Suse\": \"$PKG_MGR_UNSUPPORTED\",\"Debian\": \"$PKG_MGR_UNSUPPORTED\",\"RedHat\": \"gpgme-devel\"}"
    pkg_mgr_supported[krb5-devel]="{\"Suse\": \"$PKG_MGR_UNSUPPORTED\",\"Debian\": \"libkrb5-dev\",\"RedHat\": \"krb5-devel\"}"
    pkg_mgr_supported[libassuan]="{\"Suse\": \"$PKG_MGR_UNSUPPORTED\",\"Debian\": \"$PKG_MGR_UNSUPPORTED\",\"RedHat\": \"libassuan\"}"
    pkg_mgr_supported[libassuan-devel]="{\"Suse\": \"$PKG_MGR_UNSUPPORTED\",\"Debian\": \"$PKG_MGR_UNSUPPORTED\",\"RedHat\": \"libassuan-devel\"}"
    pkg_mgr_supported[libguestfs]="{\"Suse\": \"guestfs-tools\",\"Debian\": \"libguestfs-tools\",\"RedHat\": \"libguestfs-tools\"}"
    pkg_mgr_supported[mkpasswd]="{\"Suse\": \"$PKG_MGR_UNSUPPORTED\",\"Debian\": \"mkpasswd\",\"RedHat\": \"expect\"}"
    pkg_mgr_supported[python-devel]="{\"Suse\": \"python-devel\",\"Debian\": \"python-dev\",\"RedHat\": \"python3-devel python2-devel\"}"
    pkg_mgr_supported[qemu-utils]="{\"Suse\": \"qemu-tools\",\"Debian\": \"qemu-utils\",\"RedHat\": \"qemu-utils\"}"
    pkg_mgr_supported[ruby-devel]="{\"Suse\": \"ruby-devel\",\"Debian\": \"ruby-dev\",\"RedHat\": \"ruby-devel\"}"
    pkg_mgr_supported[sysfsutils]="{\"Suse\": \"sysfsutils\",\"Debian\": \"sysfsutils\",\"RedHat\": \"sysfsutils\"}"
    pkg_mgr_supported[tito]="{\"Suse\": \"$PKG_MGR_UNSUPPORTED\",\"Debian\": \"$PKG_MGR_UNSUPPORTED\",\"RedHat\": \"tito\"}"

    # cURL Package Manager Supported
    pkg_mgr_supported[cni-plugins]="{\"Suse\": \"$PKG_MGR_SUPPORTED\",\"Debian\": \"$PKG_MGR_SUPPORTED\",\"RedHat\": \"$PKG_MGR_SUPPORTED\"}"
    pkg_mgr_supported[crystal-lang]="{\"Suse\": \"$PKG_MGR_SUPPORTED\",\"Debian\": \"$PKG_MGR_SUPPORTED\",\"RedHat\": \"$PKG_MGR_SUPPORTED\"}"
    pkg_mgr_supported[docker]="{\"Suse\": \"$PKG_MGR_SUPPORTED\",\"Debian\": \"$PKG_MGR_SUPPORTED\",\"RedHat\": \"$PKG_MGR_SUPPORTED\"}"
    pkg_mgr_supported[fly]="{\"Suse\": \"$PKG_MGR_SUPPORTED\",\"Debian\": \"$PKG_MGR_SUPPORTED\",\"RedHat\": \"$PKG_MGR_SUPPORTED\"}"
    pkg_mgr_supported[go-lang]="{\"Suse\": \"$PKG_MGR_SUPPORTED\",\"Debian\": \"$PKG_MGR_SUPPORTED\",\"RedHat\": \"$PKG_MGR_SUPPORTED\"}"
    pkg_mgr_supported[gomplate]="{\"Suse\": \"$PKG_MGR_SUPPORTED\",\"Debian\": \"$PKG_MGR_SUPPORTED\",\"RedHat\": \"$PKG_MGR_SUPPORTED\"}"
    pkg_mgr_supported[hadolint]="{\"Suse\": \"$PKG_MGR_SUPPORTED\",\"Debian\": \"$PKG_MGR_SUPPORTED\",\"RedHat\": \"$PKG_MGR_SUPPORTED\"}"
    pkg_mgr_supported[helm]="{\"Suse\": \"$PKG_MGR_SUPPORTED\",\"Debian\": \"$PKG_MGR_SUPPORTED\",\"RedHat\": \"$PKG_MGR_SUPPORTED\"}"
    pkg_mgr_supported[kind]="{\"Suse\": \"$PKG_MGR_SUPPORTED\",\"Debian\": \"$PKG_MGR_SUPPORTED\",\"RedHat\": \"$PKG_MGR_SUPPORTED\"}"
    pkg_mgr_supported[kn]="{\"Suse\": \"$PKG_MGR_SUPPORTED\",\"Debian\": \"$PKG_MGR_SUPPORTED\",\"RedHat\": \"$PKG_MGR_SUPPORTED\"}"
    pkg_mgr_supported[kubectl]="{\"Suse\": \"$PKG_MGR_SUPPORTED\",\"Debian\": \"$PKG_MGR_SUPPORTED\",\"RedHat\": \"$PKG_MGR_SUPPORTED\"}"
    pkg_mgr_supported[kustomize]="{\"Suse\": \"$PKG_MGR_SUPPORTED\",\"Debian\": \"$PKG_MGR_SUPPORTED\",\"RedHat\": \"$PKG_MGR_SUPPORTED\"}"
    pkg_mgr_supported[libvirt]="{\"Suse\": \"$PKG_MGR_SUPPORTED\",\"Debian\": \"$PKG_MGR_SUPPORTED\",\"RedHat\": \"$PKG_MGR_SUPPORTED\"}"
    pkg_mgr_supported[nfs]="{\"Suse\": \"$PKG_MGR_SUPPORTED\",\"Debian\": \"$PKG_MGR_SUPPORTED\",\"RedHat\": \"$PKG_MGR_SUPPORTED\"}"
    pkg_mgr_supported[nodejs]="{\"Suse\": \"$PKG_MGR_UNSUPPORTED\",\"Debian\": \"$PKG_MGR_SUPPORTED\",\"RedHat\": \"$PKG_MGR_SUPPORTED\"}"
    pkg_mgr_supported[pip]="{\"Suse\": \"$PKG_MGR_SUPPORTED\",\"Debian\": \"$PKG_MGR_SUPPORTED\",\"RedHat\": \"$PKG_MGR_SUPPORTED\"}"
    pkg_mgr_supported[podman]="{\"Suse\": \"$PKG_MGR_SUPPORTED\",\"Debian\": \"$PKG_MGR_SUPPORTED\",\"RedHat\": \"$PKG_MGR_SUPPORTED\"}"
    pkg_mgr_supported[qat-driver]="{\"Suse\": \"$PKG_MGR_UNSUPPORTED\",\"Debian\": \"$PKG_MGR_SUPPORTED\",\"RedHat\": \"$PKG_MGR_SUPPORTED\"}"
    pkg_mgr_supported[qemu]="{\"Suse\": \"$PKG_MGR_SUPPORTED\",\"Debian\": \"$PKG_MGR_SUPPORTED\",\"RedHat\": \"$PKG_MGR_SUPPORTED\"}"
    pkg_mgr_supported[rust-lang]="{\"Suse\": \"$PKG_MGR_SUPPORTED\",\"Debian\": \"$PKG_MGR_SUPPORTED\",\"RedHat\": \"$PKG_MGR_SUPPORTED\"}"
    pkg_mgr_supported[skopeo]="{\"Suse\": \"$PKG_MGR_SUPPORTED\",\"Debian\": \"$PKG_MGR_SUPPORTED\",\"RedHat\": \"$PKG_MGR_SUPPORTED\"}"
    pkg_mgr_supported[terraform]="{\"Suse\": \"$PKG_MGR_SUPPORTED\",\"Debian\": \"$PKG_MGR_SUPPORTED\",\"RedHat\": \"$PKG_MGR_SUPPORTED\"}"
    pkg_mgr_supported[tkn]="{\"Suse\": \"$PKG_MGR_SUPPORTED\",\"Debian\": \"$PKG_MGR_SUPPORTED\",\"RedHat\": \"$PKG_MGR_SUPPORTED\"}"
    pkg_mgr_supported[vagrant]="{\"Suse\": \"$PKG_MGR_SUPPORTED\",\"Debian\": \"$PKG_MGR_SUPPORTED\",\"RedHat\": \"$PKG_MGR_SUPPORTED\"}"
    pkg_mgr_supported[virtualbox]="{\"Suse\": \"$PKG_MGR_SUPPORTED\",\"Debian\": \"$PKG_MGR_SUPPORTED\",\"RedHat\": \"$PKG_MGR_SUPPORTED\"}"

    # PIP required
    pkg_mgr_supported[ansible]="{\"Suse\": \"$PKG_MGR_PIP_REQUIRED\",\"Debian\": \"$PKG_MGR_PIP_REQUIRED\",\"RedHat\": \"$PKG_MGR_PIP_REQUIRED\"}"
    pkg_mgr_supported[bindep]="{\"Suse\": \"$PKG_MGR_PIP_REQUIRED\",\"Debian\": \"$PKG_MGR_PIP_REQUIRED\",\"RedHat\": \"$PKG_MGR_PIP_REQUIRED\"}"
    pkg_mgr_supported[docker-compose]="{\"Suse\": \"$PKG_MGR_PIP_REQUIRED\",\"Debian\": \"$PKG_MGR_PIP_REQUIRED\",\"RedHat\": \"$PKG_MGR_PIP_REQUIRED\"}"
    pkg_mgr_supported[pipx]="{\"Suse\": \"$PKG_MGR_PIP_REQUIRED\",\"Debian\": \"$PKG_MGR_PIP_REQUIRED\",\"RedHat\": \"$PKG_MGR_PIP_REQUIRED\"}"
    pkg_mgr_supported[tox]="{\"Suse\": \"$PKG_MGR_PIP_REQUIRED\",\"Debian\": \"$PKG_MGR_PIP_REQUIRED\",\"RedHat\": \"$PKG_MGR_PIP_REQUIRED\"}"

    _check_requirements

    # shellcheck disable=SC1091
    source /etc/os-release || source /usr/lib/os-release
    case ${ID,,} in
        *suse*)
            INSTALLER_CMD="zypper"
            if [[ "${PKG_DEBUG:-false}" == "false" ]]; then
                INSTALLER_CMD+=" -q"
            fi
            INSTALLER_CMD+=" install -y --no-recommends"
            PKG_OS_FAMILY="Suse"
        ;;
        ubuntu|debian)
            INSTALLER_CMD="apt-get -y --no-install-recommends"
            if [[ "${PKG_DEBUG:-false}" == "false" ]]; then
                INSTALLER_CMD+=" -q=3"
            fi
            INSTALLER_CMD+=" install"
            PKG_OS_FAMILY="Debian"
        ;;
        rhel|centos|fedora)
            INSTALLER_CMD="$(command -v dnf || command -v yum) -y"
            if [[ "${PKG_DEBUG:-false}" == "false" ]]; then
                INSTALLER_CMD+=" --quiet --errorlevel=0"
            fi
            INSTALLER_CMD+=" install"
            PKG_OS_FAMILY="RedHat"
        ;;
    esac

    if [[ -n ${PKG+x} ]]; then
        sanity_pkgs=""
        for pkg in $PKG; do
            json_pkg="${pkg_mgr_supported[$pkg]}"
            if [[ -n "${json_pkg}" ]]; then
                distro_pkg=$(echo "$json_pkg" | grep -oP "(?<=\"$PKG_OS_FAMILY\": \")[^\"]*")
                case $distro_pkg in
                    "$PKG_MGR_UNSUPPORTED")
                        echo "$pkg is not supported by $PKG_OS_FAMILY"
                    ;;
                    "$PKG_MGR_SUPPORTED")
                        curl -fsSL "https://raw.githubusercontent.com/electrocucaracha/pkg-mgr_scripts/master/scripts/${pkg}/main.sh" | bash
                    ;;
                    "$PKG_MGR_PIP_REQUIRED")
                        if ! command -v pip; then
                            curl -fsSL "https://raw.githubusercontent.com/electrocucaracha/pkg-mgr_scripts/master/scripts/pip/main.sh" | bash
                        fi
                        PATH="$PATH:/usr/local/bin/"
                        export PATH
                        PIP_CMD="sudo -E $(command -v pip) install"
                        if _vercmp "$(pip -V | awk '{print $2}')" '>' "7"; then
                            PIP_CMD+=" --no-cache-dir"
                        fi
                        if _vercmp "$(pip -V | awk '{print $2}')" '>' "10"; then
                            PIP_CMD+=" --no-warn-script-location"
                        fi
                        if [[ "${PKG_DEBUG:-false}" == "false" ]]; then
                            PIP_CMD+=" --quiet"
                        fi
                        $PIP_CMD "$pkg"
                    ;;
                    *)
                        sanity_pkgs+=" $distro_pkg"
                    ;;
                esac
            else
                sanity_pkgs+=" $pkg"
            fi
        done
        if [[ -n "${sanity_pkgs}" ]]; then
            # shellcheck disable=SC2086
            sudo -H -E $INSTALLER_CMD $sanity_pkgs
        fi
    fi
}

exit_trap() {
    printf "CPU usage: "
    grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage " %"}'
    printf "Memory free(Kb):"
    awk -v low="$(grep low /proc/zoneinfo | awk '{k+=$2}END{print k}')" '{a[$1]=$2}  END{ print a["MemFree:"]+a["Active(file):"]+a["Inactive(file):"]+a["SReclaimable:"]-(12*low);}' /proc/meminfo
    echo "Environment variables:"
    env | grep "PKG"
}

trap exit_trap ERR
if [[ "${PKG_UPDATE:-false}" == "true" ]]; then
    update_repos
fi
if [[ -n ${PKG_COMMANDS_LIST:-} ]]; then
    [[ -n ${PKG:-} ]] || PKG=""
    for cmd in ${PKG_COMMANDS_LIST//,/ }; do
        if ! command -v "$cmd" > /dev/null; then
            PKG+=" $cmd"
        fi
    done
fi
main
trap ERR
