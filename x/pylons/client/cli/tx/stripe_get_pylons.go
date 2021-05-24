package tx

import (
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/client/tx"

	"github.com/spf13/cobra"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// StripeGetPylons implements StripeGetPylons msg transaction
func StripeGetPylons() *cobra.Command {
	var productID string
	var paymentId string
	var paymentMethod string
	var receiptData string
	var signature string
	cmd := &cobra.Command{
		Use:   "get-pylons",
		Short: "ask for pylons. get pylons per iap order",
		Args:  cobra.ExactArgs(0),
		RunE: func(cmd *cobra.Command, args []string) error {
			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			msg := types.NewMsgStripeGetPylons(
				productID,
				paymentId,
				paymentMethod,
				receiptData,
				signature,
				clientCtx.GetFromAddress().String())
			err = msg.ValidateBasic()
			if err != nil {
				return err
			}

			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), []sdk.Msg{&msg}...)
		},
	}
	flags.AddTxFlagsToCmd(cmd)
	cmd.PersistentFlags().StringVar(&productID, "product-id", "", "Get pylons order product id")
	cmd.PersistentFlags().StringVar(&paymentId, "payment-id", "", "Get pylons order payment id")
	cmd.PersistentFlags().StringVar(&paymentMethod, "payment-method", "", "Get pylons order payment method")
	cmd.PersistentFlags().StringVar(&receiptData, "receipt-data", "", "Get pylons order purchase token")
	cmd.PersistentFlags().StringVar(&signature, "signature", "", "Get pylons order signature")
	return cmd
}
