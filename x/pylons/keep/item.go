package keep

import (
	"encoding/json"
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

	mi, err := json.Marshal(item)
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

	err := json.Unmarshal(ui, &item)
	return item, err
}

// GetItemsBySender returns all items by sender
func (k Keeper) GetItemsBySender(ctx sdk.Context, sender sdk.AccAddress) ([]types.Item, error) {
	store := ctx.KVStore(k.ItemKey)
	iter := sdk.KVStorePrefixIterator(store, []byte(sender.String()))

	var items []types.Item
	for ; iter.Valid(); iter.Next() {
		var item types.Item
		mIT := iter.Value()
		err := json.Unmarshal(mIT, &item)
		if err != nil {
			return nil, sdk.ErrInternal(err.Error())
		}

		items = append(items, item)
	}
	return items, nil
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
	mi, err := json.Marshal(item)
	if err != nil {
		return err
	}
	store.Set([]byte(id), mi)
	return nil
}

// DeleteItem is used to delete the item
func (k Keeper) DeleteItem(ctx sdk.Context, id string) {
	store := ctx.KVStore(k.ItemKey)
	store.Delete([]byte(id))
}

// ItemsByCookbook returns items by cookbook
func (k Keeper) ItemsByCookbook(ctx sdk.Context, cookbookID string) ([]types.Item, error) {
	store := ctx.KVStore(k.ItemKey)
	iter := sdk.KVStorePrefixIterator(store, []byte(""))
	var items []types.Item
	for ; iter.Valid(); iter.Next() {
		var item types.Item
		mIT := iter.Value()
		err := json.Unmarshal(mIT, &item)
		if err != nil {
			return nil, sdk.ErrInternal(err.Error())
		}

		if cookbookID == item.CookbookID {
			items = append(items, item)
		}
	}
	return items, nil
}
