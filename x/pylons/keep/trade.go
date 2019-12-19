package keep

import (
	"errors"

	"github.com/MikeSofaer/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// SetTrade sets a trade in the key store
func (k Keeper) SetTrade(ctx sdk.Context, trade types.Trade) error {
	if trade.Sender.Empty() {
		return errors.New("SetTrade: the sender cannot be empty")
	}
	return k.SetObject(ctx, types.TypeTrade, trade.ID, k.TradeKey, trade)
}

// GetTrade returns trade based on UUID
func (k Keeper) GetTrade(ctx sdk.Context, id string) (types.Trade, error) {
	trade := types.Trade{}
	err := k.GetObject(ctx, types.TypeTrade, id, k.TradeKey, &trade)
	return trade, err
}

// GetTradesIteratorByCreator returns an iterator for all the trades created by the sender
func (k Keeper) GetTradesIteratorByCreator(ctx sdk.Context, sender sdk.AccAddress) sdk.Iterator {
	store := ctx.KVStore(k.TradeKey)
	return sdk.KVStorePrefixIterator(store, []byte(sender.String()))
}

// GetTradesIterator returns an iterator for all the trades
func (k Keeper) GetTradesIterator(ctx sdk.Context) sdk.Iterator {
	store := ctx.KVStore(k.TradeKey)
	return sdk.KVStorePrefixIterator(store, []byte(""))
}

// UpdateTrade is used to update the trade using the id
func (k Keeper) UpdateTrade(ctx sdk.Context, id string, trade types.Trade) error {
	if trade.Sender.Empty() {
		return errors.New("UpdateTrade: the sender cannot be empty")

	}
	return k.UpdateObject(ctx, types.TypeTrade, id, k.TradeKey, trade)
}
