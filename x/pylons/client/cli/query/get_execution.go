package query

import (
	"fmt"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/spf13/cobra"
)

// GetExecution get an execution by GUID
func GetExecution() *cobra.Command {
	ccb := &cobra.Command{
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

			return clientCtx.PrintString(fmt.Sprintf(
				"NodeVersion: %s \nID: %s \nRecipeID: %s \nCookbookID: %s \nCoinsInput: %s \nItemInputs: %s \nBlockHeight: %d \nSender: %s \nCompleted: %t",
				res.NodeVersion,
				res.ID,
				res.RecipeID,
				res.CookbookID,
				res.CoinsInput,
				res.ItemInputs,
				res.BlockHeight,
				res.Sender,
				res.Completed,
			))
		},
	}
	return ccb
}
