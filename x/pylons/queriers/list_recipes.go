package queriers

import (
	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	abci "github.com/tendermint/tendermint/abci/types"
)

// query endpoints supported by the nameservice Querier
const (
	KeyListRecipe = "list_recipe"
)

// ListRecipe returns a recipe based on the recipe id
func ListRecipe(ctx sdk.Context, path []string, req abci.RequestQuery, keeper keep.Keeper) ([]byte, sdk.Error) {
	if len(path) == 0 {
		return nil, sdk.ErrInternal("no address is provided in path")
	}
	addr := path[0]
	var recipeList types.RecipeList
	var recipes []types.Recipe
	accAddr, err := sdk.AccAddressFromBech32(addr)

	if err != nil {
		return nil, sdk.ErrInternal(err.Error())
	}

	if accAddr.Empty() {
		recipes = keeper.GetRecipes(ctx)
	} else {
		recipes = keeper.GetRecipesBySender(ctx, accAddr)
	}

	recipeList = types.RecipeList{
		Recipes: recipes,
	}

	rcpl, err := keeper.Cdc.MarshalJSON(recipeList)
	if err != nil {
		return nil, sdk.ErrInternal(err.Error())
	}

	return rcpl, nil
}
