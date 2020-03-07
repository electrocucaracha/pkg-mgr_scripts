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

function main {
    local version=${PKG_VIRTUALBOX_VERSION:-6.1}

    if command -v VBoxManage; then
        return
    fi

    pushd "$(mktemp -d)"
    pkgs="VirtualBox-$version dkms"
    curl -o oracle_vbox.asc https://www.virtualbox.org/download/oracle_vbox.asc
    # shellcheck disable=SC1091
    source /etc/os-release || source /usr/lib/os-release
    case ${ID,,} in
        opensuse*)
            sudo curl -o /etc/zypp/repos.d/virtualbox.repo "http://download.virtualbox.org/virtualbox/rpm/opensuse/virtualbox.repo"
            sudo rpm --import oracle_vbox.asc
        ;;
        ubuntu|debian)
            curl -fsSL http://bit.ly/install_pkg | PKG=gnupg bash
            echo "deb http://download.virtualbox.org/virtualbox/debian $UBUNTU_CODENAME contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
            curl -fsSL https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo apt-key add -
        ;;
        rhel|centos|fedora)
            sudo curl -o /etc/yum.repos.d/virtualbox.repo https://download.virtualbox.org/virtualbox/rpm/el/virtualbox.repo
            sudo rpm --import oracle_vbox.asc
            PKG_MANAGER=$(command -v dnf || command -v yum)
            sudo -E "$PKG_MANAGER" update --assumeyes
        ;;
        clear-linux-os)
            echo "WARN: The VirtualBox provider isn't supported by ClearLinux yet."
            return
        ;;
    esac
    rm oracle_vbox.asc
    popd
    curl -fsSL http://bit.ly/install_pkg | PKG="$pkgs" PKG_UDPATE=true bash
}

main
