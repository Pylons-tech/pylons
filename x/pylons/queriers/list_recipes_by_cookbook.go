package queriers

import (
	"context"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// query endpoints supported by the nameservice Querier
const (
	KeyListRecipeByCookbook = "list_recipe_by_cookbook"
)

// ListRecipeByCookbook returns a recipe based on the recipe id
func (querier *querierServer) ListRecipeByCookbook(ctx context.Context, req *types.ListRecipeByCookbookRequest) (*types.ListRecipeByCookbookResponse, error) {
	if req.Size() == 0 {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "no cookbook id is provided in path")
	}

	var recipes []types.Recipe

	if req.CookbookID == "" {
		recipes = querier.Keeper.GetRecipes(sdk.UnwrapSDKContext(ctx))
	} else {
		recipes = querier.Keeper.GetRecipesByCookbook(sdk.UnwrapSDKContext(ctx), req.CookbookID)
	}

	return &types.ListRecipeByCookbookResponse{
		Recipes: recipes,
	}, nil
}
