package tx

import (
	"bufio"

	"github.com/spf13/cobra"

	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/cosmos/cosmos-sdk/client/context"
	"github.com/cosmos/cosmos-sdk/codec"
	"github.com/cosmos/cosmos-sdk/x/auth"
	"github.com/cosmos/cosmos-sdk/x/auth/client/utils"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

const (
	// DefaultCoinPerRequest is the number of coins that will be sent per faucet request
	DefaultCoinPerRequest = 500
)

// GetPylons implements GetPylons msg transaction
func GetPylons(cdc *codec.Codec) *cobra.Command {
	var productID string
	var purchaseToken string
	var receiptData string
	var signature string
	ccb := &cobra.Command{
		Use:   "get-pylons",
		Short: "ask for pylons. get pylons per iap order",
		Args:  cobra.ExactArgs(0),
		RunE: func(cmd *cobra.Command, args []string) error {
			cliCtx := context.NewCLIContext().WithCodec(cdc)
			inBuf := bufio.NewReader(cmd.InOrStdin())
			txBldr := auth.NewTxBuilderFromCLI(inBuf).WithTxEncoder(utils.GetTxEncoder(cdc))

			msg := msgs.NewMsgGetPylons(
				productID,
				purchaseToken,
				receiptData,
				signature,
				cliCtx.GetFromAddress())
			err := msg.ValidateBasic()
			if err != nil {
				return err
			}

			return utils.GenerateOrBroadcastMsgs(cliCtx, txBldr, []sdk.Msg{msg})
		},
	}
	ccb.PersistentFlags().StringVar(&productID, "product-id", "", "Get pylons order product id")
	ccb.PersistentFlags().StringVar(&purchaseToken, "purchase-token", "", "Get pylons order purchase token")
	ccb.PersistentFlags().StringVar(&receiptData, "receipt-data", "", "Get pylons order purchase token")
	ccb.PersistentFlags().StringVar(&signature, "signature", "", "Get pylons order signature")
	return ccb
}
