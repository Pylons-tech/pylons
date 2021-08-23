package keeper

import (
	"fmt"
	"strconv"

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

	// required for random seed init given how it's handled rn
	k.IncrementEntityCount(ctx)
}

// AppendItem appends an item in the store with a new id and update the count
func (k Keeper) AppendItem(
	ctx sdk.Context,
	item types.Item,
) string {
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
	keyPrefix := fmt.Sprintf("%s%s-", types.ItemKey, item.CookbookID)
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(keyPrefix))
	b := k.cdc.MustMarshalBinaryBare(&item)
	store.Set(types.KeyPrefix(item.ID), b)
}

// GetItem returns an item from its index
func (k Keeper) GetItem(ctx sdk.Context, cookbookID, id string) (val types.Item, found bool) {
	keyPrefix := fmt.Sprintf("%s%s-", types.ItemKey, cookbookID)
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(keyPrefix))
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

// Actualize function actualize an item from item output data
func (k Keeper) Actualize(ctx sdk.Context, cookbookID string, addr sdk.AccAddress, ec types.CelEnvCollection, io types.ItemOutput) (types.Item, error) {
	dblActualize, err := types.DoubleParamList(io.Doubles).Actualize(ec)
	if err != nil {
		return types.Item{}, err
	}
	longActualize, err := types.LongParamList(io.Longs).Actualize(ec)
	if err != nil {
		return types.Item{}, err
	}
	stringActualize, err := types.StringParamList(io.Strings).Actualize(ec)
	if err != nil {
		return types.Item{}, err
	}

	// transferFee := io.TransferFee

	// TODO
	// Can't we just remove the ec "lastBlockHeight" var entirely?
	// lastBlockHeight := ec.variables["lastBlockHeight"].(int64)

	count := k.GetItemCount(ctx)
	itemID := types.EncodeItemID(count + 1)
	k.SetItemCount(ctx, count+1)

	return types.Item{
		Owner:          addr.String(),
		CookbookID:     cookbookID,
		ID:             itemID,
		NodeVersion:    types.GetNodeVersionString(),
		Doubles:        dblActualize,
		Longs:          longActualize,
		Strings:        stringActualize,
		MutableStrings: nil,  // TODO HOW DO WE SET THIS?
		Tradeable:      true, // TODO HOW DO WE SET THIS?
		LastUpdate:     uint64(ctx.BlockHeight()),
		TransferFee:    io.TransferFee,
	}, nil
}
