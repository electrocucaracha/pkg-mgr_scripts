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
    check "podman CLI is installed" bash -c "command -v podman"
    check "podman CLI returns version" podman --version
    reportResults
else
    command -v podman >/dev/null
    podman --version >/dev/null
fi
