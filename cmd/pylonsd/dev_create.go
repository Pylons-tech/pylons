package main

import (
	"fmt"

	"github.com/spf13/cobra"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func CmdDevCreate() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "create [account] [path]",
		Short: "Creates and executes creation transactions Pylons recipe or cookbook files in the provided path, using credentials of provided account",
		Args:  cobra.ExactArgs(2),
		Run: func(cmd *cobra.Command, args []string) {
			account := args[0]
			path := args[1]
			ForFiles(path, perCookbook_Create, perRecipe_Create) // this can't work as-is, we need to use account credentials to generate anonymous functions
		},
	}
	return cmd
}

func perCookbook_Create(path string, _ types.Cookbook) {
	fmt.Fprintln(Out, path, "is a valid cookbook")
}

func perRecipe_Create(path string, _ types.Recipe) {
	fmt.Fprintln(Out, path, "is a valid recipe")
}
