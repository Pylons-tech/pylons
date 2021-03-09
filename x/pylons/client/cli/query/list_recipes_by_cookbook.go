package query

import (
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/spf13/cobra"
)

// ListRecipesByCookbook queries the recipes
func ListRecipesByCookbook() *cobra.Command {
	var cookbookID string
	ccb := &cobra.Command{
		Use:   "list_recipe_by_cookbook",
		Short: "get all recipes on cookbook",
		Args:  cobra.ExactArgs(0),
		RunE: func(cmd *cobra.Command, args []string) error {
			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			queryClient := types.NewQueryClient(clientCtx)

			cookbookReq := &types.ListRecipeByCookbookRequest{
				CookbookID: cookbookID,
			}

			res, err := queryClient.ListRecipeByCookbook(cmd.Context(), cookbookReq)
			if err != nil {
				return err
			}

			return clientCtx.PrintProto(res)
		},
	}
	ccb.PersistentFlags().StringVar(&cookbookID, "cookbook-id", "", "id of cookbook")
	return ccb
}

// ListShortenRecipesByCookbook queries the recipes
func ListShortenRecipesByCookbook() *cobra.Command {
	var cookbookID string
	ccb := &cobra.Command{
		Use:   "list_shorten_recipe_by_cookbook",
		Short: "get shorten format of recipes on cookbook",
		Args:  cobra.ExactArgs(0),
		RunE: func(cmd *cobra.Command, args []string) error {
			clientCtx, err := client.GetClientTxContext(cmd)
			if err != nil {
				return err
			}

			queryClient := types.NewQueryClient(clientCtx)

			cookbookReq := &types.ListShortenRecipeByCookbookRequest{
				CookbookID: cookbookID,
			}

			res, err := queryClient.ListShortenRecipeByCookbook(cmd.Context(), cookbookReq)
			if err != nil {
				return err
			}

			return clientCtx.PrintProto(res)
		},
	}
	ccb.PersistentFlags().StringVar(&cookbookID, "cookbook-id", "", "id of cookbook")
	return ccb
}
