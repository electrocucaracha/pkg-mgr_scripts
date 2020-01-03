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

function main {
    if command -v pip; then
        return
    fi

    if ! command -v python; then
        # shellcheck disable=SC1091
        source /etc/os-release || source /usr/lib/os-release
        case ${ID,,} in
            ubuntu|debian)
            sudo -H -E apt-get -y -q=3 install python-minimal
            ;;
            rhel|centos|fedora)
            PKG_MANAGER=$(command -v dnf || command -v yum)
            sudo -H -E "${PKG_MANAGER}" -q -y install python36
            sudo rm /usr/bin/python
            sudo ln -s /usr/bin/python3 /usr/bin/python
            sudo sed -i "s|#!/usr/bin/python|#!$(command -v python2)|g" /usr/bin/yum
            ;;
        esac
    fi
    curl -sL https://bootstrap.pypa.io/get-pip.py | sudo python
}

main
