#!/bin/bash
# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2021
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

set -o errexit
set -o pipefail
if [[ ${KRD_DEBUG:-false} == "true" ]]; then
    set -o xtrace
fi

PROVIDER=${PROVIDER:-virtualbox}
msg=""

function _get_box_version {
    version=""
    attempt_counter=0
    max_attempts=5
    name="$1"

    if [ -f ./ci/pinned_vagrant_boxes.txt ] && grep -q "^${name} .*$PROVIDER" ./ci/pinned_vagrant_boxes.txt; then
        version=$(grep "^${name} .*$PROVIDER" ./ci/pinned_vagrant_boxes.txt | awk '{ print $2 }')
    else
        until [ "$version" ]; do
            metadata="$(curl -s "https://app.vagrantup.com/api/v1/box/$name")"
            if [ "$metadata" ]; then
                version="$(echo "$metadata" | python -c 'import json,sys;print(json.load(sys.stdin)["current_version"]["version"])')"
                break
            elif [ ${attempt_counter} -eq ${max_attempts} ]; then
                echo "Max attempts reached"
                exit 1
            fi
            attempt_counter=$((attempt_counter + 1))
            sleep $((attempt_counter * 2))
        done
    fi

    echo "${version#*v}"
}

function _vagrant_pull {
    local alias="$1"
    local name="$2"
    local image="$3"

    version=$(_get_box_version "$name")

    if [ "$(curl "https://app.vagrantup.com/${name%/*}/boxes/${name#*/}/versions/$version/providers/$PROVIDER.box" -o /dev/null -w '%{http_code}\n' -s)" == "302" ] && [ "$(vagrant box list | grep -c "$name .*$PROVIDER, $version")" != "1" ]; then
        vagrant box remove --provider "$PROVIDER" --all --force "$name" || :
        vagrant box add --provider "$PROVIDER" --box-version "$version" "$name"
    elif [ "$(vagrant box list | grep -c "$name .*$PROVIDER, $version")" == "1" ]; then
        echo "$name($version, $PROVIDER) box is already present in the host"
    else
        msg+="$name($version, $PROVIDER) box doesn't exist\n"
        return
    fi
    cat <<EOT >>.distros_supported.yml
  - alias: $alias
    name: $name
    version: "$version"
    image: $image
EOT
}

if ! command -v vagrant >/dev/null; then
    # NOTE: Shorten link -> https://github.com/electrocucaracha/bootstrap-vagrant
    curl -fsSL http://bit.ly/initVagrant | bash
fi

cat <<EOT >.distros_supported.yml
---
# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2019
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################
linux:
EOT

_vagrant_pull "centos_7" "generic/centos7" "centos:centos7"
_vagrant_pull "centos_8" "centos/stream8" "quay.io/centos/centos:stream8"
_vagrant_pull "ubuntu_xenial" "generic/ubuntu1604" "ubuntu:xenial"
_vagrant_pull "ubuntu_bionic" "generic/ubuntu1804" "mcr.microsoft.com/devcontainers/base:bionic"
_vagrant_pull "ubuntu_focal" "generic/ubuntu2004" "mcr.microsoft.com/devcontainers/base:focal"
_vagrant_pull "opensuse_tumbleweed" "opensuse/Tumbleweed.x86_64" "opensuse/tumbleweed"
_vagrant_pull "opensuse_leap" "opensuse/Leap-15.2.x86_64" "opensuse/leap"
_vagrant_pull "debian_jessie" "generic/debian8" "debian:jessie"
_vagrant_pull "debian_stretch" "generic/debian9" "debian:stretch"
_vagrant_pull "debian_buster" "generic/debian10" "debian:buster"
_vagrant_pull "rocky_8" "rockylinux/8" "rockylinux:8"
_vagrant_pull "rocky_9" "rockylinux/9" "rockylinux:9"

if [ "$msg" ]; then
    echo -e "$msg"
    rm .distros_supported.yml
else
    mv .distros_supported.yml distros_supported.yml
fi
