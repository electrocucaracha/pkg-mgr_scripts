#!/bin/bash
# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2021
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

# @file Rust installer
# @brief Installs the Rust programming language.
# @description This reference describes the script entry point and its implementation helpers. Configure optional behavior with PKG_ environment variables documented in the component README.
set -o nounset
set -o errexit
set -o pipefail
if [[ ${PKG_DEBUG:-false} == "true" ]]; then
    set -o xtrace
fi

# Some devcontainer test images execute feature installers as root without sudo.
# Provide a local fallback so the same script works in both contexts.
if ! command -v sudo >/dev/null && [ "$(id -u)" -eq 0 ]; then
    # @internal
    sudo() {
        while [[ ${1:-} == -* ]]; do
            shift
        done
        "$@"
    }
fi

# @description Runs this script's installation or validation workflow.
# @noargs
# @exitcode 0 When the workflow completes successfully.
# @exitcode 1 When a required command fails.
function main {
    if ! command -v rustup >/dev/null; then
        echo "INFO: Installing rustc..."
        curl https://sh.rustup.rs -sSf | sh -s -- -y
    fi

    # Ensure default toolchain binaries exist even when rustup is preinstalled.
    rustup_cmd="$(command -v rustup || true)"
    [ -z "$rustup_cmd" ] && rustup_cmd="$HOME/.cargo/bin/rustup"
    if [ -x "$rustup_cmd" ] && { ! [ -x "$HOME/.cargo/bin/rustc" ] || ! [ -x "$HOME/.cargo/bin/cargo" ]; }; then
        "$rustup_cmd" toolchain install stable --profile minimal
        "$rustup_cmd" default stable
    fi

    for cmd in rustup rustc cargo rustfmt; do
        if [ -x "$HOME/.cargo/bin/$cmd" ]; then
            sudo ln -sf "$HOME/.cargo/bin/$cmd" "/usr/local/bin/$cmd"
        fi
    done
}

main
