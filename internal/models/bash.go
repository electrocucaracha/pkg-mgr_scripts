package models

import (
	"github.com/electrocucaracha/pkg-mgr/internal/utils"
	"github.com/jinzhu/gorm"
	log "github.com/sirupsen/logrus"
)

// Bash represents a customized file which contains bash instructions to install a specific package
type Bash struct {
	gorm.Model
	Pkg       string `gorm:"unique;not null"`
	Functions []Function
}

// Function represent a function defined in a bash script
type Function struct {
	gorm.Model
	BashID  uint
	Name    string `gorm:"type:varchar(100)"`
	Content string `gorm:"type:varchar(10000)"`
}

// GetScript retrieves the first bash script stored in the database
func (db *gormDatastore) GetScript(pkg string) (*Bash, error) {
	log.WithFields(log.Fields{
		"package": pkg,
	}).Info("Requesting script package")

	var bash Bash
	err := db.Where("pkg = ?", pkg).Preload("Functions").Find(&bash).Error
	// err := db.First(&bash, "pkg = ?", pkg).Error
	if err != nil {
		if gorm.IsRecordNotFoundError(err) {
			return nil, nil
		}
		return nil, err
	}

	return &bash, nil
}

// CreateScript stores a bash script into database
func (db *gormDatastore) CreateScript(pkg, instructionSet string) (*Bash, []error) {
	log.WithFields(log.Fields{
		"package":        pkg,
		"instructionSet": instructionSet,
	}).Debug("Registering script package")

	var functions []Function
	extractedFunctions, err := utils.ExtractFunctions(instructionSet)
	if err != nil {
		log.Error("Failed to extract the functions")
		return nil, []error{err}
	}
	for name, content := range extractedFunctions {
		function := Function{Name: name, Content: content}
		log.WithFields(log.Fields{
			"name":    name,
			"content": content,
		}).Debug("Appending extracted function")
		functions = append(functions, function)
	}

	bash := &Bash{
		Pkg:       pkg,
		Functions: functions,
	}
	errs := db.Create(bash).GetErrors()
	if len(errs) > 0 {
		return nil, errs
	}

	return bash, nil
}
