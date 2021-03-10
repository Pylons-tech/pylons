package queriers

import (
	"context"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// query endpoints supported by the nameservice Querier
const (
	KeyListShortenRecipeByCookbook = "list_shorten_recipe_by_cookbook"
)

// ListShortenRecipeByCookbook returns a recipe based on the recipe id
func (querier *querierServer) ListShortenRecipeByCookbook(ctx context.Context, req *types.ListShortenRecipeByCookbookRequest) (*types.ListShortenRecipeByCookbookResponse, error) {
	if req.Size() == 0 {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "no cookbook id is provided in path")
	}

	var recipes []types.Recipe
	var shortenRecipes []types.ShortenRecipe

	if req.CookbookID == "" {
		recipes = querier.Keeper.GetRecipes(sdk.UnwrapSDKContext(ctx))
	} else {
		recipes = querier.Keeper.GetRecipesByCookbook(sdk.UnwrapSDKContext(ctx), req.CookbookID)
	}

	for _, rcp := range recipes {
		shortenRecipes = append(shortenRecipes, NewShortenRecipe(
			rcp.ID, rcp.CookbookID, rcp.Name, rcp.Description, rcp.Sender))
	}

	return &types.ListShortenRecipeByCookbookResponse{
		Recipes: shortenRecipes,
	}, nil
}
