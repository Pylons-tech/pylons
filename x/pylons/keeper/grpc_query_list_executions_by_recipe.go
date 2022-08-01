package keeper

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func (k Keeper) ListExecutionsByRecipe(goCtx context.Context, req *v1beta1.QueryListExecutionsByRecipeRequest) (*v1beta1.QueryListExecutionsByRecipeResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}

	ctx := sdk.UnwrapSDKContext(goCtx)

	completedExecs, pendingExecs, pageRes, err := k.getExecutionsByRecipePaginated(ctx, req.CookbookId, req.RecipeId, req.Pagination)
	if err != nil {
		return nil, status.Errorf(codes.InvalidArgument, "paginate: %v", err)
	}

	return &v1beta1.QueryListExecutionsByRecipeResponse{CompletedExecutions: completedExecs, PendingExecutions: pendingExecs, Pagination: pageRes}, nil
}
