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

function main {
    local version=${PKG_VIRTUALBOX_VERSION:-6.1}

    if command -v VBoxManage; then
        return
    fi

    pushd "$(mktemp -d)" 2> /dev/null
    pkgs="VirtualBox-$version dkms"
    enable_build_vbox_modules="false"
    curl -o oracle_vbox.asc https://www.virtualbox.org/download/oracle_vbox.asc
    # shellcheck disable=SC1091
    source /etc/os-release || source /usr/lib/os-release
    case ${ID,,} in
        opensuse*)
            supported_versions="11.4 12.3 13.1 13.2 15.0 42.1 42.2 42.3"
            if [[ "$supported_versions" != *"$VERSION_ID"* ]]; then
                echo "WARN: VirtualBox's repo is not supported in openSUSE $VERSION_ID"
                INSTALLER_CMD="sudo -H -E zypper "
                if [[ "${PKG_DEBUG:-false}" == "false" ]]; then
                    INSTALLER_CMD+="-q "
                fi
                sudo zypper --gpg-auto-import-keys refresh
                $INSTALLER_CMD install -y --no-recommends virtualbox dkms
                return
            else
                if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
                    sudo curl -o /etc/zypp/repos.d/virtualbox.repo "http://download.virtualbox.org/virtualbox/rpm/opensuse/virtualbox.repo"
                else
                    sudo curl -o /etc/zypp/repos.d/virtualbox.repo "http://download.virtualbox.org/virtualbox/rpm/opensuse/virtualbox.repo" 2> /dev/null
                fi
                sudo rpm --import oracle_vbox.asc
            fi
        ;;
        ubuntu|debian)
            curl -fsSL http://bit.ly/install_pkg | PKG=gnupg bash
            echo "deb http://download.virtualbox.org/virtualbox/debian $VERSION_CODENAME contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list 2> /dev/null
            curl -fsSL https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo apt-key add -
        ;;
        rhel|centos|fedora)
            if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
                sudo curl -o /etc/yum.repos.d/virtualbox.repo https://download.virtualbox.org/virtualbox/rpm/el/virtualbox.repo
                sudo rpm --import --verbose oracle_vbox.asc
            else
                sudo curl -o /etc/yum.repos.d/virtualbox.repo https://download.virtualbox.org/virtualbox/rpm/el/virtualbox.repo 2> /dev/null
                sudo rpm --import --quiet oracle_vbox.asc
            fi
            sudo "$(command -v dnf || command -v yum)" repolist --assumeyes || true
            pkgs+=" kernel-devel kernel-devel-$(uname -r)"
            enable_build_vbox_modules="true"
        ;;
        clear-linux-os)
            echo "WARN: The VirtualBox provider isn't supported by ClearLinux yet."
            return
        ;;
    esac
    rm oracle_vbox.asc
    popd 2> /dev/null
    curl -fsSL http://bit.ly/install_pkg | PKG="$pkgs" PKG_UPDATE=true bash
    if [ "$enable_build_vbox_modules" == "true" ]; then
        sudo /sbin/vboxconfig
    fi
}

main
