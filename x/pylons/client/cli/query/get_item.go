package query

import (
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"

	"github.com/spf13/cobra"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// GetItem get an item by GUID
func GetItem() *cobra.Command {
	cmd := &cobra.Command{
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

			return clientCtx.PrintProto(&res.Item)
		},
	}

	flags.AddQueryFlagsToCmd(cmd)
	return cmd
}
