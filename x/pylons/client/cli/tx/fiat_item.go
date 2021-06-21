package tx

import (
	"encoding/json"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/spf13/cobra"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/client/tx"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// FiatItem is the client cli command for creating item
func FiatItem() *cobra.Command {
	var msgFI = &types.MsgFiatItem{}

	cmd := &cobra.Command{
		Use:   "fiat-item [args]",
		Short: "create item and assign it to sender",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}
			byteValue, err := ReadFile(args[0])
			if err != nil {
				return err
			}
			err = json.Unmarshal(byteValue, &msgFI)
			if err != nil {
				return err
			}

			msgFI.Sender = clientCtx.GetFromAddress().String()

			err = msgFI.ValidateBasic()
			if err != nil {
				return err
			}

			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), []sdk.Msg{msgFI}...)
		},
	}

	flags.AddTxFlagsToCmd(cmd)
	cmd.PersistentFlags().StringVar(&msgFI.CookbookID, "cookbookID", "", "The ID of the cookbook for this item")

	return cmd
}
