package query

import (
	"fmt"
	"github.com/cosmos/cosmos-sdk/client"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/spf13/cobra"
)

// GetItem get an item by GUID
func GetItem(queryRoute string) *cobra.Command {
	ccb := &cobra.Command{
		Use:   "get_item <id>",
		Short: "get an item by id",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			clientCtx := client.GetClientContextFromCmd(cmd)

			res, _, err := clientCtx.QueryWithData(fmt.Sprintf("custom/%s/get_item/%s", queryRoute, args[0]), nil)
			if err != nil {
				return fmt.Errorf(err.Error())
			}

			var out types.Item
			clientCtx.LegacyAmino.MustUnmarshalJSON(res, &out)
			return clientCtx.PrintObjectLegacy(out)
		},
	}
	return ccb
}
