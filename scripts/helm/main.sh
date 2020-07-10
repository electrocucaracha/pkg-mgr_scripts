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

function main {
    local helm_version=${PKG_HELM_VERSION:-3}

    if [ "$helm_version" == "2" ]; then
        curl -L https://git.io/get_helm.sh | HELM_INSTALL_DIR=/usr/bin bash
        id -u helm &>/dev/null || sudo useradd helm
        echo "helm ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/helm
        sudo mkdir -p /home/helm/.kube
        sudo chown helm -R /home/helm/

        sudo tee <<EOF /etc/systemd/system/helm-serve.service >/dev/null
[Unit]
Description=Helm Server
After=network.target
[Service]
User=helm
Restart=always
ExecStart=/usr/bin/helm serve
[Install]
WantedBy=multi-user.target
EOF
        sudo su helm -c "helm init --wait --client-only"
        sudo systemctl enable helm-serve
        sudo systemctl start helm-serve
        sudo su helm -c "helm repo remove local"
        sudo su helm -c "helm repo add local http://localhost:8879/charts"
        sudo su helm -c "helm repo update"
    else
        curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
    fi
}

main