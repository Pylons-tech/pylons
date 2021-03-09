package query

import (
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/spf13/cobra"
)

// ListRecipes queries the recipes
func ListRecipes() *cobra.Command {
	var accAddr string
	ccb := &cobra.Command{
		Use:   "list_recipe",
		Short: "get all recipes for a user",
		Args:  cobra.ExactArgs(0),
		RunE: func(cmd *cobra.Command, args []string) error {
			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			queryClient := types.NewQueryClient(clientCtx)

			recipeReq := &types.ListRecipeRequest{
				Address: accAddr,
			}

			res, err := queryClient.ListRecipe(cmd.Context(), recipeReq)
			if err != nil {
				return err
			}

			return clientCtx.PrintProto(res)
		},
	}
	ccb.PersistentFlags().StringVar(&accAddr, "account", "", "address of user")
	return ccb
}

// ListShortenRecipes queries the recipes
func ListShortenRecipes() *cobra.Command {
	var accAddr string
	ccb := &cobra.Command{
		Use:   "list_shorten_recipe",
		Short: "get shorten format of recipes for a user",
		Args:  cobra.ExactArgs(0),
		RunE: func(cmd *cobra.Command, args []string) error {
			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			queryClient := types.NewQueryClient(clientCtx)

			recipeReq := &types.ListShortenRecipeRequest{
				Address: accAddr,
			}

			res, err := queryClient.ListShortenRecipe(cmd.Context(), recipeReq)
			if err != nil {
				return err
			}

			return clientCtx.PrintProto(res)
		},
	}
	ccb.PersistentFlags().StringVar(&accAddr, "account", "", "address of user")
	return ccb
}
