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
if [[ ${PKG_DEBUG:-false} == "true" ]]; then
    set -o xtrace
fi

function get_github_latest_release {
    version=""
    attempt_counter=0
    max_attempts=5

    until [ "$version" ]; do
        url_effective=$(curl -sL -o /dev/null -w '%{url_effective}' "https://github.com/$1/releases/latest")
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
    echo "${version#v}"
}

function get_github_latest_tag {
    version=""
    attempt_counter=0
    max_attempts=5

    until [ "$version" ]; do
        tags="$(curl -s "https://api.github.com/repos/$1/tags")"
        if [ "$tags" ]; then
            version="$(echo "$tags" | grep -Po '"name":.*?[^\\]",' | awk -F '"' 'NR==1{print $4}')"
            break
        elif [ ${attempt_counter} -eq ${max_attempts} ]; then
            echo "Max attempts reached"
            exit 1
        fi
        attempt_counter=$((attempt_counter + 1))
        sleep $((attempt_counter * 2))
    done

    echo "${version#*v}"
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
        echo "unrecognised op: $op"
        exit 1
        ;;
    esac
}

# _install_pmdk() - Installs Persistent Memory Development Kit
function _install_pmdk {
    local pmdk_version=${PKG_PMDK_VERSION:-$(get_github_latest_release pmem/pmdk)}

    pmdk_url="https://github.com/pmem/pmdk/releases/download/$pmdk_version/pmdk-${pmdk_version}.tar.gz"
    pushd "$(mktemp -d)" >/dev/null
    if [[ ${PKG_DEBUG:-false} == "true" ]]; then
        curl -L -o pmdk-dpkgs.tar.gz "${pmdk_url}"
        tar xvf pmdk-dpkgs.tar.gz --strip-components=1
    else
        curl -L -o pmdk-dpkgs.tar.gz "${pmdk_url}" 2>/dev/null
        tar xf pmdk-dpkgs.tar.gz --strip-components=1
    fi
    make
    sudo make install
    popd >/dev/null
}

function main {
    local ninja_version=${PKG_NINJA_VERSION:-$(get_github_latest_release ninja-build/ninja)}
    local version=${PKG_QEMU_VERSION:-$(get_github_latest_tag qemu/qemu)}
    local qemu_tarball="qemu-${version}.tar.xz"

    if command -v qemu-img && [[ "$(qemu-img --version | awk 'NR==1{print $3}')" == "$version" ]]; then
        return
    fi

    echo "INFO: Installing building packages"
    configure_flags="--target-list="$(uname -m)-softmmu" --enable-libpmem --enable-kvm"
    # shellcheck disable=SC1091
    source /etc/os-release || source /usr/lib/os-release
    case ${ID,,} in
    opensuse*)
        sudo -H -E zypper install -y --no-recommends git gcc make bzip2 \
            glib2-devel libpixman-1-0-devel diffutils zlib-devel libbz2-devel \
            libopenssl-devel ncurses-devel readline-devel sqlite3 \
            sqlite3-devel tack xz-devel unzip libndctl-devel gcc-c++ patch cmake
        if _vercmp "$(python -V 2>&1 | awk '{print $2}')" '<' "3.7"; then
            curl https://pyenv.run | bash
            export PATH="$HOME/.pyenv/bin:$PATH"
            eval "$(pyenv init -)"
            # pyenv uses /tmp folder to download binaries and tarballs
            sudo rm -rf /tmp/*
            pyenv install 3.8.10
            pyenv global 3.8.10
        fi
        _install_pmdk
        grep -q LD_LIBRARY_PATH /etc/environment || echo "LD_LIBRARY_PATH=/usr/local/lib64/" | sudo tee --append /etc/environment
        ;;
    ubuntu | debian)
        configure_flags+=" --enable-numa"
        sudo -H -E apt-get -y install software-properties-common
        sudo -H -E add-apt-repository -y ppa:deadsnakes/ppa
        sudo apt-get update
        sudo -H -E apt-get -y install --no-install-recommends python3 \
            gcc make libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev \
            libpmem-dev libnuma-dev unzip libndctl-dev libdaxctl-dev g++ cmake

        if _vercmp "${VERSION_ID}" '>=' "20.04"; then
            _install_pmdk
        fi
        ;;
    rhel | centos | fedora | rocky)
        configure_flags+=" --enable-numa"
        PKG_MANAGER=$(command -v dnf || command -v yum)
        sudo -H -E "${PKG_MANAGER}" -y install python36 gcc make \
            glib2-devel pixman-devel zlib-devel libpmem-devel numactl-devel \
            bzip2 unzip perl ndctl-devel daxctl-devel gcc-c++ cmake
        if _vercmp "${VERSION_ID}" '>=' "8"; then
            _install_pmdk
        fi
        ;;
    esac
    if ! command -v ninja || _vercmp "$(ninja --version)" '<' "1.7"; then
        echo "INFO: Installing Ninja build $ninja_version version"
        url="https://github.com/ninja-build/ninja/releases/download/v${ninja_version#*v}/ninja-$(uname | tr '[:upper:]' '[:lower:]').zip"
        if [[ ${PKG_DEBUG:-false} == "true" ]]; then
            curl -o /tmp/ninja.zip -L "$url"
            unzip /tmp/ninja.zip
        else
            curl -o /tmp/ninja.zip -L "$url" 2>/dev/null
            unzip -qq /tmp/ninja.zip
        fi
        sudo mv ninja /usr/bin
    fi

    mkdir -p ~/tmp/qemu
    if [[ ${PKG_DEBUG:-false} == "true" ]]; then
        curl -o /tmp/qemu.tar.tz "https://download.qemu.org/$qemu_tarball"
    else
        curl -o /tmp/qemu.tar.tz "https://download.qemu.org/$qemu_tarball" 2>/dev/null
    fi
    trap "rm -rf ~/tmp/" EXIT
    tar xf /tmp/qemu.tar.tz -C ~/tmp/qemu --strip-components=1

    echo "INFO: Building QEMU source code"
    pushd ~/tmp/qemu >/dev/null
    # shellcheck disable=SC2086
    ./configure $configure_flags
    if [[ ${PKG_DEBUG:-false} == "true" ]]; then
        make
    else
        make >/dev/null
    fi
    echo "INFO: Installing QEMU $version version"
    sudo make install
    popd >/dev/null
}

main
