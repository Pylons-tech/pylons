package keeper

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/cosmos/cosmos-sdk/types/query"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func (k Keeper) GoogleIAPOrderAll(c context.Context, req *types.QueryAllGooglIAPOrderRequest) (*types.QueryAllGooglIAPOrderResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}

	var googlIAPOrders []*types.GooglIAPOrder
	ctx := sdk.UnwrapSDKContext(c)

	store := ctx.KVStore(k.storeKey)
	googlIAPOrderStore := prefix.NewStore(store, types.KeyPrefix(types.GoogleIAPOrderKey))

	pageRes, err := query.Paginate(googlIAPOrderStore, req.Pagination, func(key []byte, value []byte) error {
		var googlIAPOrder types.GooglIAPOrder
		if err := k.cdc.UnmarshalBinaryBare(value, &googlIAPOrder); err != nil {
			return err
		}

		googlIAPOrders = append(googlIAPOrders, &googlIAPOrder)
		return nil
	})

	if err != nil {
		return nil, status.Error(codes.Internal, err.Error())
	}

	return &types.QueryAllGooglIAPOrderResponse{GooglIAPOrder: googlIAPOrders, Pagination: pageRes}, nil
}

func (k Keeper) GooglIAPOrder(c context.Context, req *types.QueryGetGooglIAPOrderRequest) (*types.QueryGetGooglIAPOrderResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}

	var googlIAPOrder types.GooglIAPOrder
	ctx := sdk.UnwrapSDKContext(c)

    if !k.HasGoogleIAPOrder(ctx, req.Id) {
        return nil, sdkerrors.ErrKeyNotFound
    }

	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.GoogleIAPOrderKey))
	k.cdc.MustUnmarshalBinaryBare(store.Get(GetGoogleIAPOrderIDBytes(req.Id)), &googlIAPOrder)

	return &types.QueryGetGooglIAPOrderResponse{GooglIAPOrder: &googlIAPOrder}, nil
}
