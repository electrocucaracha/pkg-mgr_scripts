#!/bin/bash
# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2019
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

# @file Vagrant validator
# @brief Validates a Vagrant installation.
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
    local version=${PKG_VAGRANT_VERSION-}

    attempt_counter=0
    max_attempts=5
    until [ "$version" ]; do
        tags="$(curl -s https://api.github.com/repos/hashicorp/vagrant/tags)"
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

info "Validating vagrant installation..."
if ! command -v vagrant; then
    error "Vagrant command line wasn't installed"
fi

pushd "$(mktemp -d)" >/dev/null

info "Checking vagrant version"
if [ "$(vagrant --version | awk '{ print $2}')" != "$(get_version)" ]; then
    error "Vagrant version installed is different that expected"
fi

info "Validating Vagrant operation"
vagrant init centos/7
if ! [ -f Vagrantfile ]; then
    error "Vagrantfile wasn't created"
fi
if ! vagrant box add generic/alpine316 --provider virtualbox; then
    error "Vagrant pull box failed"
fi

popd >/dev/null

info "Validate autocomplete functions"
if declare -F | grep -q "_vagrant"; then
    error "Vagrant autocomplete install failed"
fi
