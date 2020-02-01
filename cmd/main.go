package main

import (
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
	"strings"

	"github.com/caarlos0/env"
	loads "github.com/go-openapi/loads"

	"github.com/electrocucaracha/pkg-mgr/api/handlers"
	"github.com/electrocucaracha/pkg-mgr/gen/restapi"
	"github.com/electrocucaracha/pkg-mgr/gen/restapi/operations"
	"github.com/electrocucaracha/pkg-mgr/internal/models"
)

type Config struct {
	Debug      bool   `env:"PKG_DEBUG" envDefault:false`
	Port       int    `env:"PKG_PORT" envDefault:"3000"`
	SqlEngine  string `env:"PKG_SQL_ENGINE"`
	DbUsername string `env:"PKG_DB_USERNAME"`
	DbPassword string `env:"PKG_DB_PASSWORD"`
	DbHostname string `env:"PKG_DB_HOSTNAME"`
	Database   string `env:"PKG_DB_DATABASE" envDefault:"pkg_db"`
}

func initDatastore(cfg *Config) (err error) {
	switch sqlEngine := cfg.SqlEngine; sqlEngine {
	case "sqlite":
		datastore, err = models.NewSqliteDatastore(cfg.Database+".db", cfg.Debug)
	case "mysql":
		datastore, err = models.NewMySqlDatastore(cfg.DbUsername, cfg.DbPassword, cfg.DbHostname, cfg.Database)
	default:
		log.Fatalf("Unsupported SQL engine(%s)", sqlEngine)
	}

	return
}

var cfg Config
var datastore models.Datastore

func init() {
	env.Parse(&cfg)

	if err := initDatastore(&cfg); err != nil {
		log.Fatalln(err)
	}
}

func main() {
	// Init DB
	log.Println("Database Init...")
	filepath.Walk("./scripts/", func(path string, info os.FileInfo, err error) error {
		if strings.Contains(path, "main.sh") {
			file, err := os.Open(path)
			if err != nil {
				log.Fatalln(err)
			}
			defer file.Close()

			b, err := ioutil.ReadAll(file)
			var builder strings.Builder
			builder.Grow(len(b))
			builder.Write(b)

			datastore.CreateScript(filepath.Base(filepath.Dir(path)), builder.String())
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

	server.Port = cfg.Port
	if err := server.Serve(); err != nil {
		log.Fatalln(err)
	}
}
