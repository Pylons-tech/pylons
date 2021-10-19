package cli

import (
	"context"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/spf13/cobra"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func CmdGetAddressByUsername() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "get-address-by-username [username]",
		Short: "shows a pylons address corresponding to a pylons username",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			clientCtx := client.GetClientContextFromCmd(cmd)

			queryClient := types.NewQueryClient(clientCtx)

			params := &types.QueryGetAddressByUsernameRequest{
				Username: args[0],
			}

			res, err := queryClient.AddressByUsername(context.Background(), params)
			if err != nil {
				return err
			}

			return clientCtx.PrintProto(res)
		},
	}

	flags.AddQueryFlagsToCmd(cmd)

	return cmd
}

func CmdGetUsernameByAddress() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "get-username-by-address [address]",
		Short: "shows a pylons username corresponding to a cosmos address",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			clientCtx := client.GetClientContextFromCmd(cmd)

			queryClient := types.NewQueryClient(clientCtx)

			params := &types.QueryGetUsernameByAddressRequest{

				Address: args[0],
			}

			res, err := queryClient.UsernameByAddress(cmd.Context(), params)
			if err != nil {
				return err
			}

			return clientCtx.PrintProto(res)
		},
	}

	flags.AddQueryFlagsToCmd(cmd)

	return cmd
}
