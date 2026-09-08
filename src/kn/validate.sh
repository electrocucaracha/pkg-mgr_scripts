#!/bin/bash
# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2021
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

# @file Kn validator
# @brief Validates a Knative command-line client installation.
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

# @description Writes a warning message.
# @arg $1 string Message to write.
# @stdout Message prefixed with WARN.
function warn {
    _print_msg "WARN" "$1"
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
    local version=${PKG_KN_VERSION-}

    attempt_counter=0
    max_attempts=5
    until [ "$version" ]; do
        tags="$(curl -s https://api.github.com/repos/knative/client/tags)"
        if [ "$tags" ]; then
            version="$(echo "$tags" | grep -Po '"name":.*?[^\\]",' | awk -F '"' 'NR==1{print $4}')"
            break
        elif [ ${attempt_counter} -eq ${max_attempts} ]; then
            echo "Max attempts reached"
            exit 1
        fi
        attempt_counter=$((attempt_counter + 1))
        sleep $((attempt_counter * 2))
    done
    echo "${version#*v}"
}

info "Validating kn installation..."
if ! command -v kn; then
    error "Knative command line wasn't installed"
fi

info "Validating autocomplete functions"
# shellcheck disable=SC1091
[ -f /etc/bash_completion.d/kn ] && source /etc/bash_completion.d/kn
if ! declare -F | grep -q "_kn"; then
    error "kn autocomplete install failed"
fi

info "Checking kn version"
if [ "$(kn version | awk 'NR==1{print $2}')" != "v$(get_version)" ]; then
    warn "Knative client version installed is different that expected"
fi
