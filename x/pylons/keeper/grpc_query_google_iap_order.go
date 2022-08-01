package keeper

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func (k Keeper) GoogleInAppPurchaseOrder(c context.Context, req *v1beta1.QueryGetGoogleInAppPurchaseOrderRequest) (*v1beta1.QueryGetGoogleInAppPurchaseOrderResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}

	var googleIAPOrder v1beta1.GoogleInAppPurchaseOrder
	ctx := sdk.UnwrapSDKContext(c)

	if !k.HasGoogleIAPOrder(ctx, req.PurchaseToken) {
		return nil, sdkerrors.ErrKeyNotFound
	}

	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.GoogleInAppPurchaseOrderKey))
	k.cdc.MustUnmarshal(store.Get(v1beta1.KeyPrefix(req.PurchaseToken)), &googleIAPOrder)

	return &v1beta1.QueryGetGoogleInAppPurchaseOrderResponse{Order: googleIAPOrder}, nil
}
