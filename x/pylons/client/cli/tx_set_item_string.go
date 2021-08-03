package cli

import (
	"strconv"

	"github.com/spf13/cobra"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/client/tx"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

var _ = strconv.Itoa(0)

func CmdSetItemString() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "set-item-string [cookbookID] [recipeID] [id] [field] [value]",
		Short: "Set a mutable string field within an item",
		Args:  cobra.ExactArgs(5),
		RunE: func(cmd *cobra.Command, args []string) error {
			argsCookbookID := args[0]
			argsRecipeID := args[1]
			argsID := args[2]
			argsField := args[3]
			argsValue := args[4]

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			msg := types.NewMsgSetItemString(clientCtx.GetFromAddress().String(), argsCookbookID, argsRecipeID, argsID, argsField, argsValue)
			if err := msg.ValidateBasic(); err != nil {
				return err
			}
			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), msg)
		},
	}

	flags.AddTxFlagsToCmd(cmd)

	return cmd
}
