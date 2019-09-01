package keep

import (
	"errors"
	"fmt"

	"github.com/MikeSofaer/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// SetItem sets a item in the key store
func (k Keeper) SetItem(ctx sdk.Context, item types.Item) error {
	if item.Sender.Empty() {
		return errors.New("SetItem: the sender cannot be empty")
	}
	mi, err := k.Cdc.MarshalBinaryBare(item)
	if err != nil {
		return err
	}

	store := ctx.KVStore(k.ItemKey)
	store.Set([]byte(item.ID), mi)
	return nil
}

// GetItem returns item based on UUID
func (k Keeper) GetItem(ctx sdk.Context, id string) (types.Item, error) {
	store := ctx.KVStore(k.ItemKey)

	if !store.Has([]byte(id)) {
		return types.Item{}, errors.New("The item doesn't exist")
	}

	ui := store.Get([]byte(id))
	var item types.Item

	k.Cdc.MustUnmarshalBinaryBare(ui, &item)
	return item, nil
}

// GetItemsIterator returns an iterator for all the iterator
func (k Keeper) GetItemsIterator(ctx sdk.Context, sender sdk.AccAddress) sdk.Iterator {
	store := ctx.KVStore(k.ItemKey)
	return sdk.KVStorePrefixIterator(store, []byte(sender.String()))
}

// UpdateItem is used to update the item using the id
func (k Keeper) UpdateItem(ctx sdk.Context, id string, item types.Item) error {
	if item.Sender.Empty() {
		return errors.New("UpdateItem: the sender cannot be empty")

	}
	store := ctx.KVStore(k.ItemKey)

	if !store.Has([]byte(id)) {
		return fmt.Errorf("the item with gid %s does not exist", id)
	}
	mi, err := k.Cdc.MarshalBinaryBare(item)
	if err != nil {
		return err
	}
	store.Set([]byte(id), mi)
	return nil
}
