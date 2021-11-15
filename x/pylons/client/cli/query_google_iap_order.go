package cli

import (
	"context"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/spf13/cobra"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func CmdShowGoogleIAPOrder() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "get-google-iap-order [purchase-token]",
		Short: "retrieve Google IAP order",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			clientCtx := client.GetClientContextFromCmd(cmd)

			queryClient := types.NewQueryClient(clientCtx)

			params := &types.QueryGetGoogleInAppPurchaseOrderRequest{
				PurchaseToken: args[0],
			}

			res, err := queryClient.GoogleInAppPurchaseOrder(context.Background(), params)
			if err != nil {
				return err
			}

			return clientCtx.PrintProto(res)
		},
	}

	flags.AddQueryFlagsToCmd(cmd)

	return cmd
}
