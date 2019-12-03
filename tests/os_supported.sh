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

if command -v wget; then
    echo "wget is already installed"
fi

PKG=wget ./install.sh

if ! command -v wget; then
    echo "wget package wasn't installed"
    exit 1
fi

if command -v mkpasswd; then
    echo "vim is already installed"
fi

PKG="wget mkpasswd" ./install.sh

if ! command -v mkpasswd; then
    echo "vim package wasn't installed"
    exit 1
fi
