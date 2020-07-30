package query

import (
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/queriers"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client/context"
	"github.com/cosmos/cosmos-sdk/codec"
	"github.com/spf13/cobra"
)

// ListRecipesByCookbook queries the recipes
func ListRecipesByCookbook(queryRoute string, cdc *codec.Codec) *cobra.Command {
	var cookbookID string
	ccb := &cobra.Command{
		Use:   "list_recipe_by_cookbook",
		Short: "get all recipes on cookbook",
		Args:  cobra.ExactArgs(0),
		RunE: func(cmd *cobra.Command, args []string) error {
			cliCtx := context.NewCLIContext().WithCodec(cdc)

			res, _, err := cliCtx.QueryWithData(fmt.Sprintf("custom/%s/list_recipe_by_cookbook/%s", queryRoute, cookbookID), nil)
			if err != nil {
				return fmt.Errorf(err.Error())
			}

			var out types.RecipeList
			cdc.MustUnmarshalJSON(res, &out)
			return cliCtx.PrintOutput(out)
		},
	}
	ccb.PersistentFlags().StringVar(&cookbookID, "cookbook-id", "", "id of cookbook")
	return ccb
}

// ListShortenRecipesByCookbook queries the recipes
func ListShortenRecipesByCookbook(queryRoute string, cdc *codec.Codec) *cobra.Command {
	var cookbookID string
	ccb := &cobra.Command{
		Use:   "list_shorten_recipe_by_cookbook",
		Short: "get shorten format of recipes on cookbook",
		Args:  cobra.ExactArgs(0),
		RunE: func(cmd *cobra.Command, args []string) error {
			cliCtx := context.NewCLIContext().WithCodec(cdc)

			res, _, err := cliCtx.QueryWithData(fmt.Sprintf("custom/%s/list_shorten_recipe_by_cookbook/%s", queryRoute, cookbookID), nil)
			if err != nil {
				return fmt.Errorf(err.Error())
			}

			var out queriers.ShortenRecipeList
			cdc.MustUnmarshalJSON(res, &out)
			return cliCtx.PrintOutput(out)
		},
	}
	ccb.PersistentFlags().StringVar(&cookbookID, "cookbook-id", "", "id of cookbook")
	return ccb
}
