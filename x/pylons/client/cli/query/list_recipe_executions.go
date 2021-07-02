package query

import (
	"github.com/spf13/cobra"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// ListRecipeExecutions queries the delayed executions
func ListRecipeExecutions() *cobra.Command {
	var recipe string
	cmd := &cobra.Command{
		Use:   "list_recipe_executions",
		Short: "get all executions of a recipe for all users",
		Args:  cobra.ExactArgs(0),
		RunE: func(cmd *cobra.Command, args []string) error {
			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			queryClient := types.NewQueryClient(clientCtx)

			executionReq := &types.ListRecipeExecutionsRequest{
				Recipe: recipe,
			}

			res, err := queryClient.ListRecipeExecutions(cmd.Context(), executionReq)
			if err != nil {
				return err
			}

			return clientCtx.PrintProto(res)
		},
	}

	cmd.PersistentFlags().StringVar(&recipe, "recipe", "", "address of user")
	flags.AddQueryFlagsToCmd(cmd)
	return cmd
}
