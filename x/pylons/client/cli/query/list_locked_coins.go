package query

import (
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client/context"
	"github.com/cosmos/cosmos-sdk/codec"
	"github.com/spf13/cobra"
)

// GetLockedCoins queries the locked coins
func GetLockedCoins(queryRoute string, cdc *codec.Codec) *cobra.Command {
	var accAddr string
	ccb := &cobra.Command{
		Use:   "get_locked_coins",
		Short: "get locked coins for a user",
		Args:  cobra.ExactArgs(0),
		RunE: func(cmd *cobra.Command, args []string) error {
			cliCtx := context.NewCLIContext().WithCodec(cdc)

			res, _, err := cliCtx.QueryWithData(fmt.Sprintf("custom/%s/get_locked_coins/%s", queryRoute, accAddr), nil)
			if err != nil {
				return fmt.Errorf(err.Error())
			}

			var out types.LockedCoin
			cdc.MustUnmarshalJSON(res, &out)
			return cliCtx.PrintOutput(out)
		},
	}
	ccb.PersistentFlags().StringVar(&accAddr, "account", "", "address of user")
	return ccb
}
