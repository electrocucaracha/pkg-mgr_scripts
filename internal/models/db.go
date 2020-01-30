package models

import (
	"log"
	"os"

	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/sqlite" // SQLite dialect for gorm
)

// Datastore provides the methods supported by different databases
type Datastore interface {
	GetScript(pkg string) (*Bash, error)
	CreateScript(pkg, instructionSet string) error
}

// DB represents the database context used by this application
type DB struct {
	*gorm.DB
}

// NewSqliteDatastore creates a database connection for a specific engine
func NewSqliteDatastore(file string, debug bool) (Datastore, error) {
	db, err := gorm.Open("sqlite3", file)
	if err != nil {
		return nil, err
	}

	db.SetLogger(log.New(os.Stdout, "\r\n", 0))
	db.LogMode(debug)
	db.AutoMigrate(&Bash{})

	return &DB{db}, nil
}
