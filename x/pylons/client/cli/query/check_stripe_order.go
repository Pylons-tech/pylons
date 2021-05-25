package query

import (
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/spf13/cobra"
)

// CheckStripeOrder check if stripe iap order is already used
func CheckStripeOrder() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "check_stripe_order <payment_id> <payment_method>",
		Short: "check if stripe order is given to user with payment_id",
		Args:  cobra.ExactArgs(2),
		RunE: func(cmd *cobra.Command, args []string) error {
			clientCtx, err := client.GetClientQueryContext(cmd)
			if err != nil {
				return err
			}

			queryClient := types.NewQueryClient(clientCtx)

			if args[1] == "" {
				args[1] = "card"
			}

			paymentReq := &types.CheckStripeOrderRequest{
				PaymentId:     args[0],
				PaymentMethod: args[1],
			}

			res, err := queryClient.CheckStripeOrder(cmd.Context(), paymentReq)

			if err != nil {
				return err
			}
			return clientCtx.PrintProto(res)
		},
	}
	flags.AddQueryFlagsToCmd(cmd)
	return cmd
}
