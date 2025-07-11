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

function info {
	_print_msg "INFO" "$1"
}

function warn {
	_print_msg "WARN" "$1"
}

function error {
	_print_msg "ERROR" "$1"
	exit 1
}

function _print_msg {
	echo "$1: $2"
}

for cmd in node npm; do
	info "Validating $cmd installation..."
	if ! command -v "$cmd"; then
		error "$cmd command line wasn't installed"
	fi

	info "Validating $cmd execution..."
	"$cmd" --version
done
if ! command -v yarn; then
	warn "yarn command line wasn't installed"
fi
