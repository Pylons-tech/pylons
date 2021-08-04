package cli

import (
	"encoding/json"
	"strconv"

	"github.com/spf13/cobra"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/client/tx"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

var _ = strconv.Itoa(0)

func CmdExecuteRecipe() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "execute-recipe [cookbookID] [recipeID] [itemIDs]",
		Short: "Broadcast message execute-recipe",
		Args:  cobra.ExactArgs(3),
		RunE: func(cmd *cobra.Command, args []string) error {
			argsCookbookID := args[0]
			argsRecipeID := args[1]
			argsItemIDs := args[2]
			jsonArgsItemIDs := make([]string, 0)
			err := json.Unmarshal([]byte(argsItemIDs), &jsonArgsItemIDs)
			if err != nil {
				return err
			}

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			msg := types.NewMsgExecuteRecipe(clientCtx.GetFromAddress().String(), argsCookbookID, argsRecipeID, jsonArgsItemIDs)
			if err := msg.ValidateBasic(); err != nil {
				return err
			}
			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), msg)
		},
	}

	flags.AddTxFlagsToCmd(cmd)

	return cmd
}
