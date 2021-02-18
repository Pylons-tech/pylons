package query

import (
	"fmt"
	"github.com/Workiva/go-datastructures/threadsafe/err"
	"github.com/cosmos/cosmos-sdk/client"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client/context"
	"github.com/cosmos/cosmos-sdk/codec"
	"github.com/spf13/cobra"
)

// GetItem get an item by GUID
func GetItem(queryRoute string) *cobra.Command {
	ccb := &cobra.Command{
		Use:   "get_item <id>",
		Short: "get an item by id",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			cliCtx := context.NewCLIContext().WithCodec(cdc)
			clientCtx := client.GetClientContextFromCmd(cmd)

			res, _, err := cliCtx.QueryWithData(fmt.Sprintf("custom/%s/get_item/%s", queryRoute, args[0]), nil)
			if err != nil {
				return fmt.Errorf(err.Error())
			}

			var out types.Item
			cdc.MustUnmarshalJSON(res, &out)
			return cliCtx.PrintOutput(out)
		},
	}
	return ccb
}
