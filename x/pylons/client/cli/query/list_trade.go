package query

import (
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/spf13/cobra"
)

// ListTrade queries the trades
func ListTrade() *cobra.Command {
	var accAddr string
	ccb := &cobra.Command{
		Use:   "list_trade",
		Short: "get all trades for a user",
		Args:  cobra.ExactArgs(0),
		RunE: func(cmd *cobra.Command, args []string) error {
			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			queryClient := types.NewQueryClient(clientCtx)

			tradeReq := &types.ListTradeRequest{
				Address: accAddr,
			}

			res, err := queryClient.ListTrade(cmd.Context(), tradeReq)
			if err != nil {
				return err
			}

			return clientCtx.PrintProto(res)
		},
	}
	ccb.PersistentFlags().StringVar(&accAddr, "account", "", "address of user")
	return ccb
}
