package models

import (
	"errors"
	"fmt"
	"strings"

	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/mysql"  // MySQL/MariaDB dialect for gorm
	_ "github.com/jinzhu/gorm/dialects/sqlite" // SQLite dialect for gorm
	log "github.com/sirupsen/logrus"
)

// Datastore provides the methods supported by different databases
type Datastore interface {
	GetScript(pkg string) (*Bash, error)
	CreateScript(pkg, instructionSet string) (*Bash, []error)
}

type gormDatastore struct {
	*gorm.DB
}

type DatastoreFactory func(conf map[string]string) (Datastore, error)

var datastoreFactories = make(map[string]DatastoreFactory)

func init() {
	Register("mysql", NewMySqlDatastore)
	Register("sqlite", NewSqliteDatastore)
}

// Register registers a given SQL engine in the internal catalog
func Register(name string, factory DatastoreFactory) {
	logger := log.WithFields(log.Fields{"name": name})

	if factory == nil {
		logger.Panic("Datastore factory does not exist.")
	}
	_, ok := datastoreFactories[name]
	if ok {
		logger.Error("Datastore factory already registered. Ignoring.")
	}
	datastoreFactories[name] = factory
}

// GetDatastore creates a SQL datastore object based on the DATASTORE configuration value
func GetDatastore(conf map[string]string) (Datastore, error) {
	engine, ok := conf["DATASTORE"]
	if !ok {
		log.Fatal("Undefined SQL engine")
	}

	engineFactory, ok := datastoreFactories[engine]
	if !ok {
		availableDatastores := make([]string, len(datastoreFactories))
		for k, _ := range datastoreFactories {
			availableDatastores = append(availableDatastores, k)
		}
		return nil, errors.New(fmt.Sprintf("Invalid Datastore name. Must be one of: %s", strings.Join(availableDatastores, ", ")))
	}

	return engineFactory(conf)
}

// NewSqliteDatastore creates a database connection for a SQLite engine
func NewSqliteDatastore(conf map[string]string) (Datastore, error) {
	logger := log.WithFields(log.Fields{"conf": conf})

	file, ok := conf["DATASTORE_SQLITE_FILE"]
	if !ok {
		file = "pkg_db.db"
	}
	db, err := gorm.Open("sqlite3", file)
	if err != nil {
		logger.Fatal("Failed to open a SQLite DB file")
		return nil, err
	}

	logger.Info("Configuring SQLite DB")
	// db.LogMode(Verbose)
	db.AutoMigrate(&Bash{})
	db.AutoMigrate(&Function{})

	return &gormDatastore{db}, nil
}

// NewMySqlDatastore creates a database connection for a MySQL/MariaDB engine
func NewMySqlDatastore(conf map[string]string) (Datastore, error) {
	logger := log.WithFields(log.Fields{"conf": conf})

	var err error
	getValue := func(key string) string {
		if err != nil {
			return ""
		}
		value, ok := conf[key]
		if !ok {
			err = errors.New(fmt.Sprintf("%s is required for the mysql datastore", key))
			return ""
		}
		return value
	}
	username := getValue("DATASTORE_MYSQL_USERNAME")
	password := getValue("DATASTORE_MYSQL_PASSWORD")
	hostname := getValue("DATASTORE_MYSQL_HOSTNAME")
	database := getValue("DATASTORE_MYSQL_DATABASE")
	if err != nil {
		return nil, err
	}

	connectionString := fmt.Sprintf("%s:%s@tcp(%s:3306)/%s?charset=utf8&parseTime=True&loc=Local", username, password, hostname, database)
	db, err := gorm.Open("mysql", connectionString)
	if err != nil {
		return nil, err
	}
	logger.Info("Configuring MySQL DB")
	db.AutoMigrate(&Bash{})
	db.AutoMigrate(&Function{})

	return &gormDatastore{db}, nil
}
