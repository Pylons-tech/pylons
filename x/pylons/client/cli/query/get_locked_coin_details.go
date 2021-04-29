package query

import (
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/spf13/cobra"
)

// GetLockedCoinDetails queries the locked coin with details
func GetLockedCoinDetails() *cobra.Command {
	var accAddr string
	cmd := &cobra.Command{
		Use:   "get_locked_coin_details",
		Short: "get locked coins with details for a user",
		Args:  cobra.ExactArgs(0),
		RunE: func(cmd *cobra.Command, args []string) error {
			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			queryClient := types.NewQueryClient(clientCtx)

			coinDetailsReq := &types.GetLockedCoinDetailsRequest{
				Address: accAddr,
			}

			res, err := queryClient.GetLockedCoinDetails(cmd.Context(), coinDetailsReq)
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
