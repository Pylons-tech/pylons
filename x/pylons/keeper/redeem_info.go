package keeper

import (
	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// SetRedeemInfo set a specific redeemInfo in the store from its index
func (k Keeper) SetRedeemInfo(ctx sdk.Context, redeemInfo types.RedeemInfo) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.RedeemInfoKey))
	b := k.cdc.MustMarshal(&redeemInfo)
	store.Set(types.KeyPrefix(redeemInfo.Id), b)
}

// GetRedeemInfo returns a redeemInfo from its index
func (k Keeper) GetRedeemInfo(ctx sdk.Context, index string) (val types.RedeemInfo, found bool) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.RedeemInfoKey))

	b := store.Get(types.KeyPrefix(index))
	if b == nil {
		return val, false
	}

	k.cdc.MustUnmarshal(b, &val)
	return val, true
}

// GetAllRedeemInfo returns all redeemInfo
func (k Keeper) GetAllRedeemInfo(ctx sdk.Context) (list []types.RedeemInfo) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.RedeemInfoKey))
	iterator := sdk.KVStorePrefixIterator(store, []byte{})

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var val types.RedeemInfo
		k.cdc.MustUnmarshal(iterator.Value(), &val)
		list = append(list, val)
	}

	return
}
