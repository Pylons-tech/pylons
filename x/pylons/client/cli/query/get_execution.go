package query

import (
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/spf13/cobra"
)

// GetExecution get an execution by GUID
func GetExecution() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "get_execution <id>",
		Short: "get an execution by id",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			clientCtx, err := client.GetClientQueryContext(cmd)
			if err != nil {
				return err
			}

			queryClient := types.NewQueryClient(clientCtx)

			executionReq := &types.GetExecutionRequest{
				ExecutionID: args[0],
			}

			res, err := queryClient.GetExecution(cmd.Context(), executionReq)
			if err != nil {
				return err
			}

			return clientCtx.PrintProto(res)
		},
	}

	flags.AddQueryFlagsToCmd(cmd)
	return cmd
}
