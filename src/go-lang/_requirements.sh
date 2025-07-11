#!/bin/bash
# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2020
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

set -o errexit
set -o nounset
set -o pipefail

if ! command -v go; then
	# shellcheck disable=SC1091
	source /etc/os-release || source /usr/lib/os-release
	case ${ID,,} in
	*suse*)
		sudo zypper -q install -y --no-recommends go
		;;
	ubuntu | debian)
		sudo apt-get update -qq >/dev/null
		sudo apt-get install -y -qq -o=Dpkg::Use-Pty=0 golang
		;;
	rhel | centos | fedora | rocky)
		# shellcheck disable=SC2046
		sudo $(command -v dnf || command -v yum) -y --quiet --errorlevel=0 install golang
		;;
	esac
fi
