package cli

import (
	"context"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/spf13/cobra"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func CmdGetAccountByUsername() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "get-account-by-username [username]",
		Short: "shows a pylons account corresponding to a pylons username",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			clientCtx := client.GetClientContextFromCmd(cmd)

			queryClient := types.NewQueryClient(clientCtx)

			params := &types.QueryGetAccountByUsernameRequest{
				Username: args[0],
			}

			res, err := queryClient.PylonsAccountByUsername(context.Background(), params)
			if err != nil {
				return err
			}

			return clientCtx.PrintProto(res)
		},
	}

	flags.AddQueryFlagsToCmd(cmd)

	return cmd
}

func CmdGetAccountByAddress() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "get-account-by-address [address]",
		Short: "shows a pylons account corresponding to a cosmos address",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {

			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			queryClient := types.NewQueryClient(clientCtx)

			params := &types.QueryGetAccountByAddressRequest{

				Address: args[0],
			}

			res, err := queryClient.PylonsAccountByAddress(cmd.Context(), params)
			if err != nil {
				return err
			}

			return clientCtx.PrintProto(res)
		},
	}

	flags.AddQueryFlagsToCmd(cmd)

	return cmd
}
