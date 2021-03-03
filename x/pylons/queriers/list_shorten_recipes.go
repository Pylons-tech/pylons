package queriers

import (
	"context"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// query endpoints supported by the nameservice Querier
const (
	KeyListShortenRecipe = "list_shorten_recipe"
)

// NewShortenRecipe is a constructor for ShortenRecipe
func NewShortenRecipe(ID, cbID, Name, Description string, Sender sdk.AccAddress) *types.ShortenRecipe {
	return &types.ShortenRecipe{
		ID:          ID,
		CookbookID:  cbID,
		Name:        Name,
		Description: Description,
		Sender:      Sender.String(),
	}
}

// ListShortenRecipe returns a recipe based on the recipe id
func (querier *querierServer) ListShortenRecipe(ctx context.Context, req *types.ListShortenRecipeRequest) (*types.ListShortenRecipeResponse, error) {
	if req.Size() == 0 {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "no address is provided in path")
	}

	var recipes []types.Recipe
	var shortenRecipes []*types.ShortenRecipe
	accAddr, err := sdk.AccAddressFromBech32(req.Address)

	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if accAddr.Empty() {
		recipes = querier.Keeper.GetRecipes(sdk.UnwrapSDKContext(ctx))
	} else {
		recipes = querier.Keeper.GetRecipesBySender(sdk.UnwrapSDKContext(ctx), accAddr)
	}

	for _, rcp := range recipes {
		shortenRecipes = append(shortenRecipes, NewShortenRecipe(
			rcp.ID, rcp.CookbookID, rcp.Name, rcp.Description, rcp.Sender))
	}

	return &types.ListShortenRecipeResponse{
		Recipes: shortenRecipes,
	}, nil
}
