#!/bin/bash
# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2019
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

set -o errexit
set -o pipefail

vagrant_version=2.2.10
export PKG_GOLANG_VERSION=1.15.2
export PKG_KIND_VERSION=0.9.0
export PKG_TERRAFORM_VERSION=0.13.5
export PKG_VAGRANT_VERSION=2.2.10
export PKG_CNI_PLUGINS_VERSION=0.8.7
export PKG_CRUN_VERSION=0.15

function info {
    echo "$(date +%H:%M:%S) - INFO: $1"
}

function exit_trap {
    sudo vagrant ssh "${VAGRANT_NAME:-ubuntu_xenial}" -- cat main.log
}

info "Install Integration dependencies - ${VAGRANT_NAME:-ubuntu_xenial}"
# shellcheck disable=SC1091
source /etc/os-release || source /usr/lib/os-release
case ${ID,,} in
    ubuntu|debian)
        echo '* libraries/restart-without-asking boolean true' | sudo debconf-set-selections
        sudo apt-get update
        sudo apt-get install -y -qq -o=Dpkg::Use-Pty=0 --no-install-recommends curl qemu bridge-utils dnsmasq ebtables libvirt-daemon-system libvirt-dev libxslt-dev libxml2-dev zlib1g-dev cpu-checker qemu-kvm ruby-dev gcc
        sudo usermod -a -G libvirt "$USER"
        curl -o vagrant.deb "https://releases.hashicorp.com/vagrant/$vagrant_version/vagrant_${vagrant_version}_x86_64.deb"
        sudo dpkg -i vagrant.deb
    ;;
esac
vagrant plugin install vagrant-libvirt

info "Starting Integration tests - ${VAGRANT_NAME:-ubuntu_xenial}"
newgrp libvirt <<EONG
CPUS=2 MEMORY=6144 vagrant up "${VAGRANT_NAME:-ubuntu_xenial}" > /dev/null
vagrant destroy -f "${VAGRANT_NAME:-ubuntu_xenial}" > /dev/null
EONG

trap exit_trap ERR
# shellcheck disable=SC2044
for vagrantfile in $(find . -mindepth 2 -type f -name Vagrantfile | sort); do
    pushd "$(dirname "$vagrantfile")" > /dev/null
    if [ -f os-blacklist.conf ] && grep "${VAGRANT_NAME:-ubuntu_xenial}" os-blacklist.conf > /dev/null; then
        info "Skipping $(basename "$(pwd)") test for ${VAGRANT_NAME:-ubuntu_xenial}"
        popd > /dev/null
        continue
    fi
    info "Starting $(basename "$(pwd)") test for ${VAGRANT_NAME:-ubuntu_xenial}"
    start=$(date +%s)
    CPUS=2 MEMORY=6144 sudo -E vagrant up --no-destroy-on-error "${VAGRANT_NAME:-ubuntu_xenial}"
    if sudo vagrant ssh "${VAGRANT_NAME:-ubuntu_xenial}" -- cat validate.log | grep "ERROR"; then
        echo "$(date +%H:%M:%S) - ERROR"
        sudo vagrant ssh "${VAGRANT_NAME:-ubuntu_xenial}" -- cat main.log
        exit 1
    fi
    sudo vagrant ssh "${VAGRANT_NAME:-ubuntu_xenial}" -- cat validate.log | grep "INFO"
    info "Duration time: $(($(date +%s)-start)) secs"
    info "$(basename "$(pwd)") test completed for ${VAGRANT_NAME:-ubuntu_xenial}"
    sudo vagrant destroy -f "${VAGRANT_NAME:-ubuntu_xenial}" > /dev/null
    popd > /dev/null
done
info "Integration tests completed - ${VAGRANT_NAME:-ubuntu_xenial}"
