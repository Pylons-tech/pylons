package keeper

import (
	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// SetRedeemInfo set a specific redeemInfo in the store from its index
func (k Keeper) SetRedeemInfo(ctx sdk.Context, redeemInfo v1beta1.RedeemInfo) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.RedeemInfoKey))
	b := k.cdc.MustMarshal(&redeemInfo)
	store.Set(v1beta1.KeyPrefix(redeemInfo.Id), b)
}

// GetRedeemInfo returns a redeemInfo from its index
func (k Keeper) GetRedeemInfo(ctx sdk.Context, index string) (val v1beta1.RedeemInfo, found bool) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.RedeemInfoKey))

	b := store.Get(v1beta1.KeyPrefix(index))
	if b == nil {
		return val, false
	}

	k.cdc.MustUnmarshal(b, &val)
	return val, true
}

// GetAllRedeemInfo returns all redeemInfo
func (k Keeper) GetAllRedeemInfo(ctx sdk.Context) (list []v1beta1.RedeemInfo) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.RedeemInfoKey))
	iterator := sdk.KVStorePrefixIterator(store, []byte{})

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var val v1beta1.RedeemInfo
		k.cdc.MustUnmarshal(iterator.Value(), &val)
		list = append(list, val)
	}

	return
}
