package cli

import (
	"strconv"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	"github.com/spf13/cobra"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/client/flags"
)

var _ = strconv.Itoa(0)

func CmdListExecutionsByRecipe() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "list-executions-by-recipe [cookbook-id] [recipe-id]",
		Short: "list all executions of recipe by ID",
		Args:  cobra.ExactArgs(2),
		RunE: func(cmd *cobra.Command, args []string) error {
			reqCookbookID := args[0]
			reqRecipeID := args[1]

			clientCtx := client.GetClientContextFromCmd(cmd)

			queryClient := v1beta1.NewQueryClient(clientCtx)

			params := &v1beta1.QueryListExecutionsByRecipeRequest{
				CookbookId: reqCookbookID,
				RecipeId:   reqRecipeID,
			}

			res, err := queryClient.ListExecutionsByRecipe(cmd.Context(), params)
			if err != nil {
				return err
			}

			return clientCtx.PrintProto(res)
		},
	}

	flags.AddQueryFlagsToCmd(cmd)

	return cmd
}
