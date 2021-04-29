package keeper

import (
	"errors"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// SetItemHistory sets a ItemHistory in the key store
func (k Keeper) SetItemHistory(ctx sdk.Context, history types.ItemHistory) error {
	if history.ID == "" {
		return errors.New("SetItemHistory: history ID cannot be empty")
	}
	return k.SetObject(ctx, types.TypeItemHistory, history.ID, k.HistoryKey, history)
}

// GetItemHistory returns ItemHistory based on UUID
func (k Keeper) GetItemHistory(ctx sdk.Context, id string) (types.ItemHistory, error) {
	history := types.ItemHistory{}
	err := k.GetObject(ctx, types.TypeItemHistory, id, k.HistoryKey, &history)
	return history, err
}

// GetItemHistoryIterator returns an iterator for all the item history
func (k Keeper) GetItemHistoryIterator(ctx sdk.Context) sdk.Iterator {
	store := ctx.KVStore(k.HistoryKey)
	return sdk.KVStorePrefixIterator(store, []byte(""))
}
