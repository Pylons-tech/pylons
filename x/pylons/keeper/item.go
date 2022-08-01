package keeper

import (
	"fmt"
	"strconv"
	"strings"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	"github.com/cosmos/cosmos-sdk/types/query"

	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// GetItemCount get the total number of items
func (k Keeper) GetItemCount(ctx sdk.Context) uint64 {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.ItemCountKey))
	byteKey := v1beta1.KeyPrefix(v1beta1.ItemCountKey)
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
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.ItemCountKey))
	byteKey := v1beta1.KeyPrefix(v1beta1.ItemCountKey)
	bz := []byte(strconv.FormatUint(count, 10))
	store.Set(byteKey, bz)
}

// AppendItem appends an item in the store with a new id and update the count
func (k Keeper) AppendItem(ctx sdk.Context, item v1beta1.Item) string {
	// Create the execution
	count := k.GetItemCount(ctx)

	item.Id = v1beta1.EncodeItemID(count)
	k.SetItem(ctx, item)

	// Update item count
	k.SetItemCount(ctx, count+1)

	return item.Id
}

// SetItem set a specific item in the store from its index
func (k Keeper) SetItem(ctx sdk.Context, item v1beta1.Item) {
	itemsStore := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.ItemKey))
	cookbookItemsStore := prefix.NewStore(itemsStore, v1beta1.KeyPrefix(item.CookbookId))
	b := k.cdc.MustMarshal(&item)
	cookbookItemsStore.Set(v1beta1.KeyPrefix(item.Id), b)

	addr, _ := sdk.AccAddressFromBech32(item.Owner)
	k.addItemToAddress(ctx, item.CookbookId, item.Id, addr)
	// required for random seed init given how it's handled rn
	k.IncrementEntityCount(ctx)
}

// UpdateItem updates an item removing it from previous owner store
func (k Keeper) UpdateItem(ctx sdk.Context, item v1beta1.Item, prevAddr sdk.AccAddress) {
	k.removeItemFromAddress(ctx, item.CookbookId, item.Id, prevAddr)
	k.SetItem(ctx, item)
}

// HasItem checks if the item exists in the store
func (k Keeper) HasItem(ctx sdk.Context, cookbookID, id string) bool {
	itemsStore := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.ItemKey))
	cookbookItemsStore := prefix.NewStore(itemsStore, v1beta1.KeyPrefix(cookbookID))
	return cookbookItemsStore.Has(v1beta1.KeyPrefix(id))
}

// GetItem returns an item from its index
func (k Keeper) GetItem(ctx sdk.Context, cookbookID, id string) (val v1beta1.Item, found bool) {
	itemsStore := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.ItemKey))
	cookbookItemsStore := prefix.NewStore(itemsStore, v1beta1.KeyPrefix(cookbookID))
	b := cookbookItemsStore.Get(v1beta1.KeyPrefix(id))
	if b == nil {
		return val, false
	}
	k.cdc.MustUnmarshal(b, &val)
	return val, true
}

// GetAllItem returns all item
func (k Keeper) GetAllItem(ctx sdk.Context) (list []v1beta1.Item) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.ItemKey))
	iterator := sdk.KVStorePrefixIterator(store, []byte{})

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var val v1beta1.Item
		k.cdc.MustUnmarshal(iterator.Value(), &val)
		list = append(list, val)
	}

	return
}

func (k Keeper) addItemToAddress(ctx sdk.Context, cookbookID, itemID string, addr sdk.AccAddress) {
	parentStore := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.AddrItemKey))
	addrStore := prefix.NewStore(parentStore, addr.Bytes())
	store := prefix.NewStore(addrStore, v1beta1.KeyPrefix(cookbookID))
	byteKey := v1beta1.KeyPrefix(itemID)
	bz := []byte(fmt.Sprintf("%v-%v", cookbookID, itemID))
	store.Set(byteKey, bz)
}

func (k Keeper) removeItemFromAddress(ctx sdk.Context, cookbookID, itemID string, addr sdk.AccAddress) {
	parentStore := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.AddrItemKey))
	addrStore := prefix.NewStore(parentStore, addr.Bytes())
	store := prefix.NewStore(addrStore, v1beta1.KeyPrefix(cookbookID))
	byteKey := v1beta1.KeyPrefix(itemID)
	store.Delete(byteKey)
}

func (k Keeper) GetAllItemByOwner(ctx sdk.Context, owner sdk.AccAddress) (list []v1beta1.Item) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.AddrItemKey))
	iterator := sdk.KVStorePrefixIterator(store, owner.Bytes())

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		idParts := strings.Split(string(iterator.Value()), "-")
		item, _ := k.GetItem(ctx, idParts[0], idParts[1])
		list = append(list, item)
	}

	return
}

func (k Keeper) GetItemsByOwnerPaginated(ctx sdk.Context, owner sdk.AccAddress, pagination *query.PageRequest) ([]v1beta1.Item, *query.PageResponse, error) {
	items := make([]v1beta1.Item, 0)

	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.AddrItemKey))
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
