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
	var execution types.Execution
	switch {
	case k.HasPendingExecution(ctx, req.Id):
		execution = k.GetPendingExecution(ctx, req.Id)
	case k.HasExecution(ctx, req.Id):
		completed = true
		execution = k.GetExecution(ctx, req.Id)
	default:
		return nil, status.Error(codes.InvalidArgument, "not found")
	}

	return &types.QueryGetExecutionResponse{Execution: execution, Completed: completed}, nil
}
