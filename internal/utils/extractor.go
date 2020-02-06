package utils

import (
	"regexp"

	log "github.com/sirupsen/logrus"
)

func ExtractFunctions(instructionSet string) (result map[string]string, err error) {
	log.WithFields(log.Fields{
		"instructionSet": instructionSet,
	}).Debug("Extracting functions from the instruction set")
	result = make(map[string]string)

	re := regexp.MustCompile(`(?m)^function (?P<name>.*) {\n(?P<content>(.|\n)*?)\n}\n$`)
	for _, submatch := range re.FindAllStringSubmatch(instructionSet, -1) {
		log.WithFields(log.Fields{
			"function":     submatch[1],
			"instructions": submatch[2],
		}).Debug("Function found")
		result[submatch[1]] = submatch[2]
	}

	return
}
