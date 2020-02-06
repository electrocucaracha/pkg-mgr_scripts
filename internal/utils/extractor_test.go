package utils

import (
	"reflect"
	"testing"
)

func TestExtractFunctions(t *testing.T) {
	testCases := []struct {
		label            string
		input            string
		expectedResponse map[string]string
	}{
		{
			label:            "No functions included",
			input:            "test",
			expectedResponse: map[string]string{},
		},
		{
			label: "Extract functions successfully",
			input: `#!/bin/bash

function test {
    echo test
}

function main {
    test
    sudo tee /etc/docker/daemon.json << EOF
{
  "key" : "value"
}
EOF
}

main`,
			expectedResponse: map[string]string{
				"main": `    test
    sudo tee /etc/docker/daemon.json << EOF
{
  "key" : "value"
}
EOF`,
				"test": "    echo test",
			},
		},
	}
	for _, testCase := range testCases {
		t.Run(testCase.label, func(t *testing.T) {
			response, err := ExtractFunctions(testCase.input)
			if err != nil {
				t.Fatal(err)
			}
			if testCase.expectedResponse != nil && !reflect.DeepEqual(testCase.expectedResponse, response) {
				t.Fatalf("ExtractFunctions method returned response: \n%v\n and it was expected: \n%v", response, testCase.expectedResponse)
			}
		})
	}
}
