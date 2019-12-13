#!/bin/bash
# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2019
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

set -o errexit
set -o pipefail

while IFS= read -r -d '' vagrantfile; do
    pushd "$(dirname "$vagrantfile")" > /dev/null
    for vm in $(vagrant status | grep running | awk '{ print $1 }'); do
        echo "$vm - Validation log"
        vagrant ssh "$vm" -- cat validate.log | grep "ERROR\|INFO"
    done
    popd > /dev/null
done <   <(find . -mindepth 2 -type f -name Vagrantfile -print0)
