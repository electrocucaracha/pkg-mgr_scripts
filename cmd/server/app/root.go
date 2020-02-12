package app

import (
	"os"

	"github.com/caarlos0/env"
	log "github.com/sirupsen/logrus"
	"github.com/spf13/cobra"

	"github.com/electrocucaracha/pkg-mgr/internal/models"
)

const (
	// cURL package manager component name
	componentPkgMgr = "pkg-mgr"
)

var (
	Verbose   bool
	cfg       Config
	datastore models.Datastore
	rootCmd   = &cobra.Command{
		Use:   componentPkgMgr,
		Short: "cURL Package Manager is a Multi-Distribution Bash script generator",
		Long: `The cURL package manager server provides bash scripts which can be used
	on most commercial Linux distributions`,
	}
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

// Execute executes the init command.
func Execute() error {
	return rootCmd.Execute()
}

func init() {
	env.Parse(&cfg)
	log.SetOutput(os.Stdout)

	log.SetLevel(log.WarnLevel)
	rootCmd.PersistentFlags().BoolVarP(&Verbose, "verbose", "v", false, "verbose output")
	if Verbose {
		Verbose = cfg.Debug
		log.SetLevel(log.DebugLevel)
	}

	var err error
	datastore, err = models.GetDatastore(map[string]string{
		"DATASTORE":                cfg.SqlEngine,
		"DATASTORE_SQLITE_FILE":    cfg.Database + ".db",
		"DATASTORE_MYSQL_USERNAME": cfg.DbUsername,
		"DATASTORE_MYSQL_PASSWORD": cfg.DbPassword,
		"DATASTORE_MYSQL_HOSTNAME": cfg.DbHostname,
		"DATASTORE_MYSQL_DATABASE": cfg.Database,
	})
	if err != nil {
		log.Fatal(err)
	}
}
