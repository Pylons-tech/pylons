package keeper

import (
	"context"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
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
	if k.HasPendingExecution(ctx, req.ID) {
		execution = k.GetPendingExecution(ctx, req.ID)
	} else if k.HasExecution(ctx, req.ID) {
		completed = true
		execution = k.GetExecution(ctx, req.ID)
	} else {
		return nil, sdkerrors.ErrKeyNotFound
	}

	return &types.QueryGetExecutionResponse{Execution: &execution, Completed: completed}, nil
}
