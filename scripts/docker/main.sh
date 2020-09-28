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

function main {
    # shellcheck disable=SC1091
    source /etc/os-release || source /usr/lib/os-release
    if ! command -v docker; then
        echo "Installing docker service..."

        case ${ID,,} in
            clear-linux-os)
                if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
                    sudo -E swupd bundle-add containers-basic
                else
                    sudo -E swupd bundle-add --quiet containers-basic
                fi
            ;;
            *suse*)
                ZYPPER_CMD="sudo -H -E zypper"
                if [[ "${PKG_DEBUG:-false}" == "false" ]]; then
                    ZYPPER_CMD+=" -q"
                fi
                $ZYPPER_CMD addrepo https://download.opensuse.org/repositories/Virtualization:containers/openSUSE_Tumbleweed/Virtualization:containers.repo
                sudo zypper --gpg-auto-import-keys refresh
                $ZYPPER_CMD install -y --no-recommends docker
            ;;
            rhel|centos|fedora)
                PKG_MANAGER=$(command -v dnf || command -v yum)
                if [[ "${PKG_DEBUG:-false}" == "true" ]]; then
                    sudo -H -E "${PKG_MANAGER}" -y install https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm
                else
                    sudo -H -E "${PKG_MANAGER}" -y install --quiet --errorlevel=0 https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm
                fi
                curl -fsSL https://get.docker.com/ | sh
                sudo sed -i "s/FirewallBackend=.*/FirewallBackend=iptables/g" /etc/firewalld/firewalld.conf
                sudo systemctl restart firewalld
            ;;
            ubuntu|debian)
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
        if ! command -v wget; then
            curl -fsSL http://bit.ly/install_pkg | PKG=wget bash
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
    until sudo docker info; do
        printf "."
        sleep 2
    done
    # curl -fsSL https://raw.githubusercontent.com/moby/moby/master/contrib/check-config.sh | bash
}

main
