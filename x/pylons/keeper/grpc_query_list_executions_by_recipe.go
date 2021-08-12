package keeper

import (
	"context"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k Keeper) ListExecutionsByRecipe(goCtx context.Context, req *types.QueryListExecutionsByRecipeRequest) (*types.QueryListExecutionsByRecipeResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}

	ctx := sdk.UnwrapSDKContext(goCtx)

	execs := k.GetExecutionsByRecipe(ctx, req.CookbookID, req.RecipeID)

	return &types.QueryListExecutionsByRecipeResponse{Executions: execs}, nil
}
