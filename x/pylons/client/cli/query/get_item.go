package query

import (
	"fmt"
	"github.com/cosmos/cosmos-sdk/client"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/spf13/cobra"
)

// GetItem get an item by GUID
func GetItem() *cobra.Command {
	ccb := &cobra.Command{
		Use:   "get_item <id>",
		Short: "get an item by id",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			queryClient := types.NewQueryClient(clientCtx)

			itemReq := &types.GetItemRequest{
				ItemID: args[0],
			}

			res, err := queryClient.GetItem(cmd.Context(), itemReq)
			if err != nil {
				return err
			}

			return clientCtx.PrintString(fmt.Sprintf(
				"NodeVersion: %s \nID: %s \nDoubles: %s \nLongs: %s \nStrings: %s \nCookbookID: %s \nSender: %s \nOwnerRecipeID: %s \nOwnerTradeID: %s \nTradable: %t \nLastUpdate: %d \nTransferFee: %d",
				res.Item.NodeVersion,
				res.Item.ID,
				res.Item.Doubles,
				res.Item.Longs,
				res.Item.Strings,
				res.Item.CookbookID,
				res.Item.Sender,
				res.Item.OwnerRecipeID,
				res.Item.OwnerTradeID,
				res.Item.Tradable,
				res.Item.LastUpdate,
				res.Item.TransferFee,
			))
		},
	}
	return ccb
}
