#!/bin/bash
# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2019
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

# @file Go installer
# @brief Installs the Go programming language.
# @description This reference describes the script entry point and its implementation helpers. Configure optional behavior with PKG_ environment variables documented in the component README.
set -o nounset
set -o errexit
set -o pipefail

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
if [[ ${PKG_DEBUG:-false} == "true" ]]; then
    set -o xtrace
fi

# @description Resolves the latest Go release version from the official Go distribution endpoint.
# @stdout Latest Go version without the go prefix.
# @exitcode 1 When the version cannot be resolved after retries.
function get_go_latest_version {
    version=""
    attempt_counter=0
    max_attempts=5

    until [ "$version" ]; do
        stable_version="$(curl -sL https://golang.org/VERSION?m=text | head -n 1)"
        if [ "$stable_version" ]; then
            echo "${stable_version#go}"
            break
        elif [ ${attempt_counter} -eq ${max_attempts} ]; then
            echo "Max attempts reached"
            exit 1
        fi
        attempt_counter=$((attempt_counter + 1))
        sleep $((attempt_counter * 2))
    done
}

# @description Runs this script's installation or validation workflow.
# @noargs
# @exitcode 0 When the workflow completes successfully.
# @exitcode 1 When a required command fails.
function main {
    local version=${PKG_GOLANG_VERSION:-$(get_go_latest_version)}

    OS="$(uname | tr '[:upper:]' '[:lower:]')"
    ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')"
    tarball=go$version.$OS-$ARCH.tar.gz

    if command -v go && [[ "$(go version | awk '{print $3}')" == "go$version" ]]; then
        echo "INFO: Go $version version already installed"
        return
    fi

    # NOTE: Ensure go-lang was not installed by the OS package manager
    # shellcheck disable=SC1091
    source /etc/os-release || source /usr/lib/os-release
    case ${ID,,} in
    *suse*)
        if zypper search --match-exact --installed-only go &>/dev/null; then
            sudo zypper -q remove -y -u go
        fi
        ;;
    ubuntu | debian)
        if dpkg -l golang &>/dev/null; then
            sudo apt autoremove -y -qq golang
        fi
        ;;
    rhel | centos | fedora | rocky)
        if rpm -q golang &>/dev/null; then
            # shellcheck disable=SC2046
            sudo $(command -v dnf || command -v yum) -y --quiet --errorlevel=0 autoremove golang
        fi
        ;;
    esac

    echo "INFO: Installing go $version version..."
    pushd "$(mktemp -d)" >/dev/null
    echo insecure >>~/.curlrc
    trap 'sed -i "/^insecure\$/d" ~/.curlrc' EXIT
    if [[ ${PKG_DEBUG:-false} == "true" ]]; then
        curl -L -o "$tarball" "https://go.dev/dl/$tarball"
        sudo tar -C /usr/local -vxzf "$tarball"
    else
        curl -sL -o "$tarball" "https://go.dev/dl/$tarball"
        sudo tar -C /usr/local -xzf "$tarball"
    fi
    popd >/dev/null

    sudo mkdir -p /etc/profile.d/
    # shellcheck disable=SC2016
    echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/path.sh >/dev/null
    sudo ln -sf /usr/local/go/bin/go /usr/local/bin/go
    sudo ln -sf /usr/local/go/bin/gofmt /usr/local/bin/gofmt
}

main
