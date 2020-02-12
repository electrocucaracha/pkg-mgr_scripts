package app

import (
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"

	log "github.com/sirupsen/logrus"
	"github.com/spf13/cobra"

	"github.com/electrocucaracha/pkg-mgr/api/handlers"
)

func init() {
	rootCmd.AddCommand(initCmd)
}

var initCmd = &cobra.Command{
	Use:   "init",
	Short: "Initialize Database models",
	Long:  `Creates and populates the database selected with the initial bash scripts`,
	Run: func(cmd *cobra.Command, args []string) {
		log.Println("Database Init...")
		if err := filepath.Walk(cfg.ScriptsPath, func(path string, info os.FileInfo, err error) error {
			if strings.Contains(path, "main.sh") {
				if err := register(path, filepath.Base(filepath.Dir(path))); err != nil {
					return err
				}
			}

			return nil
		}); err != nil {
			log.Error(err)
		}
		if err := register(cfg.MainFile, handlers.MainBashPackage); err != nil {
			log.Error(err)
		}
	},
}

func register(path, pkg string) error {
	instructionSet, err := readBashFile(path)
	if err != nil {
		return err
	}

	_, errs := datastore.CreateScript(pkg, instructionSet)
	if len(errs) > 0 {
		return errs[0]
	}

	return nil
}

func readBashFile(path string) (string, error) {
	file, err := os.Open(path)
	if err != nil {
		return "", err
	}
	defer file.Close()

	b, err := ioutil.ReadAll(file)
	if err != nil {
		return "", err
	}

	var builder strings.Builder
	builder.Grow(len(b))
	builder.Write(b)

	return builder.String(), nil
}
