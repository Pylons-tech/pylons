package queriers

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// query endpoints supported by the nameservice Querier
const (
	KeyListRecipe = "list_recipe"
)

// ListRecipe returns a recipe based on the recipe id
func (querier *querierServer) ListRecipe(ctx context.Context, req *types.ListRecipeRequest) (*types.ListRecipeResponse, error) {
	var recipes []types.Recipe
	if req.Address == "" {
		recipes = querier.Keeper.GetRecipes(sdk.UnwrapSDKContext(ctx))
	} else {
		accAddr, err := sdk.AccAddressFromBech32(req.Address)
		if err != nil {
			return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
		}
		recipes = querier.Keeper.GetRecipesBySender(sdk.UnwrapSDKContext(ctx), accAddr)
	}

	return &types.ListRecipeResponse{
		Recipes: recipes,
	}, nil
}
