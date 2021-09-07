package keeper

import (
	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// SetPylonsAccount set a specific pylons account in the store from its index
// this function sets two symmetric KVStores with address -> username
// and username -> address mappings
func (k Keeper) SetPylonsAccount(ctx sdk.Context, account types.UserMap) {
	b := k.cdc.MustMarshalBinaryBare(&account)
	prefixStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.UsernameKey))

	prefixStore.Set(types.KeyPrefix(account.Username), b)
	prefixStore.Set(types.KeyPrefix(account.Account), b)
}

// HasPylonsAccount checks if the account exists in the store for either of the symmetric mappings
func (k Keeper) HasPylonsAccount(ctx sdk.Context, account types.UserMap) bool {
	prefixStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.UsernameKey))

	has := prefixStore.Has(types.KeyPrefix(account.Username))
	has = has || prefixStore.Has(types.KeyPrefix(account.Account))

	return has
}

// GetPylonsAccountByUsername returns a pylons account from using its username
func (k Keeper) GetPylonsAccountByUsername(ctx sdk.Context, username string) (val types.UserMap, found bool) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.UsernameKey))

	b := store.Get(types.KeyPrefix(username))
	if b == nil {
		return val, false
	}

	k.cdc.MustUnmarshalBinaryBare(b, &val)
	return val, true
}

// GetPylonsAccountByAddress returns a pylons account from using its cosmos address
func (k Keeper) GetPylonsAccountByAddress(ctx sdk.Context, address string) (val types.UserMap, found bool) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.UsernameKey))

	b := store.Get(types.KeyPrefix(address))
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
func (k Keeper) GetAllPylonsAccount(ctx sdk.Context) (list []types.UserMap) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.UsernameKey))
	iterator := sdk.KVStorePrefixIterator(store, []byte{})

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var val types.UserMap
		k.cdc.MustUnmarshalBinaryBare(iterator.Value(), &val)
		list = append(list, val)
	}

	return
}
