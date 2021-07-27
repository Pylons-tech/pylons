package keeper

import (
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"strings"
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

// GetAllCookbook returns all cookbook
func (k Keeper) GetAllCookbook(ctx sdk.Context) (list []types.Cookbook) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.CookbookKey))
	iterator := sdk.KVStorePrefixIterator(store, []byte{})

	defer func(iterator sdk.Iterator) {
		err := iterator.Close()
		if err != nil {
		}
	}(iterator)

	for ; iterator.Valid(); iterator.Next() {
		var val types.Cookbook
		k.cdc.MustUnmarshalBinaryBare(iterator.Value(), &val)
		list = append(list, val)
	}

	return
}

// GetCookbooksByCreator returns cookbooks owned by a specific creator
func (k Keeper) GetCookbooksByCreator(ctx sdk.Context, creator sdk.AccAddress) (list []types.Cookbook) {
	iterator := sdk.KVStorePrefixIterator(ctx.KVStore(k.storeKey), types.KeyPrefix(types.CookbookKey))

	defer func(iterator sdk.Iterator) {
		err := iterator.Close()
		if err != nil {
		}
	}(iterator)

	for ; iterator.Valid(); iterator.Next() {
		var val types.Cookbook
		k.cdc.MustUnmarshalBinaryBare(iterator.Value(), &val)
		if strings.Contains(val.Creator, creator.String()) {
			list = append(list, val)
		}
	}

	return
}
