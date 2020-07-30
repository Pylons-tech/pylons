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
	KeyListShortenRecipeByCookbook = "list_shorten_recipe_by_cookbook"
)

// ListShortenRecipeByCookbook returns a recipe based on the recipe id
func ListShortenRecipeByCookbook(ctx sdk.Context, path []string, req abci.RequestQuery, keeper keep.Keeper) ([]byte, error) {
	if len(path) == 0 {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "no cookbook id is provided in path")
	}
	cookbookID := path[0]
	var shortenRecipeList ShortenRecipeList
	var recipes []types.Recipe
	var shortenRecipes []ShortenRecipe

	if cookbookID == "" {
		recipes = keeper.GetRecipes(ctx)
	} else {
		recipes = keeper.GetRecipesByCookbook(ctx, cookbookID)
	}

	for _, rcp := range recipes {
		shortenRecipes = append(shortenRecipes, NewShortenRecipe(
			rcp.ID, rcp.CookbookID, rcp.Name, rcp.Description, rcp.Sender))
	}

	shortenRecipeList = ShortenRecipeList{
		Recipes: shortenRecipes,
	}

	rcpl, err := keeper.Cdc.MarshalJSON(shortenRecipeList)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	return rcpl, nil
}
