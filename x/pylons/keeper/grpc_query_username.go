package keeper

import (
	"context"

	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/query"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k Keeper) UsernameAll(c context.Context, req *types.QueryAllUsernameRequest) (*types.QueryAllUsernameResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}

	var usernames []*types.Username
	ctx := sdk.UnwrapSDKContext(c)

	store := ctx.KVStore(k.storeKey)
	usernameStore := prefix.NewStore(store, types.KeyPrefix(types.UsernameKey))

	pageRes, err := query.Paginate(usernameStore, req.Pagination, func(key []byte, value []byte) error {
		var username types.Username
		if err := k.cdc.UnmarshalBinaryBare(value, &username); err != nil {
			return err
		}

		usernames = append(usernames, &username)
		return nil
	})

	if err != nil {
		return nil, status.Error(codes.Internal, err.Error())
	}

	return &types.QueryAllUsernameResponse{Username: usernames, Pagination: pageRes}, nil
}

func (k Keeper) Username(c context.Context, req *types.QueryGetUsernameRequest) (*types.QueryGetUsernameResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}
	ctx := sdk.UnwrapSDKContext(c)

	val, found := k.GetUsername(ctx, req.Account)
	if !found {
		return nil, status.Error(codes.InvalidArgument, "not found")
	}

	return &types.QueryGetUsernameResponse{Username: &val}, nil
}
