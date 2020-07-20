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
	var orderID string
	var packageName string
	var productID string
	var purchaseTime int64
	var purchaseState int64
	var PurchaseToken string
	ccb := &cobra.Command{
		Use:   "get-pylons",
		Short: "ask for pylons. get pylons per iap order",
		Args:  cobra.ExactArgs(0),
		RunE: func(cmd *cobra.Command, args []string) error {
			cliCtx := context.NewCLIContext().WithCodec(cdc)
			inBuf := bufio.NewReader(cmd.InOrStdin())
			txBldr := auth.NewTxBuilderFromCLI(inBuf).WithTxEncoder(utils.GetTxEncoder(cdc))

			msg := msgs.NewMsgGetPylons(
				orderID,
				packageName,
				productID,
				purchaseTime,
				purchaseState,
				PurchaseToken,
				cliCtx.GetFromAddress())
			err := msg.ValidateBasic()
			if err != nil {
				return err
			}

			return utils.GenerateOrBroadcastMsgs(cliCtx, txBldr, []sdk.Msg{msg})
		},
	}
	ccb.PersistentFlags().StringVar(&orderID, "order-id", "", "Get pylons order id")
	ccb.PersistentFlags().StringVar(&packageName, "package-name", "", "Get pylons order pacakge name")
	ccb.PersistentFlags().StringVar(&productID, "product-id", "", "Get pylons order product id")
	ccb.PersistentFlags().Int64Var(&purchaseTime, "purchase-time", 0, "Get pylons order purchase time")
	ccb.PersistentFlags().Int64Var(&purchaseState, "purchase-state", 0, "Get pylons order purchase state")
	ccb.PersistentFlags().StringVar(&PurchaseToken, "purchase-token", "", "Get pylons order purchase token")
	return ccb
}
