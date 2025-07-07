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

# _vercmp() - Function that compares two versions
function _vercmp {
	local v1=$1
	local op=$2
	local v2=$3
	local result

	# sort the two numbers with sort's "-V" argument.  Based on if v2
	# swapped places with v1, we can determine ordering.
	result=$(echo -e "$v1\n$v2" | sort -V | head -1)

	case $op in
	"==")
		[ "$v1" = "$v2" ]
		return
		;;
	">")
		[ "$v1" != "$v2" ] && [ "$result" = "$v2" ]
		return
		;;
	"<")
		[ "$v1" != "$v2" ] && [ "$result" = "$v1" ]
		return
		;;
	">=")
		[ "$result" = "$v2" ]
		return
		;;
	"<=")
		[ "$result" = "$v1" ]
		return
		;;
	*)
		echo "unrecognised op: $op"
		exit 1
		;;
	esac
}

function main {
	if command -v skopeo; then
		return
	fi

	echo "INFO: Installing skopeo..."
	INSTALLER_CMD="sudo -H -E "
	# shellcheck disable=SC1091
	source /etc/os-release || source /usr/lib/os-release
	case ${ID,,} in
	*suse*)
		INSTALLER_CMD+="zypper "
		if [[ ${PKG_DEBUG:-false} == "false" ]]; then
			INSTALLER_CMD+="-q "
		fi
		INSTALLER_CMD+="install -y --no-recommends"
		;;
	ubuntu | debian)
		if _vercmp "${VERSION_ID}" '<=' "16.04"; then
			echo "WARN: skopeo is not supported in Ubuntu $VERSION_ID"
			return
		fi
		if _vercmp "${VERSION_ID}" '<' "20.04" && [ "$(uname -m)" != "x86_64" ]; then
			echo "WARN: skopeo doesn't support  non x86_64 architectures in Ubuntu $VERSION_ID"
			return
		fi
		INSTALLER_CMD+="apt-get -y "
		if [[ ${PKG_DEBUG:-false} == "false" ]]; then
			INSTALLER_CMD+="-q=3 "
		fi
		INSTALLER_CMD+=" --no-install-recommends install"
		echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
		curl -sL "https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/Release.key" | sudo apt-key add -
		sudo apt-get update || :
		$INSTALLER_CMD --reinstall ca-certificates
		sudo apt-get update
		;;
	rhel | centos | fedora | rocky)
		INSTALLER_CMD+="$(command -v dnf || command -v yum) -y"
		if [[ ${PKG_DEBUG:-false} == "false" ]]; then
			INSTALLER_CMD+=" --quiet --errorlevel=0"
		fi
		INSTALLER_CMD+=" install"
		if [ "${VERSION_ID}" == "7" ]; then
			sudo curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable.repo https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/CentOS_7/devel:kubic:libcontainers:stable.repo
		fi
		;;
	esac
	$INSTALLER_CMD skopeo
}

main
