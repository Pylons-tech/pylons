package keeper

import (
	"context"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k Keeper) GetItemOwnershipHistory(c context.Context, req *types.QueryGetItemHistoryRequest) (*types.QueryGetItemHistoryResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}
	ctx := sdk.UnwrapSDKContext(c)

	val := k.GetItemHistory(ctx, req.CookbookId, req.ItemId, req.MintedNumber)
	if len(val) == 0 {
		return &types.QueryGetItemHistoryResponse{History: []*types.ItemHistory{}}, nil
	}

	return &types.QueryGetItemHistoryResponse{History: val}, nil
}
