package cli

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/spf13/cobra"
)

func CmdGetAddressByUsername() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "get-address-by-username [username]",
		Short: "retrieve pylons address corresponding to username",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			clientCtx := client.GetClientContextFromCmd(cmd)

			queryClient := v1beta1.NewQueryClient(clientCtx)

			params := &v1beta1.QueryGetAddressByUsernameRequest{
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
		Short: "retrieve username corresponding to pylons address",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			clientCtx := client.GetClientContextFromCmd(cmd)

			queryClient := v1beta1.NewQueryClient(clientCtx)

			params := &v1beta1.QueryGetUsernameByAddressRequest{
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
