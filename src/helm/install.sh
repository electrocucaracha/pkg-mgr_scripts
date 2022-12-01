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
    rhel | centos | fedora)
        INSTALLER_CMD+="$(command -v dnf || command -v yum) -y"
        if [[ ${PKG_DEBUG:-false} == "false" ]]; then
            INSTALLER_CMD+=" --quiet --errorlevel=0"
        fi
        # shellcheck disable=SC2068
        $INSTALLER_CMD install $@
        ;;
    esac
}

function main {
    local version=${PKG_HELM_VERSION:-3}
    cmds=()
    for cmd in openssl tar gzip; do
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

    echo "INFO: Installing helm $version version..."
    if [ "$version" == "2" ]; then
        helm_user="helm"
        export DESIRED_VERSION="v2.17.0"
        echo "INFO: Running get_helm.sh remote script"
        curl -L https://git.io/get_helm.sh | HELM_INSTALL_DIR=/usr/bin bash

        echo "INFO: Create helm service account"
        id -u "$helm_user" &>/dev/null || sudo useradd "$helm_user"
        echo "$helm_user ALL=(ALL) NOPASSWD: ALL" | sudo tee "/etc/sudoers.d/$helm_user"
        $sudo_cmd mkdir -p "/home/$helm_user/.kube"
        $sudo_cmd chown "$helm_user" -R "/home/$helm_user/"

        echo "INFO: Creating helm service"
        $sudo_cmd su "$helm_user" -c "helm init --wait --client-only"
        $sudo_cmd tee /etc/systemd/system/helm-serve.service <<EOF >/dev/null
[Unit]
Description=Helm Server
After=network.target
[Service]
Restart=always
ExecStart=$(command -v helm) serve --home /home/$helm_user/.helm
[Install]
WantedBy=multi-user.target
EOF
        $sudo_cmd systemctl enable helm-serve
        $sudo_cmd systemctl start helm-serve

        $sudo_cmd su "$helm_user" -c "helm repo remove local"
        $sudo_cmd su "$helm_user" -c "helm repo add local http://localhost:8879/charts"
        $sudo_cmd su "$helm_user" -c "helm repo update"
    else
        echo "INFO: Running get-helm-3 remote script"
        curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
    fi
    $sudo_cmd mkdir -p /etc/bash_completion.d
    helm completion bash | $sudo_cmd tee /etc/bash_completion.d/helm >/dev/null
}

main
