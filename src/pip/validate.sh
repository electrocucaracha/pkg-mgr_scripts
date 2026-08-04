#!/bin/bash
# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2020
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

set -o nounset
set -o errexit
set -o pipefail

# Some devcontainer test images execute feature installers as root without sudo.
# Provide a local fallback so the same script works in both contexts.
if ! command -v sudo >/dev/null && [ "$(id -u)" -eq 0 ]; then
    sudo() {
        while [[ "$1" == -* ]]; do
            shift
        done
        "$@"
    }
fi

function info {
    _print_msg "INFO" "$1"
}

function error {
    _print_msg "ERROR" "$1"
    exit 1
}

function _print_msg {
    echo "$1: $2"
}

info "Validating pip installation..."
PYTHON_CMD=$(command -v python || command -v python3 || :)
if [ -z "$PYTHON_CMD" ]; then
    error "python command line wasn't installed"
fi
info "Showing pip version"
sudo -E "$PYTHON_CMD" -m pip -V

if [ ! -f "$HOME/.local/bin/tox" ]; then
    info "Validating pip execution"
    pip install --no-warn-script-location --no-cache-dir tox
    "$HOME/.local/bin/tox" --version
fi
