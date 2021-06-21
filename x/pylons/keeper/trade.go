package keeper

import (
	"encoding/json"
	"errors"

	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// SetTrade sets a trade in the key store
func (keeper Keeper) SetTrade(ctx sdk.Context, trade types.Trade) error {
	if trade.Sender == "" {
		return errors.New("SetTrade: the sender cannot be empty")
	}
	return keeper.SetObject(ctx, types.TypeTrade, trade.ID, keeper.TradeKey, trade)
}

// GetTrade returns trade based on UUID
func (keeper Keeper) GetTrade(ctx sdk.Context, id string) (types.Trade, error) {
	trade := types.Trade{}
	err := keeper.GetObject(ctx, types.TypeTrade, id, keeper.TradeKey, &trade)
	return trade, err
}

// GetTradesIteratorByCreator returns an iterator for all the trades created by the sender
func (keeper Keeper) GetTradesIteratorByCreator(ctx sdk.Context, sender sdk.AccAddress) sdk.Iterator {
	store := ctx.KVStore(keeper.TradeKey)
	return sdk.KVStorePrefixIterator(store, []byte(sender.String()))
}

// GetTradesIterator returns an iterator for all the trades
func (keeper Keeper) GetTradesIterator(ctx sdk.Context) sdk.Iterator {
	store := ctx.KVStore(keeper.TradeKey)
	return sdk.KVStorePrefixIterator(store, []byte(""))
}

// GetTradesByCreator returns trades array by sender
func (keeper Keeper) GetTradesByCreator(ctx sdk.Context, sender sdk.AccAddress) ([]types.Trade, error) {
	var trades []types.Trade
	iterator := keeper.GetTradesIteratorByCreator(ctx, sender)
	for ; iterator.Valid(); iterator.Next() {
		var trade types.Trade
		mRCP := iterator.Value()
		err := json.Unmarshal(mRCP, &trade)
		if err != nil {
			return trades, err
		}
		trades = append(trades, trade)
	}
	return trades, nil
}

// UpdateTrade is used to update the trade using the id
func (keeper Keeper) UpdateTrade(ctx sdk.Context, id string, trade types.Trade) error {
	if trade.Sender == "" {
		return errors.New("UpdateTrade: the sender cannot be empty")

	}
	return keeper.UpdateObject(ctx, types.TypeTrade, id, keeper.TradeKey, trade)
}
