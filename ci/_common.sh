#!/bin/bash
# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2021
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

if [[ ${DEBUG:-false} == "true" ]]; then
    set -o xtrace
fi

source ./ci/pinned_versions.env
source ./ci/blacklist_versions

mgmt_nic="$(ip route get 1.1.1.1 | awk 'NR==1 { print $5 }')"
ratio=$((1024 * 1024)) # MB
export MEMORY=${MEMORY:-3072}
export TIMEOUT=${TIMEOUT:-1800}
export VAGRANT_NAME=${VAGRANT_NAME:-ubuntu_xenial}
export mgmt_nic ratio

vagrant_cmd="$(command -v vagrant)"
vagrant_up_cmd="$vagrant_cmd up --no-destroy-on-error $VAGRANT_NAME"
vagrant_destroy_cmd="$vagrant_cmd destroy -f $VAGRANT_NAME"
vagrant_halt_cmd="$vagrant_cmd halt $VAGRANT_NAME"
export vagrant_cmd vagrant_up_cmd vagrant_destroy_cmd vagrant_halt_cmd

function info {
    _print_msg "INFO" "$1"
}

function warn {
    _print_msg "WARN" "$1"
    echo "::warning::$1"
}

function error {
    _print_msg "ERROR" "$1"
    echo "::error::$1"
    exit 1
}

function _print_msg {
    echo "$(date +%H:%M:%S) - $1: $2"
}
