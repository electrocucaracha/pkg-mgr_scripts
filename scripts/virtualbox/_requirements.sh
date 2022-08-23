#!/bin/bash
# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2022
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

set -o errexit
set -o nounset
set -o pipefail

# shellcheck disable=SC1091
source /etc/os-release || source /usr/lib/os-release
case ${ID,,} in
centos)
    PKG_MANAGER=$(command -v dnf || command -v yum)
    sudo "$PKG_MANAGER" updateinfo --assumeyes
    sudo "$PKG_MANAGER" -y --quiet --errorlevel=0 install kernel
    sudo grub2-set-default 0
    grub_cfg="$(sudo readlink -f /etc/grub2.cfg)"
    if dmesg | grep EFI; then
        grub_cfg="/boot/efi/EFI/centos/grub.cfg"
    fi
    sudo grub2-mkconfig -o "$grub_cfg"
    ;;
esac
