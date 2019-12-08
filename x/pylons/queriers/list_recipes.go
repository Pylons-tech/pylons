package queriers

import (
	"encoding/json"

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

	iterator := keeper.GetRecipesIterator(ctx, accAddr)

	for ; iterator.Valid(); iterator.Next() {
		var recipe types.Recipe
		mRCP := iterator.Value()
		err = json.Unmarshal(mRCP, &recipe)
		if err != nil {
			// this happens because we have multiple versions of breaking recipes at times
			continue
		}

		recipes = append(recipes, recipe)
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
