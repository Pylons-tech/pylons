package keeper

import (
	"context"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k Keeper) ListCookbooksByCreator(goCtx context.Context, req *types.QueryListCookbooksByCreatorRequest) (*types.QueryListCookbooksByCreatorResponse, error) {

	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}

	ctx := sdk.UnwrapSDKContext(goCtx)

	addr, err := sdk.AccAddressFromBech32(req.Creator)
	if err != nil {
		return nil, status.Error(codes.InvalidArgument, "invalid address")
	}

	// no errors, default case is an empty list meaning there is no cookbook owned by this address
	cbs := k.GetAllCookbookByCreator(ctx, addr)

	return &types.QueryListCookbooksByCreatorResponse{Cookbooks: cbs}, nil
}
