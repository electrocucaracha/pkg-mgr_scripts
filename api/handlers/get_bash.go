package handlers

import (
	"github.com/electrocucaracha/pkg-mgr/gen/restapi/operations"
	"github.com/electrocucaracha/pkg-mgr/internal/models"
	middleware "github.com/go-openapi/runtime/middleware"
)

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
	if err != nil || bash == nil {
		return operations.NewGetScriptNotFound()
	}

	return operations.NewGetScriptOK().WithPayload(bash.InstructionSet)
}
