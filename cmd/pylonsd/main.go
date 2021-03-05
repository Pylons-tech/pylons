package main

import (
	"os"

	"github.com/Pylons-tech/pylons/app"
	"github.com/Pylons-tech/pylons/cmd/pylonsd/cmd"
	svrcmd "github.com/cosmos/cosmos-sdk/server/cmd"
)

func main() {
	rootCmd, _ := cmd.NewRootCmd()
	if err := svrcmd.Execute(rootCmd, app.DefaultNodeHome); err != nil {
		os.Exit(1)
	}
}
