package cli

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/spf13/cobra"
)

func CmdListPaymentInfo() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "list-payment-info",
		Short: "list all PaymentInfo",
		RunE: func(cmd *cobra.Command, args []string) error {
			clientCtx := client.GetClientContextFromCmd(cmd)

			pageReq, err := client.ReadPageRequest(cmd.Flags())
			if err != nil {
				return err
			}

			queryClient := v1beta1.NewQueryClient(clientCtx)

			params := &v1beta1.QueryAllPaymentInfoRequest{
				Pagination: pageReq,
			}

			res, err := queryClient.PaymentInfoAll(context.Background(), params)
			if err != nil {
				return err
			}

			return clientCtx.PrintProto(res)
		},
	}

	flags.AddPaginationFlagsToCmd(cmd, cmd.Use)
	flags.AddQueryFlagsToCmd(cmd)

	return cmd
}

func CmdShowPaymentInfo() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "get-payment-info [purchase-id]",
		Short: "retrieve PaymentInfo by ID",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			clientCtx := client.GetClientContextFromCmd(cmd)

			queryClient := v1beta1.NewQueryClient(clientCtx)

			params := &v1beta1.QueryGetPaymentInfoRequest{
				PurchaseId: args[0],
			}

			res, err := queryClient.PaymentInfo(context.Background(), params)
			if err != nil {
				return err
			}

			return clientCtx.PrintProto(res)
		},
	}

	flags.AddQueryFlagsToCmd(cmd)

	return cmd
}
