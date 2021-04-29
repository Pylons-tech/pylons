package keeper

import (
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// HasGoogleIAPOrder checks if an iap order exist
func (k Keeper) HasGoogleIAPOrder(ctx sdk.Context, token string) bool {
	store := ctx.KVStore(k.GoogleIAPOrderKey)
	return store.Has([]byte(token))
}

// RegisterGoogleIAPOrder is used to add an iap order
func (k Keeper) RegisterGoogleIAPOrder(ctx sdk.Context, iap types.GoogleIAPOrder) error {
	return k.SetObject(ctx, types.TypeGoogleIAPOrder, iap.PurchaseToken, k.GoogleIAPOrderKey, iap)
}
