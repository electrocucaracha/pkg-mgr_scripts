package models

import (
	log "github.com/sirupsen/logrus"

	"github.com/jinzhu/gorm"
)

// Bash represents a customized file which contains bash instructions to install a specific package
type Bash struct {
	gorm.Model
	Pkg            string `gorm:"unique;not null"`
	InstructionSet string `gorm:"type:varchar(65000)"`
}

// GetScript retrieves the first bash script stored in the database
func (db *gormDatastore) GetScript(pkg string) (*Bash, error) {
	log.WithFields(log.Fields{
		"package": pkg,
	}).Info("Requesting script package")

	var bash Bash
	db.First(&bash, "pkg = ?", pkg)

	return &bash, nil
}

// CreateScript stores a bash script into database
func (db *gormDatastore) CreateScript(pkg, instructionSet string) error {
	log.WithFields(log.Fields{
		"package":        pkg,
		"instructionSet": instructionSet,
	}).Info("Registering script package")

	db.Create(&Bash{
		Pkg:            pkg,
		InstructionSet: instructionSet,
	})

	return nil
}
