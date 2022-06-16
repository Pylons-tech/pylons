package keeper

import (
	"context"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k Keeper) ListExecutionsByItem(goCtx context.Context, req *types.QueryListExecutionsByItemRequest) (*types.QueryListExecutionsByItemResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}

	ctx := sdk.UnwrapSDKContext(goCtx)

	completedExecs, pendingExecs, pageRes, err := k.getExecutionsByItemPaginated(ctx, req.CookbookId, req.ItemId, req.Pagination)
	if err != nil {
		return nil, status.Errorf(codes.InvalidArgument, "paginate: %v", err)
	}

	return &types.QueryListExecutionsByItemResponse{CompletedExecutions: completedExecs, PendingExecutions: pendingExecs, Pagination: pageRes}, nil
}
