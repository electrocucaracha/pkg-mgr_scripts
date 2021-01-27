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

vagrant_version=2.2.14
mgmt_nic="$(ip route get 1.1.1.1 | awk 'NR==1 { print $5 }')"
ratio=$((1024*1024)) # MB
export CPUS=${CPUS:-2}
export MEMORY=${MEMORY:-6144}
export VAGRANT_NAME=${VAGRANT_NAME:-ubuntu_xenial}

# Setup CI versions
export PKG_GOLANG_VERSION=1.15.4
export PKG_VAGRANT_VERSION=2.2.14

source _utils.sh

function exit_trap {
    $vagrant_cmd ssh "$VAGRANT_NAME" -- cat main.log
    $vagrant_cmd ssh "$VAGRANT_NAME" -- cat validate.log
}

int_rx_bytes_before=$(cat "/sys/class/net/$mgmt_nic/statistics/rx_bytes")

if ! command -v vagrant; then
    info "Install Integration dependencies - $VAGRANT_NAME"
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
    vagrant plugin install vagrant-libvirt --plugin-version 0.2.1
    vagrant plugin install vagrant-reload
fi

vagrant_cmd=""
if [ "${SUDO_VAGRANT_CMD:-false}" == "true" ]; then
    vagrant_cmd="sudo -E"
fi
vagrant_cmd+=" $(command -v vagrant)"

vagrant_up_cmd="$vagrant_cmd up --no-destroy-on-error $VAGRANT_NAME"
vagrant_destroy_cmd="$vagrant_cmd destroy -f $VAGRANT_NAME"

$vagrant_destroy_cmd > /dev/null
trap exit_trap ERR

info "Starting Integration tests - $VAGRANT_NAME"

# Main install function test
$vagrant_up_cmd | tee "/tmp/check_$VAGRANT_NAME.log"
$vagrant_destroy_cmd > /dev/null

# shellcheck disable=SC2044
for vagrantfile in $(find . -mindepth 2 -type f -name Vagrantfile | sort); do
    pushd "$(dirname "$vagrantfile")" > /dev/null
    if [ -f os-blacklist.conf ] && grep "$VAGRANT_NAME" os-blacklist.conf > /dev/null; then
        info "Skipping $(basename "$(pwd)") test for $VAGRANT_NAME"
        popd > /dev/null
        continue
    fi
    $vagrant_destroy_cmd > /dev/null
    rx_bytes_before=$(cat "/sys/class/net/$mgmt_nic/statistics/rx_bytes")

    info "Starting $(basename "$(pwd)") test for $VAGRANT_NAME"
    start=$(date +%s)
    $vagrant_up_cmd >> "/tmp/check_$VAGRANT_NAME.log"

    # Verify validation errors
    if $vagrant_cmd ssh "$VAGRANT_NAME" -- cat validate.log | grep "ERROR"; then
        info "Found an error during the validation of $(basename "$(pwd)") in $VAGRANT_NAME"
        $vagrant_cmd ssh "$VAGRANT_NAME" -- cat main.log
        exit 1
    fi
    rx_bytes_after=$(cat "/sys/class/net/$mgmt_nic/statistics/rx_bytes")
    info "$(basename "$(pwd)") test completed for $VAGRANT_NAME"

    echo "=== Summary ==="
    $vagrant_cmd ssh "$VAGRANT_NAME" -- cat main.log | grep "^INFO" | sed 's/^INFO: //'
    $vagrant_cmd ssh "$VAGRANT_NAME" -- cat validate.log | grep "^INFO" | sed 's/^INFO: //'
    printf "%s secs - Duration time for %s in %s\n" "$(($(date +%s)-start))" "$(basename "$(pwd)")" "$VAGRANT_NAME"
    printf "%'.f MB downloaded - Network Usage for %s in %s\n"  "$(((rx_bytes_after-rx_bytes_before)/ratio))" "$(basename "$(pwd)")" "$VAGRANT_NAME"

    $vagrant_destroy_cmd > /dev/null
    popd > /dev/null
done
info "Integration tests completed - $VAGRANT_NAME"
int_rx_bytes_after=$(cat "/sys/class/net/$mgmt_nic/statistics/rx_bytes")
printf "%'.f MB total downloaded\n"  "$(((int_rx_bytes_after-int_rx_bytes_before)/ratio))"
