package main

import (
	"os"

	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/server"
	"github.com/spf13/cobra"

	svrcmd "github.com/cosmos/cosmos-sdk/server/cmd"

	"github.com/Pylons-tech/pylons/app"
	pyloncmd "github.com/Pylons-tech/pylons/cmd/pylonsd/cmd"
)

func main() {
	rootCmd, _ := pyloncmd.NewRootCmd()
	rootCmd.Short = "Stargate Pylons App"
	rootCmd.AddCommand(pyloncmd.DevValidate())
	rootCmd.AddCommand(pyloncmd.DevCreate())
	rootCmd.AddCommand(pyloncmd.DevLoadTest())
	rootCmd.AddCommand(pyloncmd.Completion())
	removeLineBreaksInCobraArgs(rootCmd)

	if err := svrcmd.Execute(rootCmd, "PYLONSD", app.DefaultNodeHome); err != nil {
		switch e := err.(type) {
		case server.ErrorCode:
			os.Exit(e.Code)

		default:
			os.Exit(1)
		}
	}
}

// removeLineBreaksInCobraArgs recursively removes line breaks from a parent cobra command.
// The cosmos-sdk adds several line breaks in the commands tree, however cobra ends up printing commands in the help
// in alphabetical order, resulting in one or more blank lines at the top of commands lists
func removeLineBreaksInCobraArgs(cmd *cobra.Command) {
	cmd.RemoveCommand(flags.LineBreak)
	for _, c := range cmd.Commands() {
		removeLineBreaksInCobraArgs(c)
	}
}
