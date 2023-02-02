package cmd

import (
	"github.com/spf13/cobra"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func DevParse() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "parse [path]",
		Short: "Parses all Pylons recipe or cookbook files in the provided path and processes macros",
		Args:  cobra.ExactArgs(1),
		Run: func(cmd *cobra.Command, args []string) {
			path := args[0]
			// This is slightly goofy but it's the fastest/least invasive way to implement this behavior right now.
			// We just set a flag to output the assembled JSON and then let the batch handler run with empty callbacks.
			// Down the road it'd be nice to have something a little nicer, but this is enough as-is to make debugging more
			// manageable.
			Verbose = true
			ForFiles(path, func(path string, cookbook types.Cookbook) {}, func(path string, recipe types.Recipe) {})
		},
	}
	return cmd
}
