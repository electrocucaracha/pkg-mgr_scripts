package main

import (
	"flag"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
	"strings"

	loads "github.com/go-openapi/loads"

	"github.com/electrocucaracha/pkg-mgr/api/handlers"
	"github.com/electrocucaracha/pkg-mgr/gen/restapi"
	"github.com/electrocucaracha/pkg-mgr/gen/restapi/operations"
	"github.com/electrocucaracha/pkg-mgr/internal/models"
)

var portFlag = flag.Int("port", 3000, "Port to run this service on")
var sqlEngineFlag = flag.String("sql-engine", "sqlite3", "SQL Engine to be used by this service")
var debug = flag.Bool("debug", false, "Enables verbosity output")

func main() {
	flag.Parse()

	// Switch *sqlEngineFlag
	datastore, err := models.NewSqliteDatastore("test.db", *debug)
	if err != nil {
		log.Panic(err)
	}
	// defer datastore.Db.Close()

	// Init DB
	filepath.Walk(".", func(path string, info os.FileInfo, err error) error {
		if strings.Contains(path, "main.sh") {
			file, err := os.Open(path)
			if err != nil {
				log.Fatal(err)
			}
			defer file.Close()

			b, err := ioutil.ReadAll(file)
			var builder strings.Builder
			builder.Grow(len(b))
			builder.Write(b)

			datastore.CreateScript(filepath.Dir(path), builder.String())
		}

		return nil
	})

	// load embedded swagger file
	swaggerSpec, err := loads.Analyzed(restapi.SwaggerJSON, "")
	if err != nil {
		log.Fatalln(err)
	}

	// create new service API
	api := operations.NewPkgMgrAPI(swaggerSpec)
	api.GetScriptHandler = handlers.NewGetBash(datastore)
	server := restapi.NewServer(api)
	defer server.Shutdown()

	server.Port = *portFlag
	if err := server.Serve(); err != nil {
		log.Fatalln(err)
	}
}
