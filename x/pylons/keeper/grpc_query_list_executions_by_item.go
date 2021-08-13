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

	// Get the item from the store
	item, found := k.GetItem(ctx, req.CookbookID, req.ItemID)
	if !found {
		return &types.QueryListExecutionsByItemResponse{}, status.Error(codes.InvalidArgument, "item does not exist")
	}

	execs := k.GetExecutionsByItem(ctx, item.CookbookID, item.ID)

	return &types.QueryListExecutionsByItemResponse{Executions: execs}, nil
}
