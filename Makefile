# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2020
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

DOCKER_CMD ?= $(shell which docker 2> /dev/null || which podman 2> /dev/null || echo docker)

build:
	@docker-compose build --compress --force-rm
	sudo -E $(DOCKER_CMD) image prune --force
deploy: undeploy
	@docker-compose up --force-recreate --detach --no-build
logs:
	@docker-compose logs --follow
undeploy:
	@docker-compose down --remove-orphans

.PHONY: lint
lint:
	sudo -E $(DOCKER_CMD) run --rm -v $$(pwd):/tmp/lint \
	-e RUN_LOCAL=true \
	-e LINTER_RULES_PATH=/ \
	-e KUBERNETES_KUBEVAL_OPTIONS=--ignore-missing-schemas \
	github/super-linter
	tox -e lint
