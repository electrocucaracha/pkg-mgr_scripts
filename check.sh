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
if [[ "${DEBUG:-false}" == "true" ]]; then
    set -o xtrace
fi

function run_integration_tests {
    kvm_tests=$(cat long-tests.txt)
    local run_long_tests="${RUN_LONG_TESTS:-false}"

    # Start main install test
    [[ "$run_long_tests" == "true" ]] && run_test

    # shellcheck disable=SC2044
    for vagrantfile in $(find . -mindepth 2 -type f -name Vagrantfile | sort); do
        pushd "$(dirname "$vagrantfile")" > /dev/null
        if [[ ( "$run_long_tests" = "true" && "$kvm_tests" == *"$(basename "$(pwd)")"* ) || ( "$run_long_tests" = "false" &&  "$kvm_tests" != *"$(basename "$(pwd)")"* ) ]]; then
            run_test
        fi
        popd > /dev/null
    done
}

if ! command -v vagrant; then
    vagrant_version=2.2.15

    echo "Install Integration dependencies - $VAGRANT_NAME"
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
    vagrant plugin install vagrant-reload
fi

source ./_utils.sh
source ./_common.sh

trap exit_trap ERR
trap 'pkill --signal SIGKILL sleep' EXIT

int_rx_bytes_before=$(cat "/sys/class/net/$mgmt_nic/statistics/rx_bytes")
int_start=$(date +%s)

info "Starting Integration tests - $VAGRANT_NAME"
run_integration_tests

info "Integration tests completed - $VAGRANT_NAME"
int_rx_bytes_after=$(cat "/sys/class/net/$mgmt_nic/statistics/rx_bytes")
printf "%'.f MB total downloaded\n"  "$(((int_rx_bytes_after-int_rx_bytes_before)/ratio))"
printf "%s secs\n" "$(($(date +%s)-int_start))"
