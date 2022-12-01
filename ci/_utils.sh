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
if [[ ${DEBUG:-false} == "true" ]]; then
    set -o xtrace
fi

source ./ci/_common.sh

function exit_trap {
    $vagrant_cmd ssh "$VAGRANT_NAME" -- cat install.log
    $vagrant_cmd ssh "$VAGRANT_NAME" -- cat validate.log
}

function run_test {
    # Run in a subshell to avoid job control messages
    (
        eval _run_test &
        child=$!
        # Avoid default notification in non-interactive shell for SIGTERM
        trap -- "" SIGTERM
        (
            sleep "$TIMEOUT"
            if kill $child 2>/dev/null; then
                warn "Timeout was reached after $TIMEOUT seconds ($(basename "$(pwd)"))"
            fi
        ) &
        wait $child
    )
}

function print_running {
    while true; do
        info "Running $(basename "$(pwd)") test"
        sleep 60
    done
}

function _run_test {
    if [ -f os-blacklist.conf ] && grep "$VAGRANT_NAME" os-blacklist.conf >/dev/null; then
        info "Skipping $(basename "$(pwd)") test for $VAGRANT_NAME"
        return
    fi
    $vagrant_halt_cmd >/dev/null
    $vagrant_destroy_cmd >/dev/null
    if [ -f "/sys/class/net/$mgmt_nic/statistics/rx_bytes" ]; then
        rx_bytes_before=$(cat "/sys/class/net/$mgmt_nic/statistics/rx_bytes")
    fi

    info "Starting $(basename "$(pwd)") test for $VAGRANT_NAME"
    start=$(date +%s)
    print_running 2>&1 &
    pid=$!
    $vagrant_up_cmd >"/tmp/check_$(basename "$(pwd)")_$VAGRANT_NAME.log"

    # Verify validation errors
    if $vagrant_cmd ssh "$VAGRANT_NAME" -- cat validate.log | grep "ERROR"; then
        cat "/tmp/check_$(basename "$(pwd)")_$VAGRANT_NAME.log"
        error "Found an error during the validation of $(basename "$(pwd)") in $VAGRANT_NAME"
    fi
    if [ -f "/sys/class/net/$mgmt_nic/statistics/rx_bytes" ]; then
        rx_bytes_after=$(cat "/sys/class/net/$mgmt_nic/statistics/rx_bytes")
    fi
    kill "$pid" 2>/dev/null
    info "$(basename "$(pwd)") test completed for $VAGRANT_NAME"

    echo "=== Summary ==="
    $vagrant_cmd ssh "$VAGRANT_NAME" -- cat install.log | grep "^INFO" | sed 's/^INFO: //'
    $vagrant_cmd ssh "$VAGRANT_NAME" -- cat validate.log | grep "^INFO" | sed 's/^INFO: //'

    duration=$(($(date +%s) - start))
    printf "%s secs - Duration time for %s in %s\n" "$duration" "$(basename "$(pwd)")" "$VAGRANT_NAME"
    echo "$(basename "$(pwd)") ($VAGRANT_NAME) completed in $duration secs" >>"${GITHUB_STEP_SUMMARY:-/tmp/github_step_summary.log}"
    if [ -n "${rx_bytes_before-}" ] && [ -n "${rx_bytes_after-}" ]; then
        printf "%'.f MB downloaded - Network Usage for %s in %s\n" "$(((rx_bytes_after - rx_bytes_before) / ratio))" "$(basename "$(pwd)")" "$VAGRANT_NAME"
    fi

    $vagrant_halt_cmd >/dev/null
    $vagrant_destroy_cmd >/dev/null
}
