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

	if !k.HasExecution(ctx, req.ID) {
		return nil, sdkerrors.ErrKeyNotFound
	}

	execution := k.GetExecution(ctx, req.ID)

	return &types.QueryGetExecutionResponse{Execution: &execution}, nil
}
