# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2020
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

PWD := $(shell pwd)
PLATFORM := linux
BINARY := pkg_mgr

export GO111MODULE=on

format:
	@go fmt ./...

swagger:
	@rm -rf gen/*
	@swagger generate server -t gen -f ./api/openapi-spec/swagger.yaml --exclude-main -A pkg-mgr

run: clean test cover
	@go run ./cmd/main.go --port 3000 --sql-engine sqlite3

test:
	@go test -v ./...

.PHONY: cover
cover:
	@go test -race ./... -coverprofile=coverage.out
	@go tool cover -html=coverage.out -o coverage.html

clean:
	@rm -f test.db
	@rm -f coverage.*
	@rm -f $(BINARY)

build: clean
	CGO_ENABLED=0 GOOS=$(PLATFORM) GOARCH=amd64
	@go build -v -o $(PWD)/$(BINARY) cmd/main.go
