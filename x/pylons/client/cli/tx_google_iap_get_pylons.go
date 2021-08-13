package cli

import (
	"github.com/spf13/cobra"
	"strconv"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/client/tx"
)

var _ = strconv.Itoa(0)

func CmdGoogleIAPGetPylons() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "google-iap-get-pylons [productID] [purchaseToken] [recieptDataBase64] [signature]",
		Short: "Buy pylons using Google IAP",
		Args:  cobra.ExactArgs(4),
		RunE: func(cmd *cobra.Command, args []string) error {
			argsProductID := string(args[0])
			argsPurchaseToken := string(args[1])
			argsRecieptDataBase64 := string(args[2])
			argsSignature := string(args[3])

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			msg := types.NewMsgGoogleIAPGetPylons(clientCtx.GetFromAddress().String(), string(argsProductID), string(argsPurchaseToken), string(argsRecieptDataBase64), string(argsSignature))
			if err := msg.ValidateBasic(); err != nil {
				return err
			}
			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), msg)
		},
	}

	flags.AddTxFlagsToCmd(cmd)

	return cmd
}
