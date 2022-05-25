package main

import (
	"os"

	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/spf13/cobra"

	svrcmd "github.com/cosmos/cosmos-sdk/server/cmd"
	"github.com/tendermint/spm/cosmoscmd"

	"github.com/Pylons-tech/pylons/app"
)

func main() {
	rootCmd, _ := cosmoscmd.NewRootCmd(
		app.Name,
		app.AccountAddressPrefix,
		app.DefaultNodeHome,
		app.Name,
		app.ModuleBasics,
		app.New,
		// this line is used by starport scaffolding # root/arguments
	)
	rootCmd.Short = "Stargate Pylons App"
	rootCmd.AddCommand() //Completion())
	removeLineBreaksInCobraArgs(rootCmd)
	if err := svrcmd.Execute(rootCmd, app.DefaultNodeHome); err != nil {
		os.Exit(1)
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
