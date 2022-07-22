package cli

import (
	"context"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/spf13/cobra"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func CmdListReferralsByAddress() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "get-referrals-by-address [address]",
		Short: "retrieve all signed up user with referral by an address",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			clientCtx := client.GetClientContextFromCmd(cmd)

			queryClient := types.NewQueryClient(clientCtx)

			addr := args[0]

			params := &types.QueryListSignUpByReferee{
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
