package queriers

import (
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	abci "github.com/tendermint/tendermint/abci/types"
)

// query endpoints supported by the nameservice Querier
const (
	KeyListRecipeByCookbook = "list_recipe_by_cookbook"
)

// ListRecipeByCookbook returns a recipe based on the recipe id
func ListRecipeByCookbook(ctx sdk.Context, path []string, req abci.RequestQuery, keeper keep.Keeper) ([]byte, error) {
	if len(path) == 0 {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "no cookbook id is provided in path")
	}
	cookbookID := path[0]
	var recipeList types.RecipeList
	var recipes []types.Recipe

	if cookbookID == "" {
		recipes = keeper.GetRecipes(ctx)
	} else {
		recipes = keeper.GetRecipesByCookbook(ctx, cookbookID)
	}

	recipeList = types.RecipeList{
		Recipes: recipes,
	}

	rcpl, err := keeper.Cdc.MarshalJSON(recipeList)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	return rcpl, nil
}
