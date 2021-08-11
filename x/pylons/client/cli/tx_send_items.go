package cli

import (
	"strconv"
	"strings"

	"github.com/spf13/cobra"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/client/tx"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

var _ = strconv.Itoa(0)

func CmdSendItems() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "send-items [receiver] [cookbookID] [recipeID] [itemIDs]",
		Short: "send items to receiver",
		Args:  cobra.ExactArgs(4),
		RunE: func(cmd *cobra.Command, args []string) error {
			argsReceiver := args[0]

			argsCookbookID := args[1]
			argsRecipeID := args[2]

			// convert "ID0 ID1 ID2" to [ID0, ID1, ID2]
			argsItemIDsStr := args[3]
			argsItemIDs := strings.Fields(argsItemIDsStr)

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			msg := types.NewMsgSendItems(clientCtx.GetFromAddress().String(), argsReceiver, argsCookbookID, argsRecipeID, argsItemIDs)
			if err := msg.ValidateBasic(); err != nil {
				return err
			}
			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), msg)
		},
	}

	flags.AddTxFlagsToCmd(cmd)

	return cmd
}
