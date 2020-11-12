#!/bin/bash
# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2019
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

set -o nounset
set -o errexit
set -o pipefail

mgmt_nic=$(ip route | grep "^192.168.121.0/24\|10.0.2.0/24" | head -n1 | awk '{ print $3 }')
mgmt_ip=$(ip addr | awk "/${mgmt_nic}\$/ { sub(/\/[0-9]*/, \"\","' $2); print $2; exit}')

function info {
    _print_msg "INFO" "$1"
}

function warn {
    _print_msg "WARN" "$1"
}

function error {
    _print_msg "ERROR" "$1"
    exit 1
}

function _print_msg {
    echo "$1: $2"
}

info "Validating Docker installation..."
if ! command -v docker; then
    error "Docker command line wasn't installed"
fi

info "Validate autocomplete functions"
if declare -F | grep -q "_docker"; then
    error "Docker autocomplete functions weren't installed"
fi

docker_image="alpine"
for image in "$mgmt_ip:5000/bash:test" "$docker_image"; do
    docker_id=$(sudo docker images "$image" -q)
    if [[ -n "$docker_id" ]]; then
        info "Removing previous docker image with id = $docker_id"
        sudo docker rmi -f "$docker_id"
    fi
done
if [[ -n $(sudo docker ps -aqf "name=registry") ]]; then
    sudo docker rm -f registry
fi

info "Validating Docker pulling process with $docker_image image"
if ! sudo docker pull "$docker_image"; then
    error "Docker pull action doesn't work"
fi
sudo docker run busybox nslookup google.com

info "Validating Docker building process with $docker_image image"
pushd "$(mktemp -d)"
cat << EOF > Dockerfile
FROM alpine
RUN apk update && apk add bash
EOF
if ! sudo docker build --no-cache -t "$mgmt_ip:5000/bash:test" . ; then
    error "Docker build action doesn't work"
fi
popd

info "Validating Docker pushing process with $docker_image image"
if [[ -z $(sudo docker ps -aqf "name=registry") ]]; then
    info "Starting a local Docker registry"
    sudo docker run -d --name registry --restart=always \
    -p 5000:5000 -v registry:/var/lib/registry registry:2
fi
if ! sudo docker push "$mgmt_ip:5000/bash:test"; then
    error "Docker push action doesn't work"
fi
if ! command -v jq; then
    error "Docker validation requires jq"
fi
if [ "$(curl -s -X GET http://localhost:5000/v2/_catalog | jq -r '.repositories | contains(["bash"])')" != "true" ]; then
    error "Bash docker image wasn't stored in a local registry"
fi

info "Validate Registry client installation"
if [ "$(sudo docker regctl image ratelimit "$docker_image" | jq -r '.Limit')" != "500" ]; then
    warn "regctl wasn't installed properly"
fi
