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
    if command -v crystal; then
        return
    fi
    echo "INFO: Installing crystal..."

    pkgs="crystal"
    # shellcheck disable=SC1091
    source /etc/os-release || source /usr/lib/os-release
    case ${ID,,} in
        *suse*)
            sudo rpm --import https://dist.crystal-lang.org/rpm/RPM-GPG-KEY
            sudo zypper ar -e -f -t rpm-md https://dist.crystal-lang.org/rpm/ Crystal
        ;;
        ubuntu|debian|raspbian)
            curl -fsSL http://bit.ly/install_pkg | PKG="gnupg" bash
            curl -sL "https://keybase.io/crystal/pgp_keys.asc" | sudo apt-key add -
            echo "deb https://dist.crystal-lang.org/apt crystal main" | sudo tee /etc/apt/sources.list.d/crystal.list
            pkgs+=" libssl-dev libxml2-dev libyaml-dev libgmp-dev libreadline-dev libz-dev"
        ;;
        rhel|centos|fedora)
            curl -sSL https://dist.crystal-lang.org/rpm/setup.sh | sudo bash
        ;;
        clear-linux-os)
            echo "WARN: The Crystal programming isn't supported by ClearLinux yet."
            return
        ;;
    esac
    curl -fsSL http://bit.ly/install_pkg | PKG="$pkgs" PKG_UPDATE=true bash
}

main
