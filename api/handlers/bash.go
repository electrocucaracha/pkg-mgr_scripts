package handlers

import (
	"fmt"
	"strings"

	"github.com/electrocucaracha/pkg-mgr/gen/restapi/operations"
	"github.com/electrocucaracha/pkg-mgr/internal/models"
	middleware "github.com/go-openapi/runtime/middleware"
)

const header = `#!/bin/bash
# SPDX-license-identifier: Apache-2.0
##############################################################################
# Copyright (c) 2020
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################`
const setters = `set -o nounset
set -o errexit
set -o pipefail`
const MainBashPackage = "install"

// NewGetBash handles a request for getting an bash script
func NewGetBash(db models.Datastore) operations.GetScriptHandler {
	return &bashStoreWrapper{db: db}
}

type bashStoreWrapper struct {
	db models.Datastore
}

// Handle the get entry request
func (e *bashStoreWrapper) Handle(params operations.GetScriptParams) middleware.Responder {
	bash, err := e.db.GetScript(params.Pkg)
	if err != nil {
		return operations.NewGetScriptDefault(500)
	}
	if bash == nil {
		return operations.NewGetScriptNotFound()
	}

	output := []string{header, setters}
	for _, function := range bash.Functions {
		output = append(output, fmt.Sprintf("function %s {\n%s\n}", function.Name, function.Content))
	}
	if params.PkgUpdate != nil && *params.PkgUpdate {
		if params.Pkg != MainBashPackage {
			bash, err := e.db.GetScript(MainBashPackage)
			if err != nil {
				return operations.NewGetScriptDefault(500)
			}
			for _, function := range bash.Functions {
				if function.Name != "main" {
					output = append(output, fmt.Sprintf("function %s {\n%s\n}", function.Name, function.Content))
				}
			}
		}

		output = append(output, "update_repos")
	}
	if len(bash.Functions) > 0 {
		output = append(output, "main")
	}

	return operations.NewGetScriptOK().WithPayload(strings.Join(output, "\n\n"))
}
