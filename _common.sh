#!/bin/bash
# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2021
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

parallel_tests=$(cat parallel-tests.txt)
mgmt_nic="$(ip route get 1.1.1.1 | awk 'NR==1 { print $5 }')"
ratio=$((1024*1024)) # MB
export CPUS=${CPUS:-1}
export MEMORY=${MEMORY:-3072}
export VAGRANT_NAME=${VAGRANT_NAME:-ubuntu_xenial}
export parallel_tests mgmt_nic ratio

vagrant_cmd=""
if [ "${SUDO_VAGRANT_CMD:-false}" == "true" ]; then
    vagrant_cmd="sudo -E"
fi
vagrant_cmd+=" $(command -v vagrant)"
vagrant_up_cmd="$vagrant_cmd up --no-destroy-on-error $VAGRANT_NAME"
vagrant_destroy_cmd="$vagrant_cmd destroy -f $VAGRANT_NAME"
export vagrant_cmd vagrant_up_cmd vagrant_destroy_cmd

# Setup CI versions
export PKG_GOLANG_VERSION=1.15.4
export PKG_VAGRANT_VERSION=2.2.14
