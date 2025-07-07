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

function error {
	_print_msg "ERROR" "$1"
	exit 1
}

function _print_msg {
	echo "$1: $2"
}

function get_version {
	local version=${PKG_KIND_VERSION-}
	attempt_counter=0
	max_attempts=5

	until [ "$version" ]; do
		url_effective=$(curl -sL -o /dev/null -w '%{url_effective}' "https://github.com/kubernetes-sigs/kind/releases/latest")
		if [ "$url_effective" ]; then
			version="${url_effective##*/}"
			break
		elif [ ${attempt_counter} -eq ${max_attempts} ]; then
			echo "Max attempts reached"
			exit 1
		fi
		attempt_counter=$((attempt_counter + 1))
		sleep $((attempt_counter * 2))
	done
	echo "${version#*v}"
}

info "Validating kind installation..."
if ! command -v kind; then
	error "Kubernetes IN Docker command line wasn't installed"
fi

info "Validating autocomplete functions"
if declare -F | grep -q "_kind"; then
	error "Kind autocomplete install failed"
fi

info "Checking Kind version"
if [ "$(kind --version | awk '{print $3}')" != "$(get_version)" ]; then
	error "Kind version installed is different that expected"
fi
