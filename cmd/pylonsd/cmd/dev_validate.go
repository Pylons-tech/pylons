package cmd

import (
	"fmt"

	"github.com/spf13/cobra"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func DevValidate() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "validate [path]",
		Short: "Validates all Pylons recipe or cookbook files in the provided path",
		Args:  cobra.ExactArgs(1),
		Run: func(cmd *cobra.Command, args []string) {
			path := args[0]
			ForFiles(path, perCookbook, perRecipe)
		},
	}
	return cmd
}

func perCookbook(path string, _ types.Cookbook) {
	fmt.Fprintln(Out, path, "is a valid cookbook")
}

func perRecipe(path string, _ types.Recipe) {
	fmt.Fprintln(Out, path, "is a valid recipe")
}
