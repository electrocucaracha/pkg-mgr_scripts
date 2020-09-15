#!/bin/bash
# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2019
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
    if [ -z "${PKG_CPU_ARCH:-}" ]; then
        case "$(uname -m)" in
            x86_64)
                PKG_CPU_ARCH=amd64
            ;;
            armv8*)
                PKG_CPU_ARCH=arm64
            ;;
            aarch64*)
                PKG_CPU_ARCH=arm64
            ;;
            armv*)
                PKG_CPU_ARCH=armv7
            ;;
        esac
    fi
    echo "$PKG_CPU_ARCH"
}

function main {
    local version=${PKG_VAGRANT_VERSION:-$(curl -s https://api.github.com/repos/hashicorp/vagrant/tags | grep -Po '"name":.*?[^\\]",' | awk -F  "\"" 'NR==1{print $4}')}

    if ! command -v vagrant || [ "$(vagrant --version | awk '{ print $2}')" != "${version#*v}" ]; then
        echo "INFO: Installing vagrant $version version..."
        pushd "$(mktemp -d)" > /dev/null
        vagrant_pkg="vagrant_${version#*v}_$(uname -m)."
        vagrant_url_pkg="https://releases.hashicorp.com/vagrant/${version#*v}"
        # shellcheck disable=SC1091
        source /etc/os-release || source /usr/lib/os-release
        case ${ID,,} in
            opensuse*)
                vagrant_pgp="pgp_keys.asc"
                vagrant_pkg+="rpm"
                if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
                    curl -o "$vagrant_pgp" "https://keybase.io/hashicorp/$vagrant_pgp"
                    curl -o "$vagrant_pkg" "$vagrant_url_pkg/$vagrant_pkg"
                    gpg --with-fingerprint "$vagrant_pgp"
                else
                    curl -o "$vagrant_pgp" "https://keybase.io/hashicorp/$vagrant_pgp" 2> /dev/null
                    curl -o "$vagrant_pkg" "$vagrant_url_pkg/$vagrant_pkg" 2> /dev/null
                    gpg --quiet --with-fingerprint "$vagrant_pgp"
                fi
                sudo rpm --import "$vagrant_pgp"
                sudo rpm --checksig "$vagrant_pkg"
                sudo rpm --install "$vagrant_pkg"
            ;;
            ubuntu|debian)
                vagrant_pkg+="deb"
                if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
                    curl -o "$vagrant_pkg" "$vagrant_url_pkg/$vagrant_pkg"
                    sudo dpkg -i "$vagrant_pkg"
                else
                    curl -o "$vagrant_pkg" "$vagrant_url_pkg/$vagrant_pkg" 2> /dev/null
                    sudo dpkg -i "$vagrant_pkg" 2> /dev/null
                fi
            ;;
            rhel|centos|fedora)
                vagrant_pkg+="rpm"
                PKG_MANAGER=$(command -v dnf || command -v yum)
                if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
                    curl -o "$vagrant_pkg" "$vagrant_url_pkg/$vagrant_pkg"
                    sudo -H -E "${PKG_MANAGER}" -y install "$vagrant_pkg"
                else
                    curl -o "$vagrant_pkg" "$vagrant_url_pkg/$vagrant_pkg" 2> /dev/null
                    sudo -H -E "${PKG_MANAGER}" -y install --quiet --errorlevel=0 "$vagrant_pkg"
                fi
            ;;
            clear-linux-os)
                vagrant_pkg="vagrant_${version}_$(uname | awk '{print tolower($0)}')_$(get_cpu_arch).zip"
                if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
                    curl -o "$vagrant_pkg" "$vagrant_url_pkg/$vagrant_pkg"
                    if ! command -v unzip; then
                        sudo -H -E swupd bundle-add unzip
                    fi
                    unzip "$vagrant_pkg"
                    sudo -H -E swupd bundle-add devpkg-compat-fuse-soname2 fuse
                else
                    curl -o "$vagrant_pkg" "$vagrant_url_pkg/$vagrant_pkg" 2>/dev/null
                    if ! command -v unzip; then
                        sudo -H -E swupd bundle-add --quiet unzip
                    fi
                    unzip -qq "$vagrant_pkg"
                    sudo -H -E swupd bundle-add --quiet devpkg-compat-fuse-soname2 fuse
                fi
                sudo mkdir -p /usr/local/bin
                sudo mv vagrant /usr/local/bin/
            ;;
        esac
        vagrant autocomplete install
        popd > /dev/null
    fi
}

main
