package keeper

import (
	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// SetUsername set a specific username in the store from its index
func (k Keeper) SetUsername(ctx sdk.Context, username types.Username) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.UsernameKey))
	b := k.cdc.MustMarshalBinaryBare(&username)
	store.Set(types.KeyPrefix(username.Creator), b)
}

// GetUsername returns a username from its index
func (k Keeper) GetUsername(ctx sdk.Context, account string) (val types.Username, found bool) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.UsernameKey))

	b := store.Get(types.KeyPrefix(account))
	if b == nil {
		return val, false
	}

	k.cdc.MustUnmarshalBinaryBare(b, &val)
	return val, true
}

// RemoveUsername removes a username from the store
func (k Keeper) RemoveUsername(ctx sdk.Context, index string) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.UsernameKey))
	store.Delete(types.KeyPrefix(index))
}

// GetAllUsername returns all username
func (k Keeper) GetAllUsername(ctx sdk.Context) (list []types.Username) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.UsernameKey))
	iterator := sdk.KVStorePrefixIterator(store, []byte{})

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var val types.Username
		k.cdc.MustUnmarshalBinaryBare(iterator.Value(), &val)
		list = append(list, val)
	}

	return
}
