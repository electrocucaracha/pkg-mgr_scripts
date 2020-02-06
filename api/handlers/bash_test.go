package handlers

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"net/http/httptest"
	"reflect"
	"testing"

	"github.com/electrocucaracha/pkg-mgr/gen/restapi"
	"github.com/electrocucaracha/pkg-mgr/gen/restapi/operations"
	"github.com/electrocucaracha/pkg-mgr/internal/models"
	"github.com/go-openapi/loads"
	"github.com/jinzhu/gorm"
)

var testserver *httptest.Server

type mockDB struct {
	*gorm.DB
	Item *models.Bash
	Err  error
}

func (db *mockDB) GetScript(pkg string) (*models.Bash, error) {
	if db.Err != nil {
		return nil, db.Err
	}
	if db.Item.Pkg == pkg {
		return db.Item, nil
	}

	return nil, nil
}

func (db *mockDB) CreateScript(pkg, instructionSet string) (*models.Bash, []error) {
	return nil, nil
}

func TestGetScriptHandler(t *testing.T) {
	testCases := []struct {
		label            string
		queryParams      map[string]string
		mockDatastore    models.Datastore
		expectedCode     int
		expectedResponse []byte
	}{
		{
			label:         "Fail to pass request params",
			mockDatastore: &mockDB{},
			expectedCode:  http.StatusUnprocessableEntity,
		},
		{
			label: "Fail to find the desired package",
			queryParams: map[string]string{
				"pkg": "mock_pkg",
			},
			mockDatastore: &mockDB{
				Item: &models.Bash{
					Pkg: "mock_pkg2",
				},
			},
			expectedCode: http.StatusNotFound,
		},
		{
			label: "Get an existing bash script sucessfully",
			queryParams: map[string]string{
				"pkg": "mock_pkg",
			},
			mockDatastore: &mockDB{
				Item: &models.Bash{
					Pkg: "mock_pkg",
					Functions: []models.Function{models.Function{
						Name:    "main",
						Content: "echo test",
					}},
				},
			},
			expectedCode:     http.StatusOK,
			expectedResponse: []byte(fmt.Sprintf("%s\n\n%s\n\nfunction main { \necho test\n}\n\nmain", header, setters)),
		},
	}

	for _, testCase := range testCases {
		uri := "/pkgInstall"

		t.Run(testCase.label, func(t *testing.T) {
			swaggerSpec, err := loads.Analyzed(restapi.SwaggerJSON, "")
			if err != nil {
				t.Fatal(err)
			}
			api := operations.NewPkgMgrAPI(swaggerSpec)
			api.GetScriptHandler = NewGetBash(testCase.mockDatastore)
			err = api.Validate()
			if err != nil {
				t.Fatal(err)
			}
			server := restapi.NewServer(api)
			server.ConfigureAPI()

			handler, _ := api.HandlerFor(http.MethodGet, uri)
			testserver = httptest.NewServer(handler)
			defer testserver.Close()

			request := httptest.NewRequest(http.MethodGet, uri, nil)
			if testCase.queryParams != nil {
				q := request.URL.Query()
				for k, v := range testCase.queryParams {
					q.Add(k, v)
				}
				request.URL.RawQuery = q.Encode()
			}
			if err != nil {
				t.Fatal(err)
			}
			recorder := httptest.NewRecorder()
			handler.ServeHTTP(recorder, request)

			if testCase.expectedCode != recorder.Code {
				t.Fatalf("Request method returned code: \n%v\n and it was expected: \n%v", recorder.Code, testCase.expectedCode)
			}
			body, _ := ioutil.ReadAll(recorder.Body)
			t.Log(string(body))
			if testCase.expectedResponse != nil && !reflect.DeepEqual(testCase.expectedResponse, body) {
				t.Fatalf("Request method returned body: \n%s\n and it was expected: \n%s", body, testCase.expectedResponse)
			}

		})
	}
	// do some requests to testserver.URL
	// assert.Equal(t, 201, response.StatusCode, "Great success")
}
