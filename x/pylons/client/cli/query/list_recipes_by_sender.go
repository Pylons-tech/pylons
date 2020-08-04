package query

import (
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/queriers"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/client/context"
	"github.com/cosmos/cosmos-sdk/codec"
	"github.com/spf13/cobra"
)

// ListRecipes queries the recipes
func ListRecipes(queryRoute string, cdc *codec.Codec) *cobra.Command {
	var accAddr string
	ccb := &cobra.Command{
		Use:   "list_recipe",
		Short: "get all recipes for a user",
		Args:  cobra.ExactArgs(0),
		RunE: func(cmd *cobra.Command, args []string) error {
			cliCtx := context.NewCLIContext().WithCodec(cdc)

			res, _, err := cliCtx.QueryWithData(fmt.Sprintf("custom/%s/list_recipe/%s", queryRoute, accAddr), nil)
			if err != nil {
				return fmt.Errorf(err.Error())
			}

			var out types.RecipeList
			cdc.MustUnmarshalJSON(res, &out)
			return cliCtx.PrintOutput(out)
		},
	}
	ccb.PersistentFlags().StringVar(&accAddr, "account", "", "address of user")
	return ccb
}

// ListShortenRecipes queries the recipes
func ListShortenRecipes(queryRoute string, cdc *codec.Codec) *cobra.Command {
	var accAddr string
	ccb := &cobra.Command{
		Use:   "list_shorten_recipe",
		Short: "get shorten format of recipes for a user",
		Args:  cobra.ExactArgs(0),
		RunE: func(cmd *cobra.Command, args []string) error {
			cliCtx := context.NewCLIContext().WithCodec(cdc)

			res, _, err := cliCtx.QueryWithData(fmt.Sprintf("custom/%s/list_shorten_recipe/%s", queryRoute, accAddr), nil)
			if err != nil {
				return fmt.Errorf(err.Error())
			}

			var out queriers.ShortenRecipeList
			cdc.MustUnmarshalJSON(res, &out)
			return cliCtx.PrintOutput(out)
		},
	}
	ccb.PersistentFlags().StringVar(&accAddr, "account", "", "address of user")
	return ccb
}
