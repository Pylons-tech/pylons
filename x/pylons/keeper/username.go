package keeper

import (
	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// SetPylonsAccount set a specific pylons account in the store from its index
func (k Keeper) SetPylonsAccount(ctx sdk.Context, username types.PylonsAccount) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.UsernameKey))
	b := k.cdc.MustMarshalBinaryBare(&username)
	store.Set(types.KeyPrefix(username.Username), b)
}

// GetPylonsAccount returns a pylons account from its index
func (k Keeper) GetPylonsAccount(ctx sdk.Context, username string) (val types.PylonsAccount, found bool) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.UsernameKey))

	b := store.Get(types.KeyPrefix(username))
	if b == nil {
		return val, false
	}

	k.cdc.MustUnmarshalBinaryBare(b, &val)
	return val, true
}

// RemovePylonsAccount removes a pylons account from the store
func (k Keeper) RemovePylonsAccount(ctx sdk.Context, username string) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.UsernameKey))
	store.Delete(types.KeyPrefix(username))
}

// GetAllPylonsAccount returns all username
func (k Keeper) GetAllPylonsAccount(ctx sdk.Context) (list []types.PylonsAccount) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.UsernameKey))
	iterator := sdk.KVStorePrefixIterator(store, []byte{})

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var val types.PylonsAccount
		k.cdc.MustUnmarshalBinaryBare(iterator.Value(), &val)
		list = append(list, val)
	}

	return
}
