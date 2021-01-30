#!/bin/bash
# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2021
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

set -o nounset
set -o errexit
set -o pipefail

source _common.sh

function info {
    _print_msg "INFO" "$1"
}

function warn {
    _print_msg "WARN" "$1"
}

function _print_msg {
    echo "$(date +%H:%M:%S) - $1: $2"
}

function exit_trap {
    $vagrant_cmd ssh "$VAGRANT_NAME" -- cat main.log
    $vagrant_cmd ssh "$VAGRANT_NAME" -- cat validate.log
}

function run_test {
    if [ -f os-blacklist.conf ] && grep "$VAGRANT_NAME" os-blacklist.conf > /dev/null; then
        info "Skipping $(basename "$(pwd)") test for $VAGRANT_NAME"
        return
    fi
    $vagrant_destroy_cmd > /dev/null
    rx_bytes_before=$(cat "/sys/class/net/$mgmt_nic/statistics/rx_bytes")

    info "Starting $(basename "$(pwd)") test for $VAGRANT_NAME"
    start=$(date +%s)
    $vagrant_up_cmd > "/tmp/check_$(basename "$(pwd)")_$VAGRANT_NAME.log"

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
}
