package cli

import (
	"fmt"

	"github.com/MikeSofaer/pylons/x/pylons"
	"github.com/cosmos/cosmos-sdk/client/context"
	"github.com/cosmos/cosmos-sdk/codec"
	"github.com/spf13/cobra"
)

// GetPylonsBalance queries the pylons balance
func GetPylonsBalance(queryRoute string, cdc *codec.Codec) *cobra.Command {
	return &cobra.Command{
		Use:   "balance",
		Short: "get pylons balance",
		Args:  cobra.ExactArgs(0),
		RunE: func(cmd *cobra.Command, args []string) error {
			cliCtx := context.NewCLIContext().WithCodec(cdc)
			addr := cliCtx.GetFromAddress()

			res, err := cliCtx.QueryWithData(fmt.Sprintf("custom/%s/balance/%s", queryRoute, addr), nil)
			if err != nil {
				fmt.Printf("could not get balance for - %s \n", addr)
				return nil
			}

			var out pylons.QueryResBalance
			cdc.MustUnmarshalJSON(res, &out)
			return cliCtx.PrintOutput(out)
		},
	}
}
