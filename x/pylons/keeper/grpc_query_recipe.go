package keeper

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func (k Keeper) Recipe(c context.Context, req *v1beta1.QueryGetRecipeRequest) (*v1beta1.QueryGetRecipeResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}
	ctx := sdk.UnwrapSDKContext(c)

	val, found := k.GetRecipe(ctx, req.CookbookId, req.Id)
	if !found {
		return nil, status.Error(codes.InvalidArgument, "not found")
	}

	return &v1beta1.QueryGetRecipeResponse{Recipe: val}, nil
}
