package keeper

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func (k Keeper) ListRecipesByCookbook(goCtx context.Context, req *v1beta1.QueryListRecipesByCookbookRequest) (*v1beta1.QueryListRecipesByCookbookResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}

	ctx := sdk.UnwrapSDKContext(goCtx)

	// no errors, default case is an empty list meaning there are no recipes for this cookbook
	recipes, pageRes, err := k.getRecipesByCookbookPaginated(ctx, req.CookbookId, req.Pagination)
	if err != nil {
		return nil, status.Errorf(codes.InvalidArgument, "paginate: %v", err)
	}

	return &v1beta1.QueryListRecipesByCookbookResponse{Recipes: recipes, Pagination: pageRes}, nil
}
