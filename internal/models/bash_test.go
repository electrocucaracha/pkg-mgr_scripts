package models

import (
	"database/sql/driver"
	"reflect"
	"regexp"
	"testing"
	"time"

	"github.com/DATA-DOG/go-sqlmock"
	"github.com/jinzhu/gorm"
)

type AnyTime struct{}

// Match satisfies sqlmock.Argument interface
func (a AnyTime) Match(v driver.Value) bool {
	_, ok := v.(time.Time)
	return ok
}

func TestGetScript(t *testing.T) {
	testCases := []struct {
		label            string
		input            string
		mockRows         []string
		expectedResponse *Bash
	}{
		{
			label: "Bash no found",
			input: "test",
		},
		{
			label:            "Get an existing bash",
			input:            "test",
			mockRows:         []string{"test"},
			expectedResponse: &Bash{Pkg: "test"},
		},
	}
	db, mock, err := sqlmock.New()
	if err != nil {
		t.Fatalf("an error '%s' was not expected when opening a stub database connection", err)
	}
	defer db.Close()

	orm, err := gorm.Open("mysql", db)
	if err != nil {
		t.Fatal(err)
	}
	datastore := &gormDatastore{orm}

	for _, testCase := range testCases {
		t.Run(testCase.label, func(t *testing.T) {
			returnedRows := sqlmock.NewRows([]string{"pkg"})
			for _, row := range testCase.mockRows {
				returnedRows.AddRow(row)
			}

			mock.ExpectQuery(regexp.QuoteMeta(
				"SELECT * FROM `bashes` WHERE `bashes`.`deleted_at` IS NULL AND ((pkg = ?))")).
				WithArgs(testCase.input).WillReturnRows(returnedRows)

			response, err := datastore.GetScript(testCase.input)
			if err != nil {
				t.Fatal(err)
			}
			if testCase.expectedResponse != nil && !reflect.DeepEqual(testCase.expectedResponse, response) {
				t.Fatalf("GetScript method returned bash object: \n%v\n and it was expected: \n%v",
					response, testCase.expectedResponse)
			}
		})
	}
}

func TestCreateBash(t *testing.T) {
	testCases := []struct {
		label            string
		input            []string
		expectedResponse *Bash
	}{
		{
			label: "Register a bash successfully",
			input: []string{"test", `
#!/bin/bash

function main {
    echo test
}

main`},
			expectedResponse: &Bash{
				Pkg: "test",
				Functions: []Function{
					Function{
						Name:    "main",
						Content: "    echo test",
					},
				},
			},
		},
	}
	db, mock, err := sqlmock.New()
	if err != nil {
		t.Fatalf("an error '%s' was not expected when opening a stub database connection", err)
	}
	defer db.Close()

	orm, err := gorm.Open("mysql", db)
	if err != nil {
		t.Fatal(err)
	}
	datastore := &gormDatastore{orm}

	for _, testCase := range testCases {
		t.Run(testCase.label, func(t *testing.T) {
			mock.ExpectBegin()
			mock.ExpectExec(regexp.QuoteMeta(
				"INSERT INTO `bashes` (`created_at`,`updated_at`,`deleted_at`,`pkg`) VALUES (?,?,?,?)")).
				WithArgs(AnyTime{}, AnyTime{}, nil, testCase.input[0]).WillReturnResult(sqlmock.NewResult(1, 1))
			mock.ExpectExec(regexp.QuoteMeta(
				"INSERT INTO `functions` (`created_at`,`updated_at`,`deleted_at`,`bash_id`,`name`,`content`) VALUES (?,?,?,?,?,?)")).
				WithArgs(AnyTime{}, AnyTime{}, nil, 1, "main", "    echo test").WillReturnResult(sqlmock.NewResult(1, 1))
			mock.ExpectCommit()

			_, errs := datastore.CreateScript(testCase.input[0], testCase.input[1])
			if len(errs) > 0 {
				t.Fatal(errs)
			}
			if err := mock.ExpectationsWereMet(); err != nil {
				t.Errorf("there were unfulfilled expectations: %s", err)
			}
		})
	}
}
