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

function main {
    local version=${PKG_QEMU_VERSION:-5.0.0}
    local qemu_tarball="qemu-${version}.tar.xz"
    local pmdk_version=${PKG_PMDK_VERSION:-1.4}
    local pmdk_url="https://github.com/pmem/pmdk/releases/download/$pmdk_version/pmdk-${pmdk_version}-"

    if command -v qemu-img; then
        return
    fi

    cpu_arch="amd64"
    if command -v dpkg; then
        cpu_arch=$(dpkg --print-architecture)
    fi
    if [ -n "${PKG_CPU_ARCH:-}" ]; then
        cpu_arch="$PKG_CPU_ARCH"
    fi

    configure_flags="--target-list="$(lscpu | grep "Architecture:" | awk '{print $2}')-softmmu" --enable-libpmem --enable-kvm"
    pkgs="pip gcc make"
    # shellcheck disable=SC1091
    source /etc/os-release || source /usr/lib/os-release
    case ${ID,,} in
        opensuse*)
            pkgs+=" bzip2 glib2-devel libpixman-1-0-devel diffutils"
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
                    sudo rpm -i "x86_64/${pkg}-${pmdk_version}-1.fc25.x86_64.rpm"
                done
                popd
            fi
        ;;
        clearlinux)
            curl -fsSL http://bit.ly/install_pkg | PKG="kvm-host" bash
            return
        ;;
        ubuntu|debian)
            configure_flags+=" --enable-numa"
            pkgs+=" libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev libpmem-dev libnuma-dev"
            if [ "$VERSION_CODENAME" == "xenial" ]; then
                pushd "$(mktemp -d)" > /dev/null
                if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
                    curl -L -o pmdk-dpkgs.tar.gz "${pmdk_url}dpkgs.tar.gz"
                    tar xvf pmdk-dpkgs.tar.gz
                else
                    curl -L -o pmdk-dpkgs.tar.gz "${pmdk_url}dpkgs.tar.gz" 2> /dev/null
                    tar xf pmdk-dpkgs.tar.gz
                fi
                for pkg in libpmem libpmem-dev; do
                    sudo dpkg -i "${pkg}_${pmdk_version}-1_${cpu_arch}.deb"
                done
                popd
            fi
        ;;
        rhel|centos|fedora)
            configure_flags+=" --enable-numa"
            pkgs+=" glib2-devel pixman-devel zlib-devel libpmem-devel numactl-devel bzip2"
        ;;
    esac
    curl -fsSL http://bit.ly/install_pkg | PKG="$pkgs" bash

    pushd "$(mktemp -d)" > /dev/null
    if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
        curl -o qemu.tar.tz "https://download.qemu.org/$qemu_tarball"
    else
        curl -o qemu.tar.tz "https://download.qemu.org/$qemu_tarball" 2> /dev/null
    fi
    tar xf qemu.tar.tz
    pushd "qemu-${version}" > /dev/null
    eval "./configure $configure_flags"
    make > /dev/null
    sudo make install
    popd > /dev/null
    popd > /dev/null
}

main
