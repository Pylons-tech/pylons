package queriers

import (
	"context"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
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
		NodeVersion:   recipe.NodeVersion,
		ID:            recipe.ID,
		CookbookID:    recipe.CookbookID,
		Name:          recipe.Name,
		CoinInputs:    recipe.CoinInputs,
		ItemInputs:    recipe.ItemInputs,
		Entries:       recipe.Entries,
		Outputs:       recipe.Outputs,
		Description:   recipe.Description,
		BlockInterval: recipe.BlockInterval,
		Sender:        recipe.Sender,
		Disabled:      recipe.Disabled,
	}, nil
}

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

// NewShortenRecipe is a constructor for ShortenRecipe
func NewShortenRecipe(id, cbID, name, description, sender string) types.ShortenRecipe {
	return types.ShortenRecipe{
		ID:          id,
		CookbookID:  cbID,
		Name:        name,
		Description: description,
		Sender:      sender,
	}
}

// ListShortenRecipe returns a recipe based on the recipe id
func (querier *querierServer) ListShortenRecipe(ctx context.Context, req *types.ListShortenRecipeRequest) (*types.ListShortenRecipeResponse, error) {
	if req.Size() == 0 {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "no address is provided in path")
	}

	var recipes []types.Recipe
	accAddr, err := sdk.AccAddressFromBech32(req.Address)

	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if accAddr.Empty() {
		recipes = querier.Keeper.GetRecipes(sdk.UnwrapSDKContext(ctx))
	} else {
		recipes = querier.Keeper.GetRecipesBySender(sdk.UnwrapSDKContext(ctx), accAddr)
	}

	shortenRecipes := make([]types.ShortenRecipe, len(recipes))
	for i, rcp := range recipes {
		shortenRecipes[i] = NewShortenRecipe(rcp.ID, rcp.CookbookID, rcp.Name, rcp.Description, rcp.Sender)
	}

	return &types.ListShortenRecipeResponse{
		Recipes: shortenRecipes,
	}, nil
}

// ListShortenRecipeByCookbook returns a recipe based on the recipe id
func (querier *querierServer) ListShortenRecipeByCookbook(ctx context.Context, req *types.ListShortenRecipeByCookbookRequest) (*types.ListShortenRecipeByCookbookResponse, error) {
	if req.Size() == 0 {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "no cookbook id is provided in path")
	}

	var recipes []types.Recipe
	if req.CookbookID == "" {
		recipes = querier.Keeper.GetRecipes(sdk.UnwrapSDKContext(ctx))
	} else {
		recipes = querier.Keeper.GetRecipesByCookbook(sdk.UnwrapSDKContext(ctx), req.CookbookID)
	}

	shortenRecipes := make([]types.ShortenRecipe, len(recipes))
	for i, rcp := range recipes {
		shortenRecipes[i] = NewShortenRecipe(
			rcp.ID, rcp.CookbookID, rcp.Name, rcp.Description, rcp.Sender)
	}

	return &types.ListShortenRecipeByCookbookResponse{
		Recipes: shortenRecipes,
	}, nil
}
