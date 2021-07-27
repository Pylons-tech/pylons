package keeper

import (
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// SetCookbook set a specific cookbook in the store from its index
func (k Keeper) SetCookbook(ctx sdk.Context, cookbook types.Cookbook) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.CookbookKey))
	b := k.cdc.MustMarshalBinaryBare(&cookbook)
	store.Set(types.KeyPrefix(cookbook.Index), b)
}

// GetCookbook returns a cookbook from its index
func (k Keeper) GetCookbook(ctx sdk.Context, index string) (val types.Cookbook, found bool) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.CookbookKey))

	b := store.Get(types.KeyPrefix(index))
	if b == nil {
		return val, false
	}

	k.cdc.MustUnmarshalBinaryBare(b, &val)
	return val, true
}
