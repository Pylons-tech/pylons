package keeper

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func (k Keeper) Execution(c context.Context, req *v1beta1.QueryGetExecutionRequest) (*v1beta1.QueryGetExecutionResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}

	ctx := sdk.UnwrapSDKContext(c)

	completed := false
	var execution v1beta1.Execution
	switch {
	case k.HasPendingExecution(ctx, req.Id):
		execution = k.GetPendingExecution(ctx, req.Id)
	case k.HasExecution(ctx, req.Id):
		completed = true
		execution = k.GetExecution(ctx, req.Id)
	default:
		return nil, status.Error(codes.InvalidArgument, "not found")
	}

	return &v1beta1.QueryGetExecutionResponse{Execution: execution, Completed: completed}, nil
}
