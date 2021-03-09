package query

import (
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/spf13/cobra"
)

// GetTrade get an execution by GUID
func GetTrade() *cobra.Command {
	ccb := &cobra.Command{
		Use:   "get_trade <id>",
		Short: "get a trade by id",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			queryClient := types.NewQueryClient(clientCtx)

			tradeReq := &types.GetTradeRequest{
				TradeID: args[0],
			}

			res, err := queryClient.GetTrade(cmd.Context(), tradeReq)
			if err != nil {
				return err
			}

			return clientCtx.PrintProto(res)
		},
	}
	return ccb
}
