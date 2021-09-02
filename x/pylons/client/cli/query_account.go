package cli

import (
	"context"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/spf13/cobra"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func CmdShowAccount() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "show-account [username]",
		Short: "shows a cosmos account corresponding to a pylons username",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			clientCtx := client.GetClientContextFromCmd(cmd)

			queryClient := types.NewQueryClient(clientCtx)

			params := &types.QueryGetAccountRequest{
				Username: args[0],
			}

			res, err := queryClient.PylonsAccount(context.Background(), params)
			if err != nil {
				return err
			}

			return clientCtx.PrintProto(res)
		},
	}

	flags.AddQueryFlagsToCmd(cmd)

	return cmd
}
