#!/bin/bash
# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2021
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
    local version=${PKG_NODEJS_VERSION:-current}

    if command -v node && command -v yarn; then
        return
    fi

    echo "INFO: Installing nodejs..."

    INSTALLER_CMD="sudo -H -E "
    # shellcheck disable=SC1091
    source /etc/os-release || source /usr/lib/os-release
    case ${ID,,} in
        *suse*)
            INSTALLER_CMD+="zypper "
            if [[ "${PKG_DEBUG:-false}" == "false" ]]; then
                INSTALLER_CMD+="-q "
            fi
            INSTALLER_CMD+="install -y --no-recommends "
            if [[ "${ID,,}" == *leap* ]]; then
                INSTALLER_CMD+="nodejs14"
            elif [[ "${ID,,}" == *tumbleweed* ]]; then
                INSTALLER_CMD+="nodejs16"
            fi
        ;;
        ubuntu|debian)
            url="https://deb"
            INSTALLER_CMD+="apt-get -y "
            if [[ "${PKG_DEBUG:-false}" == "false" ]]; then
                INSTALLER_CMD+="-q=3 "
            fi
            INSTALLER_CMD+=" --no-install-recommends install nodejs"

            curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/yarnkey.gpg >/dev/null
            echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
        ;;
        rhel|centos|fedora)
            url="https://rpm"
            INSTALLER_CMD+="$(command -v dnf || command -v yum) -y"
            if [[ "${PKG_DEBUG:-false}" == "false" ]]; then
                INSTALLER_CMD+=" --quiet --errorlevel=0"
            fi
            INSTALLER_CMD+=" install nodejs"

            curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
        ;;
    esac
    if [ "${url:-}" != "" ]; then
        url+=".nodesource.com/setup_${version}.x"
        curl -fsSL "$url" | sudo -E bash -
    fi

    $INSTALLER_CMD
    rm -rf ~/.yarn/
    curl -o- -L https://yarnpkg.com/install.sh | bash
    # shellcheck disable=SC2016
    echo 'export PATH=$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH' | sudo tee /etc/profile.d/yarn_path.sh > /dev/null
}

main
