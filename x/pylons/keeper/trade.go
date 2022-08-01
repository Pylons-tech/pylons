package keeper

import (
	"encoding/binary"
	"strconv"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/query"
)

// GetTradeCount get the total number of TypeName.LowerCamel
func (k Keeper) GetTradeCount(ctx sdk.Context) uint64 {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.TradeCountKey))
	byteKey := v1beta1.KeyPrefix(v1beta1.TradeCountKey)
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
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.TradeCountKey))
	byteKey := v1beta1.KeyPrefix(v1beta1.TradeCountKey)
	bz := []byte(strconv.FormatUint(count, 10))
	store.Set(byteKey, bz)
}

// AppendTrade appends a trade in the store with a new id and update the count
func (k Keeper) AppendTrade(
	ctx sdk.Context,
	trade v1beta1.Trade,
) uint64 {
	// Create the trade
	count := k.GetTradeCount(ctx)

	// Set the ID of the appended value
	trade.Id = count

	k.SetTrade(ctx, trade)

	// Update trade count
	k.SetTradeCount(ctx, count+1)

	return count
}

// SetTrade set a specific trade in the store
func (k Keeper) SetTrade(ctx sdk.Context, trade v1beta1.Trade) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.TradeKey))
	b := k.cdc.MustMarshal(&trade)

	addr, _ := sdk.AccAddressFromBech32(trade.Creator)
	k.addTradeToAddress(ctx, getTradeIDBytes(trade.Id), addr)

	store.Set(getTradeIDBytes(trade.Id), b)
}

// GetTrade returns a trade from its id
func (k Keeper) GetTrade(ctx sdk.Context, id uint64) v1beta1.Trade {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.TradeKey))
	var trade v1beta1.Trade
	k.cdc.MustUnmarshal(store.Get(getTradeIDBytes(id)), &trade)
	return trade
}

// HasTrade checks if the trade exists in the store
func (k Keeper) HasTrade(ctx sdk.Context, id uint64) bool {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.TradeKey))
	return store.Has(getTradeIDBytes(id))
}

// GetTradeOwner returns the creator of the
func (k Keeper) GetTradeOwner(ctx sdk.Context, id uint64) string {
	return k.GetTrade(ctx, id).Creator
}

// RemoveTrade removes a trade from the store
func (k Keeper) RemoveTrade(ctx sdk.Context, id uint64, creator sdk.AccAddress) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.TradeKey))
	k.removeTradeFromAddress(ctx, getTradeIDBytes(id), creator)
	store.Delete(getTradeIDBytes(id))
}

// GetAllTrade returns all trade
func (k Keeper) GetAllTrade(ctx sdk.Context) (list []v1beta1.Trade) {
	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.TradeKey))
	iterator := sdk.KVStorePrefixIterator(store, []byte{})

	defer iterator.Close()

	for ; iterator.Valid(); iterator.Next() {
		var val v1beta1.Trade
		k.cdc.MustUnmarshal(iterator.Value(), &val)
		list = append(list, val)
	}

	return
}

func getTradeIDBytes(id uint64) []byte {
	bz := make([]byte, 8)
	binary.BigEndian.PutUint64(bz, id)
	return bz
}

func (k Keeper) addTradeToAddress(ctx sdk.Context, tradeIDBytes []byte, addr sdk.AccAddress) {
	parentStore := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.AddrTradeKey))
	addrStore := prefix.NewStore(parentStore, addr.Bytes())
	addrStore.Set(tradeIDBytes, tradeIDBytes)
}

func (k Keeper) removeTradeFromAddress(ctx sdk.Context, tradeIDBytes []byte, addr sdk.AccAddress) {
	parentStore := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.AddrTradeKey))
	addrStore := prefix.NewStore(parentStore, addr.Bytes())
	addrStore.Delete(tradeIDBytes)
}

func (k Keeper) GetTradesByCreatorPaginated(ctx sdk.Context, creator sdk.AccAddress, pagination *query.PageRequest) ([]v1beta1.Trade, *query.PageResponse, error) {
	trades := make([]v1beta1.Trade, 0)

	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.AddrTradeKey))
	store = prefix.NewStore(store, creator.Bytes())

	pageRes, err := query.Paginate(store, pagination, func(_, value []byte) error {
		id := binary.BigEndian.Uint64(value)
		trade := k.GetTrade(ctx, id)
		trades = append(trades, trade)
		return nil
	})
	if err != nil {
		return nil, nil, err
	}

	return trades, pageRes, nil
}
