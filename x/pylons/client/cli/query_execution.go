package cli

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/spf13/cobra"
)

func CmdShowExecution() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "get-execution [id]",
		Short: "retrieve execution by ID",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			clientCtx := client.GetClientContextFromCmd(cmd)

			queryClient := v1beta1.NewQueryClient(clientCtx)

			params := &v1beta1.QueryGetExecutionRequest{
				Id: args[0],
			}

			res, err := queryClient.Execution(context.Background(), params)
			if err != nil {
				return err
			}

			return clientCtx.PrintProto(res)
		},
	}

	flags.AddQueryFlagsToCmd(cmd)

	return cmd
}
