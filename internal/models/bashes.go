package models

import (
	"github.com/jinzhu/gorm"
)

// Bash represents a customized file which contains bash instructions to install a specific package
type Bash struct {
	gorm.Model
	Pkg            string `gorm:"unique;not null"`
	InstructionSet string `gorm:"type:varchar(200)"`
}

// GetScript retrieves the first bash script stored in the database
func (db *DB) GetScript(pkg string) (*Bash, error) {
	var bash Bash
	db.First(&bash, "pkg = ?", pkg)

	return &bash, nil
}

// CreateScript stores a bash script into database
func (db *DB) CreateScript(pkg, instructionSet string) error {
	db.Create(&Bash{
		Pkg:            pkg,
		InstructionSet: instructionSet,
	})

	return nil
}
