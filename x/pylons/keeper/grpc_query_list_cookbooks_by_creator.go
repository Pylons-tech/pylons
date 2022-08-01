package keeper

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func (k Keeper) ListCookbooksByCreator(goCtx context.Context, req *v1beta1.QueryListCookbooksByCreatorRequest) (*v1beta1.QueryListCookbooksByCreatorResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}

	ctx := sdk.UnwrapSDKContext(goCtx)

	addr, err := sdk.AccAddressFromBech32(req.Creator)
	if err != nil {
		return nil, status.Error(codes.InvalidArgument, "invalid address")
	}

	// no errors, default case is an empty list meaning there is no cookbook owned by this address
	cbs, pageRes, err := k.getCookbooksByCreatorPaginated(ctx, addr, req.Pagination)
	if err != nil {
		return nil, status.Errorf(codes.InvalidArgument, "paginate: %v", err)
	}

	return &v1beta1.QueryListCookbooksByCreatorResponse{Cookbooks: cbs, Pagination: pageRes}, nil
}
