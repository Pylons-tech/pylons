package query

import (
	"fmt"

	"github.com/MikeSofaer/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client/context"
	"github.com/cosmos/cosmos-sdk/codec"
	"github.com/spf13/cobra"
)

// ListTrade queries the trades
func ListTrade(queryRoute string, cdc *codec.Codec) *cobra.Command {
	var accAddr string
	ccb := &cobra.Command{
		Use:   "list_trade",
		Short: "get all trades for a user",
		Args:  cobra.ExactArgs(0),
		RunE: func(cmd *cobra.Command, args []string) error {
			cliCtx := context.NewCLIContext().WithCodec(cdc)

			res, err := cliCtx.QueryWithData(fmt.Sprintf("custom/%s/list_trade/%s", queryRoute, accAddr), nil)
			if err != nil {
				return fmt.Errorf(err.Error())
			}

			var out types.TradeList
			cdc.MustUnmarshalJSON(res, &out)
			return cliCtx.PrintOutput(out)
		},
	}
	ccb.PersistentFlags().StringVar(&accAddr, "account", "", "address of user")
	return ccb
}
