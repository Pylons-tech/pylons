package query

import (
	"github.com/spf13/cobra"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// ItemsBySender queries the items
func ItemsBySender() *cobra.Command {
	var accAddr string
	cmd := &cobra.Command{
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

	cmd.PersistentFlags().StringVar(&accAddr, "account", "", "address of user")
	flags.AddQueryFlagsToCmd(cmd)
	return cmd
}
