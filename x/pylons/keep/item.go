package keep

import (
	"encoding/json"
	"errors"
	"strings"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// SetItem sets a item in the key store
func (k Keeper) SetItem(ctx sdk.Context, item types.Item) error {
	if item.Sender.Empty() {
		return errors.New("SetItem: the sender cannot be empty")
	}
	return k.SetObject(ctx, types.TypeItem, item.ID, k.ItemKey, item)
}

// GetItem returns item based on UUID
func (k Keeper) GetItem(ctx sdk.Context, id string) (types.Item, error) {
	item := types.Item{}
	err := k.GetObject(ctx, types.TypeItem, id, k.ItemKey, &item)
	return item, err
}

// GetItemsBySender returns all items by sender
func (k Keeper) GetItemsBySender(ctx sdk.Context, sender sdk.AccAddress) ([]types.Item, error) {
	store := ctx.KVStore(k.ItemKey)
	iter := sdk.KVStorePrefixIterator(store, []byte(""))

	var items []types.Item
	for ; iter.Valid(); iter.Next() {
		var item types.Item
		mIT := iter.Value()
		err := json.Unmarshal(mIT, &item)
		if err != nil {
			return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
		}
		if strings.Contains(item.Sender.String(), sender.String()) { // considered empty sender
			items = append(items, item)
		}
	}
	return items, nil
}

// GetAllItems returns all items
func (k Keeper) GetAllItems(ctx sdk.Context) ([]types.Item, error) {
	store := ctx.KVStore(k.ItemKey)
	iter := sdk.KVStorePrefixIterator(store, []byte(""))

	var items []types.Item
	for ; iter.Valid(); iter.Next() {
		var item types.Item
		mIT := iter.Value()
		err := json.Unmarshal(mIT, &item)
		if err != nil {
			return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
		}
		items = append(items, item)
	}
	return items, nil
}

func (k Keeper) GetAllItemsCount(ctx sdk.Context) int {
	items, _ := k.GetAllItems(ctx)
	return len(items)
}

// UpdateItem is used to update the item using the id
func (k Keeper) UpdateItem(ctx sdk.Context, id string, item types.Item) error {
	if item.Sender.Empty() {
		return errors.New("UpdateItem: the sender cannot be empty")

	}
	return k.UpdateObject(ctx, types.TypeItem, id, k.ItemKey, item)
}

// DeleteItem is used to delete the item
func (k Keeper) DeleteItem(ctx sdk.Context, id string) {
	//nolint:errcheck
	k.DeleteObject(ctx, types.TypeItem, id, k.ItemKey)
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
			return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
		}

		if cookbookID == item.CookbookID {
			items = append(items, item)
		}
	}
	return items, nil
}
