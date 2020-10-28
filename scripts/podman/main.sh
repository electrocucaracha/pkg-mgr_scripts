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
if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
    set -o xtrace
fi

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
            die $LINENO "unrecognised op: $op"
            ;;
    esac
}

function get_cpu_arch {
    case "$(uname -m)" in
        x86_64)
            echo "amd64"
        ;;
        armv8*|aarch64*)
            echo "arm64"
        ;;
        armv*)
            echo "armv7"
        ;;
    esac
}

function get_github_latest_release {
    version=""
    attempt_counter=0
    max_attempts=5

    until [ "$version" ]; do
        release="$(curl -s "https://api.github.com/repos/$1/releases/latest")"
        if [ "$release" ]; then
            version="$(echo "$release" | grep -Po '"name":.*?[^\\]",' | awk -F  "\"" 'NR==1{print $4}')"
            break
        elif [ ${attempt_counter} -eq ${max_attempts} ];then
            echo "Max attempts reached"
            exit 1
        fi
        attempt_counter=$((attempt_counter+1))
        sleep 2
    done

    echo "${version#*v}"
}

function main {
    local crun_version=${PKG_CRUN_VERSION:-$(get_github_latest_release containers/crun)}

    INSTALLER_CMD="sudo -H -E "
    # shellcheck disable=SC1091
    source /etc/os-release || source /usr/lib/os-release
    case ${ID,,} in
        *suse*)
            INSTALLER_CMD+="zypper "
            if [[ "${PKG_DEBUG:-false}" == "false" ]]; then
                INSTALLER_CMD+="-q "
            fi
            INSTALLER_CMD+="install -y --no-recommends"
        ;;
        ubuntu|debian)
            if _vercmp "${VERSION_ID}" '<=' "16.04"; then
                echo "WARN: Podman is not supported in Ubuntu $VERSION_ID"
                return
            fi
            INSTALLER_CMD+="apt-get -y "
            if [[ "${PKG_DEBUG:-false}" == "false" ]]; then
                INSTALLER_CMD+="-q=3 "
            fi
            INSTALLER_CMD+=" install"
            echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
            curl -sL "https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/Release.key" | sudo apt-key add -
            sudo apt-get update
        ;;
        rhel|centos|fedora)
            PKG_MANAGER=$(command -v dnf || command -v yum)
            INSTALLER_CMD="sudo -H -E ${PKG_MANAGER} -y"
            if [[ "${PKG_DEBUG:-false}" == "false" ]]; then
                INSTALLER_CMD+=" --quiet --errorlevel=0"
            fi
            INSTALLER_CMD+=" install"
            if [ "${ID,,}" == "centos" ]; then
                if [ "${VERSION_ID}" == "8" ]; then
                    eval "sudo $PKG_MANAGER -y module disable container-tools"
                    $INSTALLER_CMD 'dnf-command(copr)'
                    eval "sudo $PKG_MANAGER -y copr enable rhcontainerbot/container-selinux"
                fi
                sudo curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable.repo "https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/CentOS_${VERSION_ID}/devel:kubic:libcontainers:stable.repo"
            fi
        ;;
    esac
    $INSTALLER_CMD podman
    if [ "${ID,,}" == "centos" ] && [ "${VERSION_ID}" == "7" ]; then
        sudo sed -i 's/mountopt = .*/mountopt = ""/' /etc/containers/storage.conf
        echo "WARN: Podman service is not supported in CentOS 7"
    else
        sudo systemctl enable podman.socket
        sudo systemctl start podman.socket
        systemctl --user enable podman.socket
        systemctl --user start podman.socket
        sudo loginctl enable-linger "$USER"
    fi

    if _vercmp "${crun_version}" '<' "0.15"; then
        crun_binary="crun-${crun_version}-static-$(uname -m)"
    else
        crun_binary="crun-${crun_version}-$(uname | tr '[:upper:]' '[:lower:]')-$(get_cpu_arch)"
    fi
    crun_url="https://github.com/containers/crun/releases/download/${crun_version}/$crun_binary"
    if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
        sudo curl -o /usr/bin/crun -sL "$crun_url"
    else
        sudo curl -o /usr/bin/crun -sL "$crun_url" 2>/dev/null
    fi
    sudo chmod +x /usr/bin/crun
    sudo tee /etc/containers/containers.conf << EOF
[containers]
[network]
[engine]
runtime = "crun"
[engine.runtimes]
runc = [
        "$(command -v runc)",
]
crun = [
        "/usr/bin/crun",
]
EOF
}

main
