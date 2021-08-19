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

// TODO
// GoogleIAPGetFromCoinIssuer()
// get coins using IAP from any valid CoinIssuer
// the CoinIssuer's coins will be given to the Tx creator in exchange for USD
func CmdGoogleInAppPurchaseGetPylons() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "google-iap-get-pylons [productID] [purchaseToken] [recieptDataBase64] [signature]",
		Short: "Buy pylons using Google IAP",
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

			msg := types.NewMsgGoogleIAPGetPylons(clientCtx.GetFromAddress().String(), argsProductID, argsPurchaseToken, argsRecieptDataBase64, argsSignature)
			if err := msg.ValidateBasic(); err != nil {
				return err
			}
			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), msg)
		},
	}

	flags.AddTxFlagsToCmd(cmd)

	return cmd
}
