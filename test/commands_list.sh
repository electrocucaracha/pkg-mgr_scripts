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

if command -v kn; then
	echo "kn is already installed"
	exit 1
fi
if command -v git; then
	echo "git is already installed"
	exit 1
fi

PKG_COMMANDS_LIST="kn,git" ./install.sh

if ! command -v kn; then
	echo "kn package wasn't installed"
	exit 1
fi

if ! command -v git; then
	echo "git package wasn't installed"
	exit 1
fi

if command -v kubectl; then
	echo "kubectl is already installed"
	exit 1
fi

PKG_KREW_PLUGINS_LIST=" " PKG="kubectl" PKG_COMMANDS_LIST="kn,git" ./install.sh

if ! command -v kubectl; then
	echo "kubectl package wasn't installed"
	exit 1
fi
