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

function info {
    _print_msg "INFO" "$1"
}

function error {
    _print_msg "ERROR" "$1"
    exit 1
}

function _print_msg {
    echo "$1: $2"
}

function get_version {
    version=""
    attempt_counter=0
    max_attempts=5

    until [ "$version" ]; do
        url_effective=$(curl -sL -o /dev/null -w '%{url_effective}' "https://github.com/$1/releases/latest")
        if [ "$url_effective" ]; then
            version="${url_effective##*/}"
            break
        elif [ ${attempt_counter} -eq ${max_attempts} ]; then
            echo "Max attempts reached"
            exit 1
        fi
        attempt_counter=$((attempt_counter + 1))
        sleep $((attempt_counter * 2))
    done
    echo "${version#*v}"
}

# _vercmp() - Function that compares two versions
function _vercmp {
    local v1=$1
    local op=$2
    local v2=$3
    local result

    # sort the two numbers with sort's "-V" argument.  Based on if v2
    # swapped places with v1, we can determine ordering.
    result=$(echo -e "$v1\n$v2" | sort -V | head -1)

    case $op in
    "==")
        [ "$v1" = "$v2" ]
        return
        ;;
    ">")
        [ "$v1" != "$v2" ] && [ "$result" = "$v2" ]
        return
        ;;
    "<")
        [ "$v1" != "$v2" ] && [ "$result" = "$v1" ]
        return
        ;;
    ">=")
        [ "$result" = "$v2" ]
        return
        ;;
    "<=")
        [ "$result" = "$v1" ]
        return
        ;;
    *)
        die $LINENO "unrecognised op: $op"
        ;;
    esac
}

info "Validating terraform installation..."
for cmd in terraform terraform-docs terrascan; do
    if ! command -v "$cmd"; then
        error "$cmd command line wasn't installed"
    fi
done

info "Checking terraform version"
terraform_version="${PKG_TERRAFORM_VERSION:-$(get_version hashicorp/terraform)}"
if [ "$(terraform version | awk 'NR==1{ print $2}')" != "v$terraform_version" ]; then
    error "Terraform version installed is different that expected"
fi

info "Checking terrascan version"
if [ "$(terrascan version | awk '{ print $NF}')" != "v${PKG_TERRASCAN_VERSION:-$(get_version accurics/terrascan)}" ]; then
    error "Terrascan version installed is different that expected"
fi

info "Validating autocomplete functions"
if declare -F | grep -q "_terraform-docs"; then
    error "terraform-docs autocomplete install failed"
fi

pushd "$(mktemp -d)"
cat <<EOF >main.tf
terraform {
}

output "hello_world" {
  value = "Hello, World!"
}
EOF
if ! terraform init; then
    error "Terraform didn't initialize properly"
fi
if ! terraform apply -auto-approve; then
    error "Terraform apply didn't work"
fi
terraform destroy -auto-approve

if _vercmp "$terraform_version" '>=' "0.15.0"; then
    info "Running Terraform Experimental Test feature"
    mkdir -p tests/defaults/
    cat <<EOF >tests/defaults/test_defaults.tf
terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }
  }
}

module "main" {
  source = "../.."
}

resource "test_assertions" "hello_world_msg" {
  component = "hello_world_msg"

  equal "hello_world" {
    description = "default hello_world is Hello, World!"
    got         = module.main.hello_world
    want        = "Hello, World!"
  }
}
EOF
    terraform test
fi

info "Validating Terrascan"
terrascan scan --iac-type terraform
popd
