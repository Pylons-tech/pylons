package cli

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/spf13/cobra"
)

func CmdListReferralsByAddress() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "get-referrals-by-address [address]",
		Short: "retrieve all signed up user with referral by an address",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			clientCtx := client.GetClientContextFromCmd(cmd)

			queryClient := v1beta1.NewQueryClient(clientCtx)

			addr := args[0]

			params := &v1beta1.QueryListSignUpByReferee{
				Creator: addr,
			}

			res, err := queryClient.ListSignUpByReferee(context.Background(), params)
			if err != nil {
				return err
			}

			return clientCtx.PrintProto(res)
		},
	}

	flags.AddQueryFlagsToCmd(cmd)

	return cmd
}
