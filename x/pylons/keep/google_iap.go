package keep

import (
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// HasGoogleIAPOrder checks if an iap order exist
func (k Keeper) HasGoogleIAPOrder(ctx sdk.Context, id string) bool {
	store := ctx.KVStore(k.GoogleIAPOrderKey)
	return store.Has([]byte(id))
}

// RegisterGoogleIAPOrder is used to add an iap order
func (k Keeper) RegisterGoogleIAPOrder(ctx sdk.Context, iap types.GoogleIAPOrder) error {
	return k.SetObject(ctx, types.TypeGoogleIAPOrder, iap.ID, k.GoogleIAPOrderKey, iap)
}
