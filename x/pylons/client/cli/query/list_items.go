package query

import (
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/spf13/cobra"
)

// ItemsBySender queries the items
func ItemsBySender() *cobra.Command {
	var accAddr string
	ccb := &cobra.Command{
		Use:   "items_by_sender",
		Short: "get all items for a user",
		Args:  cobra.ExactArgs(0),
		RunE: func(cmd *cobra.Command, args []string) error {
			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			queryClient := types.NewQueryClient(clientCtx)

			itemsReq := &types.ItemsBySenderRequest{
				Sender: accAddr,
			}

			res, err := queryClient.ItemsBySender(cmd.Context(), itemsReq)
			if err != nil {
				return err
			}

			return clientCtx.PrintProto(res)
		},
	}
	ccb.PersistentFlags().StringVar(&accAddr, "account", "", "address of user")
	return ccb
}
