package keeper

import (
	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// SetPylonsAccount set a specific pylons account in the store from its index
// this function sets two symmetric KVStores with address -> username
// and username -> address mappings
func (k Keeper) SetPylonsAccount(ctx sdk.Context, accountAddr types.AccountAddr, username types.Username) {
	binaryAddr := k.cdc.MustMarshalBinaryBare(&accountAddr)
	binaryUsername := k.cdc.MustMarshalBinaryBare(&username)
	usernamePrefixStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.UsernameKey))
	accountPrefixStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.AccountKey))

	usernamePrefixStore.Set(types.KeyPrefix(username.Value), binaryAddr)
	accountPrefixStore.Set(types.KeyPrefix(accountAddr.Value), binaryUsername)
}

// HasUsername checks if the username exists in the store
func (k Keeper) HasUsername(ctx sdk.Context, username types.Username) bool {
	usernamePrefixStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.UsernameKey))

	has := usernamePrefixStore.Has(types.KeyPrefix(username.Value))

	return has
}

// HasAccountAddr checks if the accountAddr exists in the store
func (k Keeper) HasAccountAddr(ctx sdk.Context, accountAddr types.AccountAddr) bool {
	accountPrefixStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.AccountKey))

	has := accountPrefixStore.Has(types.KeyPrefix(accountAddr.Value))

	return has
}

// GetAddressByUsername returns an address corresponding to its username
func (k Keeper) GetAddressByUsername(ctx sdk.Context, username string) (val types.AccountAddr, found bool) {
	usernamePrefixStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.UsernameKey))

	b := usernamePrefixStore.Get(types.KeyPrefix(username))
	if b == nil {
		return val, false
	}

	k.cdc.MustUnmarshalBinaryBare(b, &val)
	return val, true
}

// GetUsernameByAddress returns a username corresponding to its address
func (k Keeper) GetUsernameByAddress(ctx sdk.Context, address string) (val types.Username, found bool) {
	accountPrefixStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.AccountKey))

	b := accountPrefixStore.Get(types.KeyPrefix(address))
	if b == nil {
		return val, false
	}

	k.cdc.MustUnmarshalBinaryBare(b, &val)
	return val, true
}

// GetAllPylonsAccount returns symmetric username mappings
func (k Keeper) GetAllPylonsAccount(ctx sdk.Context) (list []types.UserMap) {
	usernamePrefixStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.UsernameKey))
	iterator := sdk.KVStorePrefixIterator(usernamePrefixStore, []byte{})

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var account types.AccountAddr
		k.cdc.MustUnmarshalBinaryBare(iterator.Value(), &account)
		username, found := k.GetUsernameByAddress(ctx, account.Value)
		if found {
			list = append(list, types.UserMap{Account: account.Value, Username: username.Value})
		}

	}

	return
}
