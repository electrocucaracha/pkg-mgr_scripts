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

source _utils.sh
source _common.sh

trap exit_trap ERR

start=$(date +%s)
info "Starting long Integration tests - $VAGRANT_NAME"
for parallel_test in $parallel_tests; do
    pushd "$(find . -name "$parallel_test" -type d)" > /dev/null
    run_test
    popd > /dev/null
done
info "Long Integration tests completed - $VAGRANT_NAME"
printf "%s - Long Integration tests time:  %s secs\n" "$VAGRANT_NAME" "$(($(date +%s)-start))"
