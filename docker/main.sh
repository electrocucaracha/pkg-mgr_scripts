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

function main {
    # shellcheck disable=SC1091
    source /etc/os-release || source /usr/lib/os-release
    if ! command -v docker; then
        echo "Installing docker service..."

        case ${ID,,} in
            clear-linux-os)
                sudo -E swupd bundle-add containers-basic
            ;;
            *)
                curl -fsSL https://get.docker.com/ | sh
            ;;
        esac
    fi

    sudo mkdir -p /etc/systemd/system/docker.service.d
    mkdir -p "$HOME/.docker/"
    sudo mkdir -p /root/.docker/
    sudo usermod -aG docker "$USER"
    if [ -n "${SOCKS_PROXY:-}" ]; then
        socks_tmp="${SOCKS_PROXY#*//}"
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
    if [ -n "${HTTP_PROXY:-}" ] || [ -n "${HTTPS_PROXY:-}" ] || [ -n "${NO_PROXY:-}" ]; then
        config="{ \"proxies\": { \"default\": { "
        if [ -n "${HTTP_PROXY:-}" ]; then
            config+="\"httpProxy\": \"$HTTP_PROXY\","
        fi
        if [ -n "${HTTPS_PROXY:-}" ]; then
            config+="\"httpsProxy\": \"$HTTPS_PROXY\","
        fi
        if [ -n "${NO_PROXY:-}" ]; then
            config+="\"noProxy\": \"$NO_PROXY\","
        fi
        echo "${config::-1} } } }" | tee "$HOME/.docker/config.json"
        sudo cp "$HOME/.docker/config.json" /root/.docker/config.json
    fi
    sudo mkdir -p /etc/docker
    sudo tee /etc/docker/daemon.json << EOF
{
  "insecure-registries" : ["${PKG_DOCKER_INSECURE_REGISTRIES:-"0.0.0.0/0"}"]
}
EOF
    sudo systemctl daemon-reload
    sudo systemctl unmask docker.service
    sudo systemctl restart docker

    printf "Waiting for docker service..."
    until sudo docker info; do
        printf "."
        sleep 2
    done
}

main
