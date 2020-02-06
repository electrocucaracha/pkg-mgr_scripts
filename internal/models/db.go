package models

import (
	"fmt"
	log "github.com/sirupsen/logrus"

	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/mysql"  // MySQL/MariaDB dialect for gorm
	_ "github.com/jinzhu/gorm/dialects/sqlite" // SQLite dialect for gorm
)

// Datastore provides the methods supported by different databases
type Datastore interface {
	GetScript(pkg string) (*Bash, error)
	CreateScript(pkg, instructionSet string) (*Bash, []error)
}

type gormDatastore struct {
	*gorm.DB
}

// NewSqliteDatastore creates a database connection for a SQLite engine
func NewSqliteDatastore(file string, debug bool) (Datastore, error) {
	logger := log.WithFields(log.Fields{"file": file, "debug": debug})
	db, err := gorm.Open("sqlite3", file)
	if err != nil {
		logger.Fatal("Failed to open a SQLite DB file")
		return nil, err
	}

	logger.Info("Configuring SQLite DB")
	db.LogMode(debug)
	db.AutoMigrate(&Bash{})
	db.AutoMigrate(&Function{})

	return &gormDatastore{db}, nil
}

// NewMySqlDatastore creates a database connection for a MySQL/MariaDB engine
func NewMySqlDatastore(username, password, hostname, database string) (Datastore, error) {
	connectionString := fmt.Sprintf("%s:%s@tcp(%s:3306)/%s?charset=utf8&parseTime=True&loc=Local", username, password, hostname, database)
	log.Println(connectionString)
	db, err := gorm.Open("mysql", connectionString)
	if err != nil {
		return nil, err
	}

	db.AutoMigrate(&Bash{})
	db.AutoMigrate(&Function{})

	return &gormDatastore{db}, nil
}
