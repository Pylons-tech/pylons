package query

import (
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client/context"
	"github.com/cosmos/cosmos-sdk/codec"
	"github.com/spf13/cobra"
)

// ListLockedCoinDetails queries the locked coin with details
func ListLockedCoinDetails(queryRoute string, cdc *codec.Codec) *cobra.Command {
	var accAddr string
	ccb := &cobra.Command{
		Use:   "list_locked_coin_details",
		Short: "get locked coins with details for a user",
		Args:  cobra.ExactArgs(0),
		RunE: func(cmd *cobra.Command, args []string) error {
			cliCtx := context.NewCLIContext().WithCodec(cdc)

			res, _, err := cliCtx.QueryWithData(fmt.Sprintf("custom/%s/list_locked_coin_details/%s", queryRoute, accAddr), nil)
			if err != nil {
				return fmt.Errorf(err.Error())
			}

			var out types.LockedCoinDetails
			cdc.MustUnmarshalJSON(res, &out)
			return cliCtx.PrintOutput(out)
		},
	}
	ccb.PersistentFlags().StringVar(&accAddr, "account", "", "address of user")
	return ccb
}
