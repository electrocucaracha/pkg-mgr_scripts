#!/bin/bash
# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2024
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

set -o nounset
set -o errexit
set -o pipefail

# Optional helper provided by `devcontainer features test`.
if [ -f dev-container-features-test-lib ]; then
    # shellcheck source=/dev/null
    source dev-container-features-test-lib
fi

if command -v check >/dev/null; then
    check "kubectl CLI is installed after duplicate install" bash -c "command -v kubectl"
    check "default option env variable provided" bash -c "test -n \"${PKG_KUBECTL_VERSION__DEFAULT:-}\""
    check "randomized option env variable provided" bash -c "test -n \"${PKG_KUBECTL_VERSION:-}\""
    reportResults
else
    command -v kubectl >/dev/null
    test -n "${PKG_KUBECTL_VERSION__DEFAULT:-}"
    test -n "${PKG_KUBECTL_VERSION:-}"
fi
