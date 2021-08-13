package keeper

import (
	"context"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k Keeper) Execution(c context.Context, req *types.QueryGetExecutionRequest) (*types.QueryGetExecutionResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}

	ctx := sdk.UnwrapSDKContext(c)

	completed := false
	execution := types.Execution{}
	switch {
	case k.HasPendingExecution(ctx, req.ID):
		execution = k.GetPendingExecution(ctx, req.ID)
	case k.HasExecution(ctx, req.ID):
		completed = true
		execution = k.GetExecution(ctx, req.ID)
	default:
		return nil, status.Error(codes.InvalidArgument, "not found")
	}

	return &types.QueryGetExecutionResponse{Execution: &execution, Completed: completed}, nil
}
