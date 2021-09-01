package keeper

import (
	"encoding/binary"
	"strconv"

	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// GetTradeCount get the total number of TypeName.LowerCamel
func (k Keeper) GetTradeCount(ctx sdk.Context) uint64 {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.TradeCountKey))
	byteKey := types.KeyPrefix(types.TradeCountKey)
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

// SetTradeCount set the total number of trade
func (k Keeper) SetTradeCount(ctx sdk.Context, count uint64) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.TradeCountKey))
	byteKey := types.KeyPrefix(types.TradeCountKey)
	bz := []byte(strconv.FormatUint(count, 10))
	store.Set(byteKey, bz)
}

// AppendTrade appends a trade in the store with a new id and update the count
func (k Keeper) AppendTrade(
	ctx sdk.Context,
	trade types.Trade,
) uint64 {
	// Create the trade
	count := k.GetTradeCount(ctx)

	// Set the ID of the appended value
	trade.ID = count

	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.TradeKey))
	appendedValue := k.cdc.MustMarshalBinaryBare(&trade)
	store.Set(GetTradeIDBytes(trade.ID), appendedValue)

	// Update trade count
	k.SetTradeCount(ctx, count+1)

	return count
}

// SetTrade set a specific trade in the store
func (k Keeper) SetTrade(ctx sdk.Context, trade types.Trade) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.TradeKey))
	b := k.cdc.MustMarshalBinaryBare(&trade)
	store.Set(GetTradeIDBytes(trade.ID), b)
}

// GetTrade returns a trade from its id
func (k Keeper) GetTrade(ctx sdk.Context, id uint64) types.Trade {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.TradeKey))
	var trade types.Trade
	k.cdc.MustUnmarshalBinaryBare(store.Get(GetTradeIDBytes(id)), &trade)
	return trade
}

// HasTrade checks if the trade exists in the store
func (k Keeper) HasTrade(ctx sdk.Context, id uint64) bool {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.TradeKey))
	return store.Has(GetTradeIDBytes(id))
}

// GetTradeOwner returns the creator of the
func (k Keeper) GetTradeOwner(ctx sdk.Context, id uint64) string {
	return k.GetTrade(ctx, id).Creator
}

// RemoveTrade removes a trade from the store
func (k Keeper) RemoveTrade(ctx sdk.Context, id uint64) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.TradeKey))
	store.Delete(GetTradeIDBytes(id))
}

// GetAllTrade returns all trade
func (k Keeper) GetAllTrade(ctx sdk.Context) (list []types.Trade) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.TradeKey))
	iterator := sdk.KVStorePrefixIterator(store, []byte{})

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var val types.Trade
		k.cdc.MustUnmarshalBinaryBare(iterator.Value(), &val)
		list = append(list, val)
	}

	return
}

// GetTradeIDBytes returns the byte representation of the ID
func GetTradeIDBytes(id uint64) []byte {
	bz := make([]byte, 8)
	binary.BigEndian.PutUint64(bz, id)
	return bz
}

// GetTradeIDFromBytes returns ID in uint64 format from a byte array
func GetTradeIDFromBytes(bz []byte) uint64 {
	return binary.BigEndian.Uint64(bz)
}
