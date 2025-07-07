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
if [[ ${PKG_DEBUG:-false} == "true" ]]; then
	set -o xtrace
fi

function get_github_latest_release {
	version=""
	attempt_counter=0
	max_attempts=5

	until [ "$version" ]; do
		url_effective=$(curl -sL -o /dev/null -w '%{url_effective}' "https://github.com/$1/releases/latest")
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
	echo "${version#v}"
}

function main {
	local version=${PKG_HADOLINT_VERSION:-$(get_github_latest_release hadolint/hadolint)}

	if ! command -v hadolint || [[ "$(hadolint --version | awk '{gsub("-no-git", "", $4); print $4}')" != "$version" ]]; then
		echo "INFO: Installing hadolint $version version..."
		binary="hadolint-$(uname)-$(uname -m)"
		url="https://github.com/hadolint/hadolint/releases/download/v${version}/$binary"
		if [[ ${PKG_DEBUG:-false} == "true" ]]; then
			curl -Lo ./hadolint "$url"
		else
			curl -Lo ./hadolint "$url" 2>/dev/null
		fi
		chmod +x ./hadolint
		sudo mkdir -p /usr/local/bin/
		sudo mv ./hadolint /usr/local/bin/hadolint
		export PATH=$PATH:/usr/local/bin/
	fi
}

main
