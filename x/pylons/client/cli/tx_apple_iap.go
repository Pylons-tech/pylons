package cli

import (
	"strconv"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/client/tx"
	"github.com/spf13/cobra"
)

var _ = strconv.Itoa(0)

func CmdAppleIap() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "apple-iap [productID] [purchaseID] [receiptDataBase64] [token]",
		Short: "Get Coins Using Apple In App Purchase",
		Args:  cobra.ExactArgs(4),
		RunE: func(cmd *cobra.Command, args []string) (err error) {
			argsProductID := args[0]
			argsPurchaseID := args[1]
			argsReceiptDataBase64 := args[2]

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			msg := types.NewMsgAppleIap(
				clientCtx.GetFromAddress().String(),
				argsProductID,
				argsPurchaseID,
				argsReceiptDataBase64,
			)
			if err := msg.ValidateBasic(); err != nil {
				return err
			}
			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), msg)
		},
	}

	flags.AddTxFlagsToCmd(cmd)

	return cmd
}
