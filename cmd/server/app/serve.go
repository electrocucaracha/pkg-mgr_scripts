package app

import (
	loads "github.com/go-openapi/loads"
	log "github.com/sirupsen/logrus"
	"github.com/spf13/cobra"

	"github.com/electrocucaracha/pkg-mgr/api/handlers"
	"github.com/electrocucaracha/pkg-mgr/gen/restapi"
	"github.com/electrocucaracha/pkg-mgr/gen/restapi/operations"
)

func init() {
	rootCmd.AddCommand(serveCmd)
}

var serveCmd = &cobra.Command{
	Use:   "serve",
	Short: "Start the cURL Package Manager API",
	Long:  `Starts and waits for HTTP requests which consumes the API of the cURL Package Manager`,
	Run: func(cmd *cobra.Command, args []string) {
		// load embedded swagger file
		swaggerSpec, err := loads.Analyzed(restapi.SwaggerJSON, "")
		if err != nil {
			log.Fatal(err)
		}

		// create new service API
		api := operations.NewPkgMgrAPI(swaggerSpec)
		api.GetScriptHandler = handlers.NewGetBash(datastore)
		server := restapi.NewServer(api)
		defer server.Shutdown()

		server.Port = cfg.Port
		if err := server.Serve(); err != nil {
			log.Fatal(err)
		}
	},
}
