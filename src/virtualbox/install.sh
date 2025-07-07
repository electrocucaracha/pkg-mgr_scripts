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

function main {
	# shellcheck disable=SC1091
	source /etc/os-release || source /usr/lib/os-release

	local version=${PKG_VIRTUALBOX_VERSION:-7.0}
	[[ ${VERSION_CODENAME-} == "xenial" ]] && version="6.1"

	if command -v VBoxManage >/dev/null && [[ $(VBoxManage --version) == "$version"* ]]; then
		return
	fi

	echo "INFO: Installing VirtualBox $version version..."
	pushd "$(mktemp -d)" 2>/dev/null
	pkgs="VirtualBox-$version dkms"
	curl -o oracle_vbox.asc https://www.virtualbox.org/download/oracle_vbox.asc
	case ${ID,,} in
	opensuse*)
		supported_versions="11.4 12.3 13.1 13.2 15.0 42.1 42.2 42.3"
		if [[ $supported_versions != *"$VERSION_ID"* ]]; then
			echo "WARN: VirtualBox's repo is not supported in openSUSE $VERSION_ID"
			pkgs="virtualbox dkms"
		else
			if [[ ${PKG_DEBUG:-false} == "true" ]]; then
				sudo curl -o /etc/zypp/repos.d/virtualbox.repo "http://download.virtualbox.org/virtualbox/rpm/opensuse/virtualbox.repo"
			else
				sudo curl -o /etc/zypp/repos.d/virtualbox.repo "http://download.virtualbox.org/virtualbox/rpm/opensuse/virtualbox.repo" 2>/dev/null
			fi
			sudo rpm --import oracle_vbox.asc
		fi
		pkgs+=" virtualbox-host-source"
		sudo zypper --gpg-auto-import-keys refresh
		INSTALLER_CMD="sudo -H -E zypper "
		if [[ ${PKG_DEBUG:-false} == "false" ]]; then
			INSTALLER_CMD+="-q "
		fi
		eval "$INSTALLER_CMD install -y --no-recommends $pkgs"
		;;
	ubuntu | debian)
		sudo apt-get install -y -qq -o=Dpkg::Use-Pty=0 gnupg
		echo "deb http://download.virtualbox.org/virtualbox/debian $VERSION_CODENAME contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list 2>/dev/null
		curl -fsSL https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo apt-key add -
		sudo apt-get update -qq >/dev/null
		eval "sudo apt-get install -y -qq -o=Dpkg::Use-Pty=0 $pkgs"
		;;
	rhel | centos | fedora | rocky)
		PKG_MANAGER=$(command -v dnf || command -v yum)
		if [[ ${PKG_DEBUG:-false} == "true" ]]; then
			sudo curl -o /etc/yum.repos.d/virtualbox.repo https://download.virtualbox.org/virtualbox/rpm/el/virtualbox.repo
			sudo rpm --import --verbose oracle_vbox.asc
		else
			sudo curl -o /etc/yum.repos.d/virtualbox.repo https://download.virtualbox.org/virtualbox/rpm/el/virtualbox.repo 2>/dev/null
			sudo rpm --import --quiet oracle_vbox.asc
		fi
		if ! sudo "$PKG_MANAGER" repolist | grep "epel/"; then
			sudo -H -E "$PKG_MANAGER" -q -y install epel-release
		fi
		sudo "$PKG_MANAGER" repolist --assumeyes || true
		pkgs+=" kernel-devel kernel-devel-$(uname -r)"
		eval "sudo $PKG_MANAGER -y --quiet --errorlevel=0 install $pkgs"
		sudo usermod -aG vboxusers "$USER"
		;;
	esac
	popd 2>/dev/null
}

main
