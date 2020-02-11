package main

import (
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"

	"github.com/caarlos0/env"
	loads "github.com/go-openapi/loads"
	log "github.com/sirupsen/logrus"

	"github.com/electrocucaracha/pkg-mgr/api/handlers"
	"github.com/electrocucaracha/pkg-mgr/gen/restapi"
	"github.com/electrocucaracha/pkg-mgr/gen/restapi/operations"
	"github.com/electrocucaracha/pkg-mgr/internal/models"
)

type Config struct {
	Debug       bool   `env:"PKG_DEBUG" envDefault:false`
	Port        int    `env:"PKG_PORT" envDefault:"3000"`
	ScriptsPath string `env:"PKG_SCRIPTS_PATH"`
	MainFile    string `env:"PKG_MAIN_FILE"`
	SqlEngine   string `env:"PKG_SQL_ENGINE"`
	DbUsername  string `env:"PKG_DB_USERNAME"`
	DbPassword  string `env:"PKG_DB_PASSWORD"`
	DbHostname  string `env:"PKG_DB_HOSTNAME"`
	Database    string `env:"PKG_DB_DATABASE" envDefault:"pkg_db"`
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

func readBashFile(path string) (string, error) {
	file, err := os.Open(path)
	if err != nil {
		return "", err
	}
	defer file.Close()

	b, err := ioutil.ReadAll(file)
	if err != nil {
		return "", err
	}

	var builder strings.Builder
	builder.Grow(len(b))
	builder.Write(b)

	return builder.String(), nil
}

var cfg Config
var datastore models.Datastore

func init() {
	env.Parse(&cfg)
	log.SetOutput(os.Stdout)

	if err := initDatastore(&cfg); err != nil {
		log.Fatal(err)
	}

	if cfg.Debug {
		log.SetLevel(log.DebugLevel)
	} else {
		log.SetLevel(log.WarnLevel)
	}

	// Init DB
	log.Println("Database Init...")
	err := filepath.Walk(cfg.ScriptsPath, func(path string, info os.FileInfo, err error) error {
		if strings.Contains(path, "main.sh") {
			instructionSet, err := readBashFile(path)
			if err != nil {
				return err
			}

			_, errs := datastore.CreateScript(filepath.Base(filepath.Dir(path)), instructionSet)
			if len(errs) > 0 {
				return errs[0]
			}
		}

		return nil
	})
	if err != nil {
		log.Fatal(err)
	}

	instructionSet, err := readBashFile(cfg.MainFile)
	if err != nil {
		log.Fatal(err)
	}

	_, errs := datastore.CreateScript(handlers.MainBashPackage, instructionSet)
	if len(errs) > 0 {
		log.Fatal(errs[0])
	}
}

func main() {
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
}
