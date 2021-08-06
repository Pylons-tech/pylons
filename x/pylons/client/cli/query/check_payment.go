package query

import (
	"github.com/spf13/cobra"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// CheckPayment check if google iap order is already used
func CheckPayment() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "check_google_iap_order <purchase_token>",
		Short: "check if google iap order is given to user with purchase token",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			clientCtx, err := client.GetClientQueryContext(cmd)
			if err != nil {
				return err
			}

			queryClient := types.NewQueryClient(clientCtx)

			paymentReq := &types.CheckPaymentRequest{
				PaymentID: args[0],
			}

			res, err := queryClient.CheckPayment(cmd.Context(), paymentReq)
			if err != nil {
				return err
			}

			return clientCtx.PrintProto(res)
		},
	}

	flags.AddQueryFlagsToCmd(cmd)
	return cmd
}
