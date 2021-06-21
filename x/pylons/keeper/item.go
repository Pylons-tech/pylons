package keeper

import (
	"encoding/json"
	"errors"
	"strings"

	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// SetItem sets a item in the key store
func (keeper Keeper) SetItem(ctx sdk.Context, item types.Item) error {
	if item.Sender == "" {
		return errors.New("SetItem: the sender cannot be empty")
	}
	return keeper.SetObject(ctx, types.TypeItem, item.ID, keeper.ItemKey, item)
}

// GetItem returns item based on UUID
func (keeper Keeper) GetItem(ctx sdk.Context, id string) (types.Item, error) {
	item := types.Item{}
	err := keeper.GetObject(ctx, types.TypeItem, id, keeper.ItemKey, &item)
	return item, err
}

// GetItemsBySender returns all items by sender
func (keeper Keeper) GetItemsBySender(ctx sdk.Context, sender sdk.AccAddress) ([]types.Item, error) {
	store := ctx.KVStore(keeper.ItemKey)
	iter := sdk.KVStorePrefixIterator(store, []byte(""))

	var items []types.Item
	for ; iter.Valid(); iter.Next() {
		var item types.Item
		mIT := iter.Value()
		err := json.Unmarshal(mIT, &item)
		if err != nil {
			return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
		}
		if strings.Contains(item.Sender, sender.String()) { // considered empty sender
			items = append(items, item)
		}
	}
	return items, nil
}

// GetAllItems returns all items
func (keeper Keeper) GetAllItems(ctx sdk.Context) ([]types.Item, error) {
	store := ctx.KVStore(keeper.ItemKey)
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

// GetAllItemsCount returns items count
func (keeper Keeper) GetAllItemsCount(ctx sdk.Context) int {
	items, _ := keeper.GetAllItems(ctx)
	return len(items)
}

// UpdateItem is used to update the item using the id
func (keeper Keeper) UpdateItem(ctx sdk.Context, id string, item types.Item) error {
	if item.Sender == "" {
		return errors.New("UpdateItem: the sender cannot be empty")

	}
	return keeper.UpdateObject(ctx, types.TypeItem, id, keeper.ItemKey, item)
}

// DeleteItem is used to delete the item
func (keeper Keeper) DeleteItem(ctx sdk.Context, id string) {
	//nolint:errcheck
	keeper.DeleteObject(ctx, types.TypeItem, id, keeper.ItemKey)
}

// ItemsByCookbook returns items by cookbook
func (keeper Keeper) ItemsByCookbook(ctx sdk.Context, cookbookID string) ([]types.Item, error) {
	store := ctx.KVStore(keeper.ItemKey)
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
