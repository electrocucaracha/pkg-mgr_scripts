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
if [[ ${PKG_DEBUG:-false} == "true" ]]; then
	set -o xtrace
fi

function main {
	if command -v rustup; then
		return
	fi
	echo "INFO: Installing rustc..."
	curl https://sh.rustup.rs -sSf | sh -s -- -y
}

main
