package keeper

import (
	"context"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k Keeper) ListRecipesByCookbook(goCtx context.Context, req *types.QueryListRecipesByCookbookRequest) (*types.QueryListRecipesByCookbookResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}

	ctx := sdk.UnwrapSDKContext(goCtx)

	// no errors, default case is an empty list meaning there are no recipes for this cookbook
	recipes := k.GetAllRecipesByCookbook(ctx, req.CookbookID)

	return &types.QueryListRecipesByCookbookResponse{Recipes: recipes}, nil
}
