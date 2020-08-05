#!/bin/bash
# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2020
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

set -o errexit
set -o pipefail

for box in $(yq r distros_supported.yml "linux.(*).name"); do
    echo "Validating $box box..."
    local_version=$(yq r distros_supported.yml "linux.(name==$box).version")
    current_version=$(curl -s "https://app.vagrantup.com/api/v1/box/$box" | jq -r '.current_version.version')
    if [ "$local_version" != "$current_version" ]; then
        vagrant box update --box "$box"
        if vagrant box list | grep "$box" | grep "$local_version" > /dev/null; then
            vagrant box remove "$box" --box-version "$local_version"
        fi
    fi
    echo "Registering $current_version version for $box..."
    yq w -i distros_supported.yml "linux.(name==$box).version" "\"$current_version\""
done
