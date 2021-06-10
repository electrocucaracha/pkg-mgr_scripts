#!/bin/bash
# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2021
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

set -o errexit
set -o nounset
set -o pipefail

if ! command -v bindep; then
    curl -fsSL https://raw.githubusercontent.com/electrocucaracha/pkg-mgr_scripts/master/install.sh | PKG=bindep bash
fi

if [ -n "${PKG_BINDEP_PROFILE:-}" ]; then
    PKG="$(bindep -b "$PKG_BINDEP_PROFILE" || :)"
else
    PKG="$(bindep -b || :)"
fi
export PKG

echo "Installing binary dependencies..."
curl -fsSL https://raw.githubusercontent.com/electrocucaracha/pkg-mgr_scripts/master/install.sh | bash
