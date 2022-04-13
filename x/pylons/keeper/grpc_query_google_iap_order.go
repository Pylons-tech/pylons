package keeper

import (
	"context"
	"fmt"

	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k Keeper) GoogleInAppPurchaseOrder(c context.Context, req *types.QueryGetGoogleInAppPurchaseOrderRequest) (*types.QueryGetGoogleInAppPurchaseOrderResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}

	var googleIAPOrder types.GoogleInAppPurchaseOrder
	ctx := sdk.UnwrapSDKContext(c)

	if !k.HasGoogleIAPOrder(ctx, req.PurchaseToken) {
		fmt.Println("The Key was not found")
		return nil, sdkerrors.ErrKeyNotFound
	}

	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.GoogleInAppPurchaseOrderKey))
	k.cdc.MustUnmarshal(store.Get(types.KeyPrefix(req.PurchaseToken)), &googleIAPOrder)

	return &types.QueryGetGoogleInAppPurchaseOrderResponse{Order: googleIAPOrder}, nil
}
