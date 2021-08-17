package keeper

import (
	"context"

	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k Keeper) GoogleIAPOrder(c context.Context, req *types.QueryGetGoogleIAPOrderRequest) (*types.QueryGetGoogleIAPOrderResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}

	var googleIAPOrder types.GoogleIAPOrder
	ctx := sdk.UnwrapSDKContext(c)

	if !k.HasGoogleIAPOrder(ctx, req.PurchaseToken) {
		return nil, sdkerrors.ErrKeyNotFound
	}

	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.GoogleIAPOrderKey))
	k.cdc.MustUnmarshalBinaryBare(store.Get(types.KeyPrefix(req.PurchaseToken)), &googleIAPOrder)

	return &types.QueryGetGoogleIAPOrderResponse{GoogleIAPOrder: googleIAPOrder}, nil
}
