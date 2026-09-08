#!/bin/bash
# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2019
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

# @file Go validator
# @brief Validates a Go programming language installation.
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

# @description Resolves the tool version expected by this validator.
# @stdout Expected tool version.
# @exitcode 1 When the version cannot be resolved after retries.
function get_version {
    local version=${PKG_GOLANG_VERSION-}

    attempt_counter=0
    max_attempts=5
    until [ "$version" ]; do
        stable_version="$(curl -sL https://golang.org/VERSION?m=text | head -n 1)"
        if [ "$stable_version" ]; then
            version="${stable_version#go}"
            break
        elif [ ${attempt_counter} -eq ${max_attempts} ]; then
            echo "Max attempts reached"
            exit 1
        fi
        attempt_counter=$((attempt_counter + 1))
        sleep $((attempt_counter * 2))
    done
    echo "go$version"
}

info "Validating go installation..."
if ! command -v go; then
    error "Go command line wasn't installed"
fi

info "Validating go execution..."
go env

info "Checking go version"
installed_version="$(go version | awk '{print $3}')"
expected_version="$(get_version)"
# Allow prefix match to handle minor version pinning (e.g. "go1.18" matches "go1.18.10")
if [[ $installed_version != "$expected_version"* ]]; then
    error "Go version installed ($installed_version) is different from expected ($expected_version)"
fi
