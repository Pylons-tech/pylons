package keeper

import (
	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// SetItem set a specific item in the store from its index
func (k Keeper) SetItem(ctx sdk.Context, item types.Item) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.ItemKey+item.CookbookID+item.RecipeID))
	b := k.cdc.MustMarshalBinaryBare(&item)
	store.Set(types.KeyPrefix(item.ID), b)
}

// GetItem returns an item from its index
func (k Keeper) GetItem(ctx sdk.Context, cookbookID string, recipeID string, id string) (val types.Item, found bool) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.ItemKey+cookbookID+recipeID))

	b := store.Get(types.KeyPrefix(id))
	if b == nil {
		return val, false
	}

	k.cdc.MustUnmarshalBinaryBare(b, &val)
	return val, true
}

// GetAllItem returns all item
func (k Keeper) GetAllItem(ctx sdk.Context) (list []types.Item) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.ItemKey))
	iterator := sdk.KVStorePrefixIterator(store, []byte{})

	defer func(iterator sdk.Iterator) {
		err := iterator.Close()
		// nolint: staticcheck
		if err != nil {

		}
	}(iterator)

	for ; iterator.Valid(); iterator.Next() {
		var val types.Item
		k.cdc.MustUnmarshalBinaryBare(iterator.Value(), &val)
		list = append(list, val)
	}

	return
}
