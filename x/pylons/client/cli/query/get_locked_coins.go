package query

import (
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/spf13/cobra"
)

// GetLockedCoins queries the locked coins
func GetLockedCoins() *cobra.Command {
	var accAddr string
	ccb := &cobra.Command{
		Use:   "get_locked_coins",
		Short: "get locked coins for a user",
		Args:  cobra.ExactArgs(0),
		RunE: func(cmd *cobra.Command, args []string) error {
			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			queryClient := types.NewQueryClient(clientCtx)

			coinDetailsReq := &types.GetLockedCoinsRequest{
				Address: accAddr,
			}

			res, err := queryClient.GetLockedCoins(cmd.Context(), coinDetailsReq)
			if err != nil {
				return err
			}

			return clientCtx.PrintProto(res)
			return nil
		},
	}
	ccb.PersistentFlags().StringVar(&accAddr, "account", "", "address of user")
	return ccb
}
