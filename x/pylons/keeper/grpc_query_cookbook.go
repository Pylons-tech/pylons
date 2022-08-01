package keeper

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func (k Keeper) Cookbook(c context.Context, req *v1beta1.QueryGetCookbookRequest) (*v1beta1.QueryGetCookbookResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}
	ctx := sdk.UnwrapSDKContext(c)

	val, found := k.GetCookbook(ctx, req.Id)
	if !found {
		return nil, status.Error(codes.InvalidArgument, "not found")
	}

	return &v1beta1.QueryGetCookbookResponse{Cookbook: val}, nil
}
