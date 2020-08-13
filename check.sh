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

function die {
    echo >&2 "$@"
    exit 1
}

function info {
    echo "$(date +%H:%M:%S) - INFO: $1"
}

[ "$#" -eq 1 ] || die "1 argument required, $# provided"

info "Install Integration dependencies - $1"
# shellcheck disable=SC1091
source /etc/os-release || source /usr/lib/os-release
case ${ID,,} in
    ubuntu|debian)
        sudo apt-get update
        sudo apt-get install -y -qq -o=Dpkg::Use-Pty=0 --no-install-recommends curl qemu
    ;;
esac
PKG="vagrant bridge-utils dnsmasq ebtables libvirt qemu-kvm"
PKG+=" ruby-devel gcc"
export PKG
curl -fsSL http://bit.ly/install_pkg | bash
vagrant plugin install vagrant-libvirt

info "Starting Integration tests - $1"
newgrp libvirt <<EONG
MEMORY=6144 vagrant up "$1" > /dev/null
vagrant destroy -f "$1" > /dev/null
EONG

# shellcheck disable=SC2044
for vagrantfile in $(find . -mindepth 2 -type f -name Vagrantfile | sort); do
    pushd "$(dirname "$vagrantfile")" > /dev/null
    if [ -f os-blacklist.conf ] && grep "$1" os-blacklist.conf > /dev/null; then
        info "Skipping $(basename "$(pwd)") test for $1"
        popd > /dev/null
        continue
    fi
    info "Starting $(basename "$(pwd)") test for $1"
    start=$(date +%s)
    trap 'sudo vagrant ssh $1 -- cat main.log' ERR
    MEMORY=4096 sudo vagrant up "$1"
    if sudo vagrant ssh "$1" -- cat validate.log | grep "ERROR"; then
        echo "$(date +%H:%M:%S) - ERROR"
        sudo vagrant ssh "$1" -- cat main.log
        exit 1
    fi
    sudo vagrant ssh "$1" -- cat validate.log | grep "INFO"
    info "Duration time: $(($(date +%s)-start)) secs"
    info "$(basename "$(pwd)") test completed for $1"
    sudo vagrant destroy -f "$1" > /dev/null
    popd > /dev/null
done
info "Integration tests completed - $1"
