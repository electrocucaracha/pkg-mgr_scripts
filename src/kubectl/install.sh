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
if [[ ${PKG_DEBUG:-false} == "true" ]]; then
    set -o xtrace
fi

sudo_cmd=$(whoami | grep -q "root" || echo "sudo -H -E")
OS="$(uname | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')"

function install_pkgs {
    INSTALLER_CMD="$sudo_cmd "
    # shellcheck disable=SC1091
    source /etc/os-release || source /usr/lib/os-release
    case ${ID,,} in
    *suse*)
        INSTALLER_CMD+="zypper "
        if [[ ${PKG_DEBUG:-false} == "false" ]]; then
            INSTALLER_CMD+="-q "
        fi
        # shellcheck disable=SC2068
        $INSTALLER_CMD install -y --no-recommends $@
        ;;
    ubuntu | debian)
        $sudo_cmd apt update
        INSTALLER_CMD+="apt-get -y --force-yes "
        if [[ ${PKG_DEBUG:-false} == "false" ]]; then
            INSTALLER_CMD+="-q=3 "
        fi
        # shellcheck disable=SC2068
        $INSTALLER_CMD --no-install-recommends install $@
        ;;
    rhel | centos | fedora | rocky)
        $sudo_cmd sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* || :
        $sudo_cmd sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-* || :
        INSTALLER_CMD+="$(command -v dnf || command -v yum) -y"
        if [[ ${PKG_DEBUG:-false} == "false" ]]; then
            INSTALLER_CMD+=" --quiet --errorlevel=0"
        fi
        # shellcheck disable=SC2068
        $INSTALLER_CMD install $@
        ;;
    esac
    export INSTALLER_CMD
}

# _vercmp() - Function that compares two versions
function _vercmp {
    local v1=$1
    local op=$2
    local v2=$3
    local result

    # sort the two numbers with sort's "-V" argument.  Based on if v2
    # swapped places with v1, we can determine ordering.
    result=$(echo -e "$v1\n$v2" | sort -V | head -1)

    case $op in
    "==")
        [ "$v1" = "$v2" ]
        return
        ;;
    ">")
        [ "$v1" != "$v2" ] && [ "$result" = "$v2" ]
        return
        ;;
    "<")
        [ "$v1" != "$v2" ] && [ "$result" = "$v1" ]
        return
        ;;
    ">=")
        [ "$result" = "$v2" ]
        return
        ;;
    "<=")
        [ "$result" = "$v1" ]
        return
        ;;
    *)
        echo "unrecognised op: $op"
        exit 1
        ;;
    esac
}

function get_github_latest_release {
    version=""
    attempt_counter=0
    max_attempts=5

    until [ "$version" ]; do
        url_effective=$(curl -sL -o /dev/null -w '%{url_effective}' "https://github.com/$1/releases/latest")
        if [ "$url_effective" ]; then
            version="${url_effective##*/}"
            break
        elif [ ${attempt_counter} -eq ${max_attempts} ]; then
            echo "Max attempts reached"
            exit 1
        fi
        attempt_counter=$((attempt_counter + 1))
        sleep $((attempt_counter * 2))
    done
    echo "${version#v}"
}

function _install_finalize_namespace {
    local finalize_namespace_version=${PKG_FINALIZE_NAMESPACE_VERSION:-$(get_github_latest_release mattn/kubectl-finalize_namespace)}

    if ! kubectl finalize_namespace -V || [[ "$(kubectl finalize_namespace -V | awk '{ print $2}')" != "$finalize_namespace_version" ]]; then
        pushd "$(mktemp -d)" >/dev/null
        tarball="kubectl-finalize_namespace_v${finalize_namespace_version}_${OS}_${ARCH}.tar.gz"
        url="https://github.com/mattn/kubectl-finalize_namespace/releases/download/v${finalize_namespace_version}/$tarball"
        if [[ ${PKG_DEBUG:-false} == "true" ]]; then
            curl -fsSLO "$url"
            tar -vxzf "$tarball" --strip-components=1
        else
            curl -fsSLO "$url" 2>/dev/null
            tar -xzf "$tarball" --strip-components=1
        fi
        $sudo_cmd mv kubectl-finalize_namespace /usr/local/bin/
        popd >/dev/null
    fi
}

function main {
    cmds=()
    for cmd in git tar gzip; do
        if ! command -v $cmd >/dev/null; then
            cmds+=("$cmd")
        fi
    done
    if ! command -v curl >/dev/null; then
        cmds+=(curl ca-certificates)
    fi
    if [ ${#cmds[@]} != 0 ]; then
        # shellcheck disable=SC2068
        install_pkgs ${cmds[@]}
    fi
    if command -v update-ca-certificates >/dev/null; then
        $sudo_cmd update-ca-certificates
    fi

    local version=${PKG_KUBECTL_VERSION:-$(curl -L -s https://dl.k8s.io/release/stable.txt)}
    local krew_version=${PKG_KREW_VERSION:-$(get_github_latest_release kubernetes-sigs/krew)}
    krew_plugins_list=${PKG_KREW_PLUGINS_LIST:-tree,access-matrix,score,sniff,view-utilization}
    krew_index_list=${PKG_KREW_INDEX_LIST:-}

    if ! command -v kubectl || [[ "$(kubectl version --short --client | awk '{print $3}')" != "$version" ]]; then
        echo "INFO: Installing kubectl $version version..."

        pushd "$(mktemp -d)" >/dev/null
        url="https://dl.k8s.io/release/v${version#v}/bin/$OS/$ARCH"
        if [[ ${PKG_DEBUG:-false} == "true" ]]; then
            curl -LO "$url/kubectl" -LO "$url/kubectl-convert"
        else
            curl -LO "$url/kubectl" -LO "$url/kubectl-convert" 2>/dev/null
        fi
        mkdir -p ~/{.local,}/bin
        $sudo_cmd mkdir -p /snap/bin
        $sudo_cmd mkdir -p /usr/local/bin/
        for bin in kubectl kubectl-convert; do
            chmod +x "$bin"
            $sudo_cmd mv "$bin" "/usr/local/bin/$bin"
        done
        popd >/dev/null
        $sudo_cmd mkdir -p /etc/bash_completion.d
        kubectl completion bash | $sudo_cmd tee /etc/bash_completion.d/kubectl >/dev/null
    fi

    if ! kubectl krew version &>/dev/null || [[ "$(kubectl krew version | grep GitTag | awk '{ print $2}')" != v"$krew_version" ]]; then
        echo "INFO: Installing krew..."

        krew_assets="krew.{tar.gz,yaml}"
        tarball="krew.tar.gz"
        if _vercmp "$krew_version" '>' '0.4.1'; then
            krew_assets="krew{-${OS}_${ARCH}.tar.gz,.yaml}"
            tarball="krew-${OS}_${ARCH}.tar.gz"
        fi
        pushd "$(mktemp -d)" >/dev/null
        if [[ ${PKG_DEBUG:-false} == "true" ]]; then
            curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/download/v${krew_version}/$krew_assets"
            tar -vxzf "$tarball"
        else
            curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/download/v${krew_version}/$krew_assets" 2>/dev/null
            tar -xzf "$tarball"
        fi
        $sudo_cmd chown "${_REMOTE_USER-$USER}:" .*
        $sudo_cmd runuser "${_REMOTE_USER-$USER}" -c "./krew-${OS}_$ARCH install --manifest=krew.yaml --archive=$tarball"
        # shellcheck disable=SC2016
        ([ -f "$HOME/.bashrc" ] && ! grep -q KREW_ROOT "$HOME/.bashrc") && echo '[ -d ${KREW_ROOT:-$HOME/.krew}/bin ] && export PATH=$PATH:${KREW_ROOT:-$HOME/.krew}/bin' | tee --append "$HOME/.bashrc" >/dev/null
        # shellcheck disable=SC2016
        ([ -f "$HOME/.zshrc" ] && ! grep -q KREW_ROOT "$HOME/.zshrc") && echo '[ -d ${KREW_ROOT:-$HOME/.krew}/bin ] && export PATH=$PATH:${KREW_ROOT:-$HOME/.krew}/bin' | tee --append "$HOME/.zshrc" >/dev/null
        export PATH="$PATH:${KREW_ROOT:-${_REMOTE_USER_HOME-$HOME}/.krew}/bin"
        popd >/dev/null
    fi
    for index in ${krew_index_list//,/ }; do
        kubectl krew index add "${index%=*}" "${index#*=}"
    done
    kubectl krew update
    for plugin in ${krew_plugins_list//,/ }; do
        kubectl krew install "$plugin" || true
    done
    if [[ ${PKG_INSTALL_FINALIZE_NAMESPACE:-false} == "true" ]]; then
        _install_finalize_namespace
    fi
}

main
