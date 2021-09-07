package keeper

import (
	"context"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k Keeper) PylonsAccountByUsername(goCtx context.Context, req *types.QueryGetAccountByUsernameRequest) (*types.QueryGetAccountByUsernameResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}
	ctx := sdk.UnwrapSDKContext(goCtx)

	val, found := k.GetPylonsAccountByUsername(ctx, req.Username)
	if !found {
		return nil, status.Error(codes.InvalidArgument, "not found")
	}

	return &types.QueryGetAccountByUsernameResponse{PylonsAccount: val}, nil
}

func (k Keeper) PylonsAccountByAddress(goCtx context.Context, req *types.QueryGetAccountByAddressRequest) (*types.QueryGetAccountByAddressResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}
	ctx := sdk.UnwrapSDKContext(goCtx)

	_, err := sdk.AccAddressFromBech32(req.Address)
	if err != nil {
		return nil, status.Error(codes.InvalidArgument, "invalid address")
	}

	val, found := k.GetPylonsAccountByAddress(ctx, req.Address)
	if !found {
		return nil, status.Error(codes.InvalidArgument, "not found")
	}

	return &types.QueryGetAccountByAddressResponse{PylonsAccount: val}, nil
}
