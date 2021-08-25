package keeper

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func (k Keeper) ListItemByOwner(goCtx context.Context, req *types.QueryListItemByOwnerRequest) (*types.QueryListItemByOwnerResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}

	ctx := sdk.UnwrapSDKContext(goCtx)

	addr, err := sdk.AccAddressFromBech32(req.Owner)
	if err != nil {
		return nil, status.Error(codes.InvalidArgument, "invalid address")
	}

	items := k.GetAllItemByOwner(ctx, addr)

	return &types.QueryListItemByOwnerResponse{Items: items}, nil
}
