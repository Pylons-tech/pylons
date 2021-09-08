package keeper

import (
	"context"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k Keeper) AddressByUsername(goCtx context.Context, req *types.QueryGetAddressByUsernameRequest) (*types.QueryGetAddressByUsernameResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}
	ctx := sdk.UnwrapSDKContext(goCtx)

	val, found := k.GetAddressByUsername(ctx, req.Username)
	if !found {
		return nil, status.Error(codes.InvalidArgument, "not found")
	}

	return &types.QueryGetAddressByUsernameResponse{Address: val}, nil
}

func (k Keeper) UsernameByAddress(goCtx context.Context, req *types.QueryGetUsernameByAddressRequest) (*types.QueryGetUsernameByAddressResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}
	ctx := sdk.UnwrapSDKContext(goCtx)

	_, err := sdk.AccAddressFromBech32(req.Address)
	if err != nil {
		return nil, status.Error(codes.InvalidArgument, "invalid address")
	}

	val, found := k.GetUsernameByAddress(ctx, req.Address)
	if !found {
		return nil, status.Error(codes.InvalidArgument, "not found")
	}

	return &types.QueryGetUsernameByAddressResponse{Username: val}, nil
}
