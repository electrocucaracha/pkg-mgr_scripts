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

if command -v docker; then
    echo "docker package is already installed"
    exit 1
fi

PKG=docker ./install.sh

if ! command -v docker; then
    echo "docker package wasn't installed"
    exit 1
fi

if command -v go; then
    echo "go-lang package is already installed"
    exit 1
fi

PKG="docker go-lang" ./install.sh

# shellcheck disable=SC1091
source /etc/profile.d/path.sh
if ! command -v go; then
    echo "go-lang package wasn't installed"
    exit 1
fi
