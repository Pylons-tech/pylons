package query

import (
	"github.com/spf13/cobra"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// GetRecipe get an execution by GUID
func GetRecipe() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "get_recipe <id>",
		Short: "get a recipe by id",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			queryClient := types.NewQueryClient(clientCtx)

			recipeReq := &types.GetRecipeRequest{
				RecipeID: args[0],
			}

			res, err := queryClient.GetRecipe(cmd.Context(), recipeReq)
			if err != nil {
				return err
			}

			return clientCtx.PrintProto(res)
		},
	}

	flags.AddQueryFlagsToCmd(cmd)
	return cmd
}
