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

function get_cpu_arch {
    case "$(uname -m)" in
        x86_64)
            echo "amd64"
        ;;
        armv8*|aarch64*)
            echo "arm64"
        ;;
        armv*)
            echo "armv7"
        ;;
    esac
}

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
    local version=${PKG_QEMU_VERSION:-5.1.0}
    local qemu_tarball="qemu-${version}.tar.xz"
    local pmdk_version=${PKG_PMDK_VERSION:-1.4}
    local pmdk_url="https://github.com/pmem/pmdk/releases/download/$pmdk_version/pmdk-${pmdk_version}-"

    if command -v qemu-img; then
        return
    fi

    configure_flags="--target-list="$(uname -m)-softmmu" --enable-libpmem --enable-kvm"
    # shellcheck disable=SC1091
    source /etc/os-release || source /usr/lib/os-release
    case ${ID,,} in
        opensuse*)
            if ! sudo zypper search --match-exact --installed-only libpmem; then
                pushd "$(mktemp -d)" > /dev/null
                if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
                    curl -L -o pmdk-rpms.tar.gz "${pmdk_url}rpms.tar.gz"
                    tar xvf pmdk-rpms.tar.gz
                else
                    curl -L -o pmdk-rpms.tar.gz "${pmdk_url}rpms.tar.gz" 2> /dev/null
                    tar xf pmdk-rpms.tar.gz
                fi
                for pkg in libpmem libpmem-devel; do
                    sudo rpm -i "$(uname -m)/${pkg}-${pmdk_version}-1.fc25.$(uname -m).rpm"
                done
                popd > /dev/null
            fi
            sudo -H -E zypper install -y --no-recommends git gcc make bzip2 glib2-devel libpixman-1-0-devel diffutils zlib-devel libbz2-devel libopenssl-devel ncurses-devel readline-devel sqlite3 sqlite3-devel tack xz-devel
            curl https://pyenv.run | bash
            export PATH="$HOME/.pyenv/bin:$PATH"
            eval "$(pyenv init -)"
            # pyenv uses /tmp folder to download binaries and tarballs
            sudo rm -rf /tmp/*
            pyenv install 3.8.5
            pyenv global 3.8.5
        ;;
        clearlinux)
            sudo -H -E swupd bundle-add kvm-host
            return
        ;;
        ubuntu|debian)
            configure_flags+=" --enable-numa"
            if _vercmp "${VERSION_ID}" '<=' "16.04"; then
                pushd "$(mktemp -d)" > /dev/null
                if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
                    curl -L -o pmdk-dpkgs.tar.gz "${pmdk_url}dpkgs.tar.gz"
                    tar xvf pmdk-dpkgs.tar.gz
                else
                    curl -L -o pmdk-dpkgs.tar.gz "${pmdk_url}dpkgs.tar.gz" 2> /dev/null
                    tar xf pmdk-dpkgs.tar.gz
                fi
                for pkg in libpmem libpmem-dev; do
                    sudo dpkg -i "${pkg}_${pmdk_version}-1_$(get_cpu_arch).deb"
                done
                popd > /dev/null
            fi
            sudo -H -E apt-get -y install software-properties-common
            sudo -H -E add-apt-repository -y ppa:deadsnakes/ppa
            sudo apt-get update
            sudo -H -E apt-get -y install --no-install-recommends python3.7 gcc make libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev libpmem-dev libnuma-dev
        ;;
        rhel|centos|fedora)
            configure_flags+=" --enable-numa"
            PKG_MANAGER=$(command -v dnf || command -v yum)
            sudo -H -E "${PKG_MANAGER}" -y install python36 gcc make glib2-devel pixman-devel zlib-devel libpmem-devel numactl-devel bzip2
        ;;
    esac

    mkdir ~/tmp/
    pushd ~/tmp  > /dev/null
    if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
        curl -o qemu.tar.tz "https://download.qemu.org/$qemu_tarball"
    else
        curl -o qemu.tar.tz "https://download.qemu.org/$qemu_tarball" 2> /dev/null
    fi
    tar xf qemu.tar.tz
    pushd "qemu-${version}" > /dev/null
    # shellcheck disable=SC2086
    ./configure $configure_flags
    if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
        make
    else
        make > /dev/null
    fi
    sudo make install
    popd > /dev/null
    rm -rf qemu*
    popd > /dev/null
}

main
