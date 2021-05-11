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

function get_github_latest_release {
    version=""
    attempt_counter=0
    max_attempts=5

    until [ "$version" ]; do
        url_effective=$(curl -sL -o /dev/null -w '%{url_effective}' "https://github.com/$1/releases/latest")
        if [ "$url_effective" ]; then
            version="${url_effective##*/}"
            break
        elif [ ${attempt_counter} -eq ${max_attempts} ];then
            echo "Max attempts reached"
            exit 1
        fi
        attempt_counter=$((attempt_counter+1))
        sleep 2
    done
    echo "${version#v}"
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
    local ninja_version=${PKG_NINJA_VERSION:-$(get_github_latest_release ninja-build/ninja)}
    local version=${PKG_QEMU_VERSION:-6.0.0}
    local qemu_tarball="qemu-${version}.tar.xz"
    local pmdk_version=${PKG_PMDK_VERSION:-1.4}
    local pmdk_url="https://github.com/pmem/pmdk/releases/download/$pmdk_version/pmdk-${pmdk_version}-"

    if command -v qemu-img; then
        return
    fi

    echo "INFO: Installing building packages"
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
            sudo -H -E zypper install -y --no-recommends git gcc make bzip2 glib2-devel libpixman-1-0-devel diffutils zlib-devel libbz2-devel libopenssl-devel ncurses-devel readline-devel sqlite3 sqlite3-devel tack xz-devel unzip
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
            sudo -H -E apt-get -y install --no-install-recommends python3.7 gcc make libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev libpmem-dev libnuma-dev unzip
            sudo rm -f /usr/bin/python3
            sudo ln -s /usr/bin/python3.7 /usr/bin/python3
        ;;
        rhel|centos|fedora)
            configure_flags+=" --enable-numa"
            PKG_MANAGER=$(command -v dnf || command -v yum)
            sudo -H -E "${PKG_MANAGER}" -y install python36 gcc make glib2-devel pixman-devel zlib-devel libpmem-devel numactl-devel bzip2 unzip
        ;;
    esac
    if ! command -v ninja || _vercmp "$(ninja --version)" '<' "1.7"; then
        echo "INFO: Installing Ninja build $ninja_version version"
        url="https://github.com/ninja-build/ninja/releases/download/v${ninja_version#*v}/ninja-$(uname | tr '[:upper:]' '[:lower:]').zip"
        if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
            curl -o /tmp/ninja.zip -L "$url"
            unzip /tmp/ninja.zip
        else
            curl -o /tmp/ninja.zip -L "$url" 2>/dev/null
            unzip -qq /tmp/ninja.zip
        fi
        sudo mv ninja /usr/bin
    fi

    mkdir -p ~/tmp/qemu
    if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
        curl -o /tmp/qemu.tar.tz "https://download.qemu.org/$qemu_tarball"
    else
        curl -o /tmp/qemu.tar.tz "https://download.qemu.org/$qemu_tarball" 2> /dev/null
    fi
    trap "rm -rf ~/tmp/" EXIT
    tar xf /tmp/qemu.tar.tz -C ~/tmp/qemu --strip-components=1

    echo "INFO: Building QEMU source code"
    pushd ~/tmp/qemu > /dev/null
    # shellcheck disable=SC2086
    ./configure $configure_flags
    if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
        make
    else
        make > /dev/null
    fi
    echo "INFO: Installing QEMU $version version"
    sudo make install
    popd > /dev/null
}

main
