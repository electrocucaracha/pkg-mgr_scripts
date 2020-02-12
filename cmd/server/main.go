package main

import (
	"os"

	"github.com/electrocucaracha/pkg-mgr/cmd/server/app"
)

func main() {
	if err := app.Execute(); err != nil {
		os.Exit(1)
	}
}
