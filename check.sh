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
    _print_msg "INFO" "$1"
}

function error {
    _print_msg "ERROR" "$1"
    exit 1
}

function _print_msg {
    echo "$(date +%H:%M:%S) - $1: $2"
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
for vagrantfile in $(find . -mindepth 2 -type f -name Vagrantfile); do
    pushd "$(dirname "$vagrantfile")" > /dev/null
    info "Starting VM on $(pwd) for $1"
    start=$(date +%s)
    newgrp libvirt <<EONG
    MEMORY=4096 vagrant up "$1" > /dev/null
    if vagrant ssh "$1" -- cat validate.log | grep "ERROR"; then
        vagrant ssh "$1" -- cat main.log
        error "Error $1 VM on $(pwd)"
    fi
    vagrant ssh "$1" -- cat validate.log | grep "INFO"
EONG
    info "Duration time: $(($(date +%s)-start)) secs"
    info "Destroying VM on $(pwd) for $1"
    newgrp libvirt <<EONG
    vagrant destroy -f "$1" > /dev/null
EONG
    popd > /dev/null
done
info "Integration tests completed - $1"
