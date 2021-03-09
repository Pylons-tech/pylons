package tx

import (
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/tx"

	"github.com/spf13/cobra"

	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// GoogleIAPGetPylons implements GoogleIAPGetPylons msg transaction
func GoogleIAPGetPylons() *cobra.Command {
	var productID string
	var purchaseToken string
	var receiptData string
	var signature string
	ccb := &cobra.Command{
		Use:   "get-pylons",
		Short: "ask for pylons. get pylons per iap order",
		Args:  cobra.ExactArgs(0),
		RunE: func(cmd *cobra.Command, args []string) error {
			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			msg := msgs.NewMsgGoogleIAPGetPylons(
				productID,
				purchaseToken,
				receiptData,
				signature,
				clientCtx.GetFromAddress())
			err = msg.ValidateBasic()
			if err != nil {
				return err
			}

			return tx.GenerateOrBroadcastTxCLI(clientCtx, cmd.Flags(), []sdk.Msg{&msg}...)
		},
	}
	ccb.PersistentFlags().StringVar(&productID, "product-id", "", "Get pylons order product id")
	ccb.PersistentFlags().StringVar(&purchaseToken, "purchase-token", "", "Get pylons order purchase token")
	ccb.PersistentFlags().StringVar(&receiptData, "receipt-data", "", "Get pylons order purchase token")
	ccb.PersistentFlags().StringVar(&signature, "signature", "", "Get pylons order signature")
	return ccb
}
