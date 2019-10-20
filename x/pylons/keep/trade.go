package keep

import (
	"encoding/json"
	"errors"
	"fmt"

	"github.com/MikeSofaer/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// SetTrade sets a trade in the key store
func (k Keeper) SetTrade(ctx sdk.Context, trade types.Trade) error {
	if trade.Sender.Empty() {
		return errors.New("SetTrade: the sender cannot be empty")
	}
	mr, err := json.Marshal(trade)
	if err != nil {
		return err
	}

	store := ctx.KVStore(k.TradeKey)
	store.Set([]byte(trade.ID), mr)
	return nil
}

// GetTrade returns trade based on UUID
func (k Keeper) GetTrade(ctx sdk.Context, id string) (types.Trade, error) {
	store := ctx.KVStore(k.TradeKey)

	if !store.Has([]byte(id)) {
		return types.Trade{}, errors.New("The trade doesn't exist")
	}

	ur := store.Get([]byte(id))
	var trade types.Trade
	err := json.Unmarshal(ur, &trade)

	return trade, err
}

// GetTradesIterator returns an iterator for all the iterator
func (k Keeper) GetTradesIterator(ctx sdk.Context, sender sdk.AccAddress) sdk.Iterator {
	store := ctx.KVStore(k.TradeKey)
	return sdk.KVStorePrefixIterator(store, []byte(sender.String()))
}

// UpdateTrade is used to update the trade using the id
func (k Keeper) UpdateTrade(ctx sdk.Context, id string, trade types.Trade) error {
	if trade.Sender.Empty() {
		return errors.New("UpdateTrade: the sender cannot be empty")

	}
	store := ctx.KVStore(k.TradeKey)

	if !store.Has([]byte(id)) {
		return fmt.Errorf("the trade with gid %s does not exist", id)
	}
	mr, err := json.Marshal(trade)
	if err != nil {
		return err
	}
	store.Set([]byte(id), mr)
	return nil
}
