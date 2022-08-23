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
if [[ ${DEBUG:-false} == "true" ]]; then
    set -o xtrace
fi

function run_integration_tests {
    local profile="${PROFILE:-main}"

    # Start main install test
    [[ $profile == "main" ]] && run_test

    # shellcheck disable=SC2044
    for vagrantfile in $(find . -mindepth 2 -type f -name Vagrantfile | sort); do
        pushd "$(dirname "$vagrantfile")" >/dev/null
        tests="profile_$profile"
        if [[ (${profiles} == *"$profile"* && ${!tests} == *"$(basename "$(pwd)")"*) || ($profile == "main" && $ci_tests != *"$(basename "$(pwd)")"*) ]]; then
            run_test
        fi
        popd >/dev/null
    done
}

if ! command -v vagrant; then
    vagrant_version=2.2.16

    echo "Install Integration dependencies - $VAGRANT_NAME"
    # shellcheck disable=SC1091
    source /etc/os-release || source /usr/lib/os-release
    case ${ID,,} in
    ubuntu | debian)
        echo '* libraries/restart-without-asking boolean true' | sudo debconf-set-selections
        sudo apt-get update
        sudo apt-get install -y -qq -o=Dpkg::Use-Pty=0 --no-install-recommends curl qemu bridge-utils dnsmasq ebtables libvirt-daemon-system libvirt-dev libxslt-dev libxml2-dev zlib1g-dev cpu-checker qemu-kvm ruby-dev gcc
        sudo usermod -a -G libvirt "$USER"
        curl -o vagrant.deb "https://releases.hashicorp.com/vagrant/$vagrant_version/vagrant_${vagrant_version}_x86_64.deb"
        sudo dpkg -i vagrant.deb
        ;;
    esac
    vagrant plugin install vagrant-libvirt
    vagrant plugin install vagrant-reload
fi

source ./ci/_utils.sh
source ./ci/_common.sh

trap exit_trap ERR

if [[ "$(uname)" == *"Darwin"* ]]; then
    trap 'pkill -s KILL sleep' EXIT
fi
if [[ "$(uname)" == *"Linux"* ]]; then
    trap 'pkill --signal SIGKILL sleep' EXIT
fi

if [ -f "/sys/class/net/$mgmt_nic/statistics/rx_bytes" ]; then
    int_rx_bytes_before=$(cat "/sys/class/net/$mgmt_nic/statistics/rx_bytes")
fi
int_start=$(date +%s)

info "Starting Integration tests - $VAGRANT_NAME"
run_integration_tests

info "Integration tests completed - $VAGRANT_NAME"
if [ -f "/sys/class/net/$mgmt_nic/statistics/rx_bytes" ]; then
    int_rx_bytes_after=$(cat "/sys/class/net/$mgmt_nic/statistics/rx_bytes")
    printf "%'.f MB total downloaded\n" "$(((int_rx_bytes_after - int_rx_bytes_before) / ratio))"
fi
printf "%s secs\n" "$(($(date +%s) - int_start))"
