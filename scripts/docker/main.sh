#!/bin/bash
# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2019
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

function get_github_latest_release {
    version=""
    attempt_counter=0
    max_attempts=5

    until [ "$version" ]; do
        url_effective=$(curl -sL -o /dev/null -w '%{url_effective}' "https://github.com/$1/releases/latest")
        if [ "$url_effective" ]; then
            version="${url_effective##*/}"
            break
        elif [ ${attempt_counter} -eq ${max_attempts} ];then
            echo "Max attempts reached"
            exit 1
        fi
        attempt_counter=$((attempt_counter+1))
        sleep 2
    done
    echo "${version#v}"
}

function main {
    local version=${PKG_REGCLIENT_VERSION:-$(get_github_latest_release regclient/regclient)}

    # shellcheck disable=SC1091
    source /etc/os-release || source /usr/lib/os-release
    if ! command -v docker; then
        echo "Installing docker service..."

        INSTALLER_CMD="sudo -H -E "
        case ${ID,,} in
            *suse*)
                INSTALLER_CMD+="zypper"
                if [[ "${PKG_DEBUG:-false}" == "false" ]]; then
                    INSTALLER_CMD+=" -q"
                fi
                $INSTALLER_CMD --gpg-auto-import-keys refresh
                $INSTALLER_CMD install -y --no-recommends docker
                for mod in ip_tables iptable_mangle iptable_nat iptable_filter; do
                    sudo modprobe "$mod"
                done
            ;;
            rhel|centos|fedora)
                INSTALLER_CMD+="$(command -v dnf || command -v yum) -y install"
                if [[ "${PKG_DEBUG:-false}" == "false" ]]; then
                    INSTALLER_CMD+=" --quiet --errorlevel=0"
                fi
                if [[ "$VERSION_ID" == "7" ]]; then
                    echo "user.max_user_namespaces = 28633" | sudo tee /etc/sysctl.d/51-rootless.conf
                    sudo sysctl --system
                fi
                $INSTALLER_CMD https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm
                curl -fsSL https://get.docker.com/ | sh
                sudo sed -i "s/FirewallBackend=.*/FirewallBackend=iptables/g" /etc/firewalld/firewalld.conf
                sudo systemctl restart firewalld
            ;;
            ubuntu|debian)
                INSTALLER_CMD+="apt-get -y "
                if [[ "${PKG_DEBUG:-false}" == "false" ]]; then
                    INSTALLER_CMD+="-q=3 "
                fi
                $INSTALLER_CMD --no-install-recommends install uidmap
                curl -fsSL https://get.docker.com/ | sh
            ;;
        esac
    fi
    if sudo systemctl list-unit-files | grep "docker.service.*masked"; then
        sudo systemctl unmask docker
    fi
    sudo systemctl enable docker
    sudo systemctl start docker

    sudo mkdir -p /etc/systemd/system/docker.service.d
    mkdir -p "$HOME/.docker/"
    sudo mkdir -p /root/.docker/
    if ! getent group docker | grep -q "$USER"; then
        sudo usermod -aG docker "$USER"
    fi
    if [ -n "${SOCKS_PROXY:-}" ]; then
        socks_tmp="${SOCKS_PROXY#*//}"
        # Install Chameleon Socks dependency
        if ! command -v wget; then
            curl -fsSL https://raw.githubusercontent.com/electrocucaracha/pkg-mgr_scripts/master/install.sh | PKG=wget bash
        fi
        curl -sSL https://raw.githubusercontent.com/crops/chameleonsocks/master/chameleonsocks.sh | sudo PROXY="${socks_tmp%:*}" PORT="${socks_tmp#*:}" bash -s -- --install
    else
        if [ -n "${HTTP_PROXY:-}" ]; then
            echo "[Service]" | sudo tee /etc/systemd/system/docker.service.d/http-proxy.conf
            echo "Environment=\"HTTP_PROXY=$HTTP_PROXY\"" | sudo tee --append /etc/systemd/system/docker.service.d/http-proxy.conf
        fi
        if [ -n "${HTTPS_PROXY:-}" ]; then
            echo "[Service]" | sudo tee /etc/systemd/system/docker.service.d/https-proxy.conf
            echo "Environment=\"HTTPS_PROXY=$HTTPS_PROXY\"" | sudo tee --append /etc/systemd/system/docker.service.d/https-proxy.conf
        fi
        if [ -n "${NO_PROXY:-}" ]; then
            echo "[Service]" | sudo tee /etc/systemd/system/docker.service.d/no-proxy.conf
            echo "Environment=\"NO_PROXY=$NO_PROXY\"" | sudo tee --append /etc/systemd/system/docker.service.d/no-proxy.conf
        fi
    fi
    config="{ \"experimental\": \"enabled\","
    if [ -n "${HTTP_PROXY:-}" ] || [ -n "${HTTPS_PROXY:-}" ] || [ -n "${NO_PROXY:-}" ]; then
        config="\"proxies\": { \"default\": { "
        if [ -n "${HTTP_PROXY:-}" ]; then
            config+="\"httpProxy\": \"$HTTP_PROXY\","
        fi
        if [ -n "${HTTPS_PROXY:-}" ]; then
            config+="\"httpsProxy\": \"$HTTPS_PROXY\","
        fi
        if [ -n "${NO_PROXY:-}" ]; then
            config+="\"noProxy\": \"$NO_PROXY\","
        fi
        config="${config::-1} } },"
    fi
    echo "${config::-1} }" | tee "$HOME/.docker/config.json"
    sudo cp "$HOME/.docker/config.json" /root/.docker/config.json
    sudo mkdir -p /etc/docker
    insecure_registries="\"0.0.0.0/0\""
    for ip in $(ip addr | awk "/$(ip route | grep "^default" | head -n1 | awk '{ print $5 }')\$/ { sub(/\/[0-9]*/, \"\","' $2); print $2}'); do
        insecure_registries+=", \"$ip\""
    done
    if [ -n "${PKG_DOCKER_INSECURE_REGISTRIES:-}" ]; then
        insecure_registries+=", \"${PKG_DOCKER_INSECURE_REGISTRIES}\""
    fi
    default_address_pools='{"base":"172.80.0.0/16","size":24},{"base":"172.90.0.0/16","size":24}'
    if [ -n "${PKG_DOCKER_DEFAULT_ADDRESS_POOLS:-}" ]; then
        default_address_pools="$PKG_DOCKER_DEFAULT_ADDRESS_POOLS"
    fi
    sudo tee /etc/docker/daemon.json << EOF
{
  "default-address-pools":[$default_address_pools],
  "registry-mirrors" : [${PKG_DOCKER_REGISTRY_MIRRORS:-}],
  "insecure-registries" : [$insecure_registries]
}
EOF
    sudo systemctl daemon-reload
    sudo systemctl restart docker

    # Enable autocompletion
    sudo curl -s https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker -o /etc/bash_completion.d/docker.sh

    printf "Waiting for docker service..."
    until sudo docker info > /dev/null; do
        printf "."
        sleep 2
    done
    if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
        sudo docker info
        if command -v ctr; then
            sudo -E "$(command -v ctr)" --address "$(sudo find / -name containerd.sock  | head -n 1)" plugins ls
        fi
        #curl -fsSL https://raw.githubusercontent.com/moby/moby/master/contrib/check-config.sh | bash
    fi

    # Install Rootless Docker
    curl -fsSL https://get.docker.com/rootless | FORCE_ROOTLESS_INSTALL=1 sh

    # Install client interface for the registry API
    if ! command -v regctl; then
        echo "INFO: Installing regctl $version version..."

        OS="$(uname | tr '[:upper:]' '[:lower:]')"
        ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')"
        binary="regctl-$OS-$ARCH"
        url="https://github.com/regclient/regclient/releases/download/v${version}/$binary"
        if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
            curl -Lo ./regctl "$url"
            curl -Lo ./docker-regclient "https://raw.githubusercontent.com/regclient/regclient/v${version}/docker-plugin/docker-regclient"
        else
            curl -Lo ./regctl "$url" 2> /dev/null
            curl -Lo ./docker-regclient "https://raw.githubusercontent.com/regclient/regclient/v${version}/docker-plugin/docker-regclient" 2> /dev/null
        fi
        chmod +x ./regctl
        sudo mv ./regctl /usr/bin/regctl

        sed -i "s/version=.*/version=\"${version}\"/" docker-regclient
        chmod +x ./docker-regclient
        if [ -d /usr/libexec/docker/cli-plugins/ ]; then
            sudo cp ./docker-regclient /usr/libexec/docker/cli-plugins/docker-regctl
        fi
        mkdir -p "${HOME}/.docker/cli-plugins/"
        sudo mkdir -p /root/.docker/cli-plugins/
        sudo cp ./docker-regclient /root/.docker/cli-plugins/docker-regctl
        mv ./docker-regclient "${HOME}/.docker/cli-plugins/docker-regctl"
    fi
}

main
