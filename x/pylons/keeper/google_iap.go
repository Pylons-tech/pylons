package keeper

import (
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// HasGoogleIAPOrder checks if an iap order exist
func (keeper Keeper) HasGoogleIAPOrder(ctx sdk.Context, token string) bool {
	store := ctx.KVStore(keeper.GoogleIAPOrderKey)
	return store.Has([]byte(token))
}

// RegisterGoogleIAPOrder is used to add an iap order
func (keeper Keeper) RegisterGoogleIAPOrder(ctx sdk.Context, iap types.GoogleIAPOrder) error {
	return keeper.SetObject(ctx, types.TypeGoogleIAPOrder, iap.PurchaseToken, keeper.GoogleIAPOrderKey, iap)
}
