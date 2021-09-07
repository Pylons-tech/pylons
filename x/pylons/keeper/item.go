package keeper

import (
	"fmt"
	"strconv"
	"strings"

	"github.com/cosmos/cosmos-sdk/types/query"

	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// GetItemCount get the total number of items
func (k Keeper) GetItemCount(ctx sdk.Context) uint64 {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.ItemCountKey))
	byteKey := types.KeyPrefix(types.ItemCountKey)
	bz := store.Get(byteKey)

	// Count doesn't exist: no element
	if bz == nil {
		return 0
	}

	// Parse bytes
	count, err := strconv.ParseUint(string(bz), 10, 64)
	if err != nil {
		// Panic because the count should be always formattable to uint64
		panic("cannot decode count")
	}

	return count
}

// SetItemCount set the total number of items
func (k Keeper) SetItemCount(ctx sdk.Context, count uint64) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.ItemCountKey))
	byteKey := types.KeyPrefix(types.ItemCountKey)
	bz := []byte(strconv.FormatUint(count, 10))
	store.Set(byteKey, bz)
}

// AppendItem appends an item in the store with a new id and update the count
func (k Keeper) AppendItem(ctx sdk.Context, item types.Item) string {
	// Create the execution
	count := k.GetItemCount(ctx)

	item.ID = types.EncodeItemID(count)
	k.SetItem(ctx, item)

	// Update item count
	k.SetItemCount(ctx, count+1)

	return item.ID
}

// SetItem set a specific item in the store from its index
func (k Keeper) SetItem(ctx sdk.Context, item types.Item) {
	itemsStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.ItemKey))
	cookbookItemsStore := prefix.NewStore(itemsStore, types.KeyPrefix(item.CookbookID))
	b := k.cdc.MustMarshal(&item)
	cookbookItemsStore.Set(types.KeyPrefix(item.ID), b)

	addr, _ := sdk.AccAddressFromBech32(item.Owner)
	k.addItemToAddress(ctx, item.CookbookID, item.ID, addr)
	// required for random seed init given how it's handled rn
	k.IncrementEntityCount(ctx)
}

// UpdateItem updates an item removing it from previous owner store
func (k Keeper) UpdateItem(ctx sdk.Context, item types.Item, prevAddr sdk.AccAddress) {
	k.removeItemFromAddress(ctx, item.CookbookID, item.ID, prevAddr)
	k.SetItem(ctx, item)
}

// HasItem checks if the item exists in the store
func (k Keeper) HasItem(ctx sdk.Context, cookbookID, id string) bool {
	itemsStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.ItemKey))
	cookbookItemsStore := prefix.NewStore(itemsStore, types.KeyPrefix(cookbookID))
	return cookbookItemsStore.Has(types.KeyPrefix(id))
}

// GetItem returns an item from its index
func (k Keeper) GetItem(ctx sdk.Context, cookbookID, id string) (val types.Item, found bool) {
	itemsStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.ItemKey))
	cookbookItemsStore := prefix.NewStore(itemsStore, types.KeyPrefix(cookbookID))
	b := cookbookItemsStore.Get(types.KeyPrefix(id))
	if b == nil {
		return val, false
	}
	k.cdc.MustUnmarshal(b, &val)
	return val, true
}

// GetAllItem returns all item
func (k Keeper) GetAllItem(ctx sdk.Context) (list []types.Item) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.ItemKey))
	iterator := sdk.KVStorePrefixIterator(store, []byte{})

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var val types.Item
		k.cdc.MustUnmarshal(iterator.Value(), &val)
		list = append(list, val)
	}

	return
}

func (k Keeper) addItemToAddress(ctx sdk.Context, cookbookID, itemID string, addr sdk.AccAddress) {
	parentStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.AddrItemKey))
	addrStore := prefix.NewStore(parentStore, addr.Bytes())
	store := prefix.NewStore(addrStore, types.KeyPrefix(cookbookID))
	byteKey := types.KeyPrefix(itemID)
	bz := []byte(fmt.Sprintf("%v-%v", cookbookID, itemID))
	store.Set(byteKey, bz)
}

func (k Keeper) removeItemFromAddress(ctx sdk.Context, cookbookID, itemID string, addr sdk.AccAddress) {
	parentStore := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.AddrItemKey))
	addrStore := prefix.NewStore(parentStore, addr.Bytes())
	store := prefix.NewStore(addrStore, types.KeyPrefix(cookbookID))
	byteKey := types.KeyPrefix(itemID)
	store.Delete(byteKey)
}

func (k Keeper) GetAllItemByOwner(ctx sdk.Context, owner sdk.AccAddress) (list []types.Item) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.AddrItemKey))
	iterator := sdk.KVStorePrefixIterator(store, owner.Bytes())

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		idParts := strings.Split(string(iterator.Value()), "-")
		item, _ := k.GetItem(ctx, idParts[0], idParts[1])
		list = append(list, item)
	}

	return
}

func (k Keeper) getItemsByOwnerPaginated(ctx sdk.Context, owner sdk.AccAddress, pagination *query.PageRequest) ([]types.Item, *query.PageResponse, error) {
	items := make([]types.Item, 0)

	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.AddrItemKey))
	store = prefix.NewStore(store, owner.Bytes())

	pageRes, err := query.Paginate(store, pagination, func(_, value []byte) error {
		idParts := strings.Split(string(value), "-")
		item, _ := k.GetItem(ctx, idParts[0], idParts[1])
		items = append(items, item)
		return nil
	})

	if err != nil {
		return nil, nil, err
	}

	return items, pageRes, nil
}
