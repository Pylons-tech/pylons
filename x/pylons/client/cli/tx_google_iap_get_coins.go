package cli

import (
	"strconv"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	"github.com/spf13/cobra"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/client/tx"
)

var _ = strconv.Itoa(0)

func CmdGoogleInAppPurchaseGetCoins() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "google-iap-get-coins [productID] [purchaseToken] [recieptDataBase64] [signature]",
		Short: "get coins using Google IAP",
		Args:  cobra.ExactArgs(4),
		RunE: func(cmd *cobra.Command, args []string) error {
			argsProductID := args[0]
			argsPurchaseToken := args[1]
			argsRecieptDataBase64 := args[2]
			argsSignature := args[3]

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			msg := v1beta1.NewMsgGoogleIAPGetCoins(clientCtx.GetFromAddress().String(), argsProductID, argsPurchaseToken, argsRecieptDataBase64, argsSignature)
			if err := msg.ValidateBasic(); err != nil {
				return err
			}
			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), msg)
		},
	}

	flags.AddTxFlagsToCmd(cmd)

	return cmd
}
