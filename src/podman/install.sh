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

OS="$(uname | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')"

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

function _install_runc {
    local version=${PKG_RUNC_VERSION:-$(get_github_latest_release opencontainers/runc)}

    if ! command -v runc || [[ "$(runc --version | awk 'NR==1{ print $NF }')" != "$version" ]]; then
        echo "INFO: Installing runc $version version..."
        url="https://github.com/opencontainers/runc/releases/download/v${version}/runc.$ARCH"
        if [[ ${PKG_DEBUG:-false} == "true" ]]; then
            sudo curl -o /usr/bin/runc -sL "$url"
        else
            sudo curl -o /usr/bin/runc -sL "$url" 2>/dev/null
        fi
        sudo chmod +x /usr/bin/runc
    fi
}

function _install_crun {
    local version=${PKG_CRUN_VERSION:-$(get_github_latest_release containers/crun)}

    if ! command -v crun || [[ "$(crun --version | awk 'NR==1{ print $NF }')" != "$version" ]]; then
        echo "INFO: Installing crun $version version..."
        binary="crun-${version}-$OS-$ARCH"
        if _vercmp "${version}" '<' "0.15"; then
            binary="crun-${version}-static-$(uname -m)"
        fi
        url="https://github.com/containers/crun/releases/download/${version}/$binary"
        if [[ ${PKG_DEBUG:-false} == "true" ]]; then
            sudo curl -o /usr/bin/crun -sL "$url"
        else
            sudo curl -o /usr/bin/crun -sL "$url" 2>/dev/null
        fi
        sudo chmod +x /usr/bin/crun
    fi
}

function _install_youki {
    local version=${PKG_YOUKI_VERSION:-$(get_github_latest_release containers/youki)}

    if ! command -v youki || [[ "$(youki --version | awk 'NR==1{ print $NF }')" != "$version" ]]; then
        if _vercmp "${version}" '==' "0.0.3"; then
            path_checker=true
            case ${ID,,} in
            ubuntu)
                if [ "${VERSION_ID}" == "20.04" ]; then
                    path_checker=false
                fi
                ;;
            *suse*)
                if [[ ${ID,,} == *"tumbleweed"* ]]; then
                    path_checker=false
                fi
                ;;
            esac
            if [ "$path_checker" == "false" ]; then
                echo "WARN: youki 0.0.3 has some issues in Ubuntu 20.04(https://github.com/containers/youki/issues/845)"
                return 1
            fi
        fi
        case ${ID,,} in
        ubuntu)
            libc_version="$(apt-cache policy libc6 | grep Installed | awk 'NR==1{print $NF}')"
            ;;
        centos)
            libc_version="$($(command -v dnf || command -v yum) info glibc | grep Version | awk 'NR==1{print $NF}')"
            ;;
        *suse*)
            libc_version="$(zypper info glibc | grep Version | awk 'NR==1{print $NF}')"
            ;;
        esac
        if _vercmp "${libc_version%-*}" '<' "2.29"; then
            echo "WARN: youki 0.0.3 requires GLIBC_2.29 or greater"
            return 1
        fi
        echo "INFO: Installing youki $version version..."
        pushd "$(mktemp -d)" >/dev/null
        tarball="youki_${version//./_}_$OS.tar.gz"
        if _vercmp "${version}" '<=' "0.0.1"; then
            tarball="youki_v${version//./_}_$OS.tar.gz"
        fi
        url="https://github.com/containers/youki/releases/download/v${version}/${tarball}"
        if [[ ${PKG_DEBUG:-false} == "true" ]]; then
            curl -fsSLO "$url"
            tar -vxzf "$tarball" --strip-components=2
        else
            curl -fsSLO "$url" 2>/dev/null
            tar -xzf "$tarball" --strip-components=2
        fi
        sudo mv youki /usr/bin/youki
        sudo chown root: /usr/bin/youki
        sudo mkdir -p /etc/bash_completion.d
        youki completion --shell bash | sudo tee /etc/bash_completion.d/youki >/dev/null
        popd >/dev/null
    fi
}

function main {
    runtimes_list=${PKG_PODMAN_RUNTIMES_LIST:-runc,crun,youki}

    INSTALLER_CMD="sudo -H -E "
    # shellcheck disable=SC1091
    source /etc/os-release || source /usr/lib/os-release
    case ${ID,,} in
    *suse*)
        INSTALLER_CMD+="zypper "
        if [[ ${PKG_DEBUG:-false} == "false" ]]; then
            INSTALLER_CMD+="-q "
        fi
        INSTALLER_CMD+="install -y --no-recommends"
        sudo mkdir -p /etc/cni/net.d/
        sudo tee /etc/cni/net.d/87-podman-bridge.conflist <<EOF
{
  "cniVersion": "0.4.0",
  "name": "podman",
  "plugins": [
    {
      "type": "bridge",
      "bridge": "cni-podman0",
      "isGateway": true,
      "ipMasq": true,
      "hairpinMode": true,
      "ipam": {
        "type": "host-local",
        "routes": [{ "dst": "0.0.0.0/0" }],
        "ranges": [
          [
            {
              "subnet": "10.88.0.0/16",
              "gateway": "10.88.0.1"
            }
          ]
        ]
      }
    },
    {
      "type": "portmap",
      "capabilities": {
        "portMappings": true
      }
    },
    {
      "type": "firewall"
    },
    {
      "type": "tuning"
    }
  ]
}
EOF
        ;;
    ubuntu | debian)
        if _vercmp "${VERSION_ID}" '<=' "16.04"; then
            echo "WARN: Podman is not supported in Ubuntu $VERSION_ID"
            return
        fi
        INSTALLER_CMD+="apt-get -y "
        if [[ ${PKG_DEBUG:-false} == "false" ]]; then
            INSTALLER_CMD+="-q=3 "
        fi
        INSTALLER_CMD+=" install"
        echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
        curl -sL "https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/Release.key" | sudo apt-key add -
        sudo apt-get update || :
        $INSTALLER_CMD --reinstall ca-certificates
        sudo apt-get update
        ;;
    rhel | centos | fedora)
        PKG_MANAGER=$(command -v dnf || command -v yum)
        INSTALLER_CMD="sudo -H -E ${PKG_MANAGER} -y"
        if [[ ${PKG_DEBUG:-false} == "false" ]]; then
            INSTALLER_CMD+=" --quiet --errorlevel=0"
        fi
        INSTALLER_CMD+=" install"
        $INSTALLER_CMD libseccomp-devel
        echo 62460 | sudo tee /proc/sys/user/max_user_namespaces
        ;;
    esac
    echo "INFO: Installing podman..."
    $INSTALLER_CMD podman

    # NOTE: metacopy=on is available since 4.19 and was backported to RHEL 4.18 kernel
    if _vercmp "$(uname -r | awk -F '-' '{print $1}')" '<' "4.19"; then
        sudo sed -i 's/^mountopt =.*/mountopt = "nodev"/' /etc/containers/storage.conf
    fi

    if [ "${ID,,}" == "centos" ] && [ "${VERSION_ID}" == "7" ]; then
        echo "WARN: Podman service is not supported in CentOS 7"
    else
        echo "INFO: Starting podman service..."
        sudo systemctl enable podman.socket
        sudo systemctl start podman.socket --now
        if systemctl --user daemon-reload >/dev/null 2>&1; then
            echo "INFO: Enabling rootless podman service..."
            systemctl --user enable podman.socket
            systemctl --user start podman.socket
            sudo loginctl enable-linger "$USER"
        fi
    fi

    sudo tee /etc/containers/containers.conf <<EOF
[containers]
[network]
[engine]
runtime = "crun"
[engine.runtimes]
EOF

    for runtime in ${runtimes_list//,/ }; do
        if "_install_$runtime"; then
            sudo tee --append /etc/containers/containers.conf <<EOF
$runtime = [
        "$(command -v "$runtime")",
]
EOF
        fi
    done
}

main
