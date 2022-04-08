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
    local version=${PKG_HELM_VERSION:-3}

    if ! command -v openssl; then
        # shellcheck disable=SC1091
        source /etc/os-release || source /usr/lib/os-release
        case ${ID,,} in
            *suse*)
                sudo zypper -q install -y --no-recommends openssl
            ;;
        esac
    fi

    echo "INFO: Installing helm $version version..."
    if [ "$version" == "2" ]; then
        helm_user="helm"
        export DESIRED_VERSION="v2.17.0"
        echo "INFO: Running get_helm.sh remote script"
        curl -L https://git.io/get_helm.sh | HELM_INSTALL_DIR=/usr/bin bash

        echo "INFO: Create helm service account"
        id -u "$helm_user" &>/dev/null || sudo useradd "$helm_user"
        echo "$helm_user ALL=(ALL) NOPASSWD: ALL" | sudo tee "/etc/sudoers.d/$helm_user"
        sudo mkdir -p "/home/$helm_user/.kube"
        sudo chown "$helm_user" -R "/home/$helm_user/"

        echo "INFO: Creating helm service"
        sudo su "$helm_user" -c "helm init --wait --client-only"
        sudo tee <<EOF /etc/systemd/system/helm-serve.service >/dev/null
[Unit]
Description=Helm Server
After=network.target
[Service]
Restart=always
ExecStart=$(command -v helm) serve --home /home/$helm_user/.helm
[Install]
WantedBy=multi-user.target
EOF
        sudo systemctl enable helm-serve
        sudo systemctl start helm-serve

        sudo su "$helm_user" -c "helm repo remove local"
        sudo su "$helm_user" -c "helm repo add local http://localhost:8879/charts"
        sudo su "$helm_user" -c "helm repo update"
    else
        echo "INFO: Running get-helm-3 remote script"
        curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
    fi
    sudo mkdir -p /etc/bash_completion.d
    helm completion bash | sudo tee /etc/bash_completion.d/helm > /dev/null
}

main
