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
if [[ ${PKG_DEBUG:-false} == "true" ]]; then
	set -o xtrace
fi

function get_go_latest_version {
	version=""
	attempt_counter=0
	max_attempts=5

	until [ "$version" ]; do
		stable_version="$(curl -sL https://golang.org/VERSION?m=text | head -n 1)"
		if [ "$stable_version" ]; then
			echo "${stable_version#go}"
			break
		elif [ ${attempt_counter} -eq ${max_attempts} ]; then
			echo "Max attempts reached"
			exit 1
		fi
		attempt_counter=$((attempt_counter + 1))
		sleep $((attempt_counter * 2))
	done
}

function main {
	local version=${PKG_GOLANG_VERSION:-$(get_go_latest_version)}

	OS="$(uname | tr '[:upper:]' '[:lower:]')"
	ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')"
	tarball=go$version.$OS-$ARCH.tar.gz

	if command -v go && [[ "$(go version | awk '{print $3}')" == "go$version" ]]; then
		echo "INFO: Go $version version already installed"
		return
	fi

	# NOTE: Ensure go-lang was not installed by the OS package manager
	# shellcheck disable=SC1091
	source /etc/os-release || source /usr/lib/os-release
	case ${ID,,} in
	*suse*)
		if zypper search --match-exact --installed-only go &>/dev/null; then
			sudo zypper -q remove -y -u go
		fi
		;;
	ubuntu | debian)
		if dpkg -l golang &>/dev/null; then
			sudo apt autoremove -y -qq golang
		fi
		;;
	rhel | centos | fedora | rocky)
		if rpm -q golang &>/dev/null; then
			# shellcheck disable=SC2046
			sudo $(command -v dnf || command -v yum) -y --quiet --errorlevel=0 autoremove golang
		fi
		;;
	esac

	echo "INFO: Installing go $version version..."
	pushd "$(mktemp -d)" >/dev/null
	echo insecure >>~/.curlrc
	trap 'sed -i "/^insecure\$/d" ~/.curlrc' EXIT
	if [[ ${PKG_DEBUG:-false} == "true" ]]; then
		curl -L -o "$tarball" "https://go.dev/dl/$tarball"
		sudo tar -C /usr/local -vxzf "$tarball"
	else
		curl -sL -o "$tarball" "https://go.dev/dl/$tarball"
		sudo tar -C /usr/local -xzf "$tarball"
	fi
	popd >/dev/null

	sudo mkdir -p /etc/profile.d/
	# shellcheck disable=SC2016
	echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/path.sh >/dev/null
}

main
