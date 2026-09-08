#!/bin/bash
# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2020
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

# @file NFS validator
# @brief Validates Network File System utilities.
# @description This reference describes the script entry point and its implementation helpers. Configure optional behavior with PKG_ environment variables documented in the component README.
set -o nounset
set -o errexit
set -o pipefail

# @description Writes an informational message.
# @arg $1 string Message to write.
# @stdout Message prefixed with INFO.
function info {
    _print_msg "INFO" "$1"
}

# @description Writes an error message and stops execution.
# @arg $1 string Message to write.
# @stdout Message prefixed with ERROR.
# @exitcode 1 Always.
function error {
    _print_msg "ERROR" "$1"
    exit 1
}

# @description Formats and writes a message with its severity level.
# @arg $1 string Message severity.
# @arg $2 string Message content.
# @stdout Formatted severity and message.
function _print_msg {
    echo "$1: $2"
}

info "Validating NFS service..."
if ! systemctl is-enabled --quiet nfs-server; then
    error "NFS server is not enabled"
fi
if ! systemctl is-active --quiet nfs-server; then
    error "NFS server is not active"
fi

info "Validating RPC-stat service..."
if ! systemctl is-enabled --quiet rpc-statd; then
    error "RPC-stat is not enabled"
fi
if ! systemctl is-active --quiet rpc-statd; then
    error "RPC-stat server is not active"
fi
