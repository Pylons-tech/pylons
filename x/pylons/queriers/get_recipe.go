package queriers

import (
	"context"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// query endpoints supported by the nameservice Querier
const (
	KeyGetRecipe = "get_recipe"
)

// GetRecipe returns a recipe based on the recipe id
func (querier *querierServer) GetRecipe(ctx context.Context, req *types.GetRecipeRequest) (*types.GetRecipeResponse, error) {
	if req.RecipeID == "" {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "no recipe id is provided in path")
	}

	recipe, err := querier.Keeper.GetRecipe(sdk.UnwrapSDKContext(ctx), req.RecipeID)

	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	return &types.GetRecipeResponse{
		NodeVersion:   &recipe.NodeVersion,
		ID:            recipe.ID,
		CookbookID:    recipe.CookbookID,
		Name:          recipe.Name,
		CoinInputs:    &recipe.CoinInputs,
		ItemInputs:    &recipe.ItemInputs,
		Entries:       &recipe.Entries,
		Outputs:       &recipe.Outputs,
		Description:   recipe.Description,
		BlockInterval: recipe.BlockInterval,
		Sender:        recipe.Sender.String(),
		Disabled:      recipe.Disabled,
	}, nil

}
