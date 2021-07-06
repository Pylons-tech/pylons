package keeper

import (
	"errors"

	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// SetItemHistory sets a ItemHistory in the key store
func (keeper Keeper) SetItemHistory(ctx sdk.Context, history types.ItemHistory) error {
	if history.ID == "" {
		return errors.New("SetItemHistory: history ID cannot be empty")
	}
	return keeper.SetObject(ctx, types.TypeItemHistory, history.ID, keeper.HistoryKey, history)
}

// GetItemHistory returns ItemHistory based on UUID
func (keeper Keeper) GetItemHistory(ctx sdk.Context, id string) (types.ItemHistory, error) {
	history := types.ItemHistory{}
	err := keeper.GetObject(ctx, types.TypeItemHistory, id, keeper.HistoryKey, &history)
	return history, err
}

// GetItemHistoryIterator returns an iterator for all the item history
func (keeper Keeper) GetItemHistoryIterator(ctx sdk.Context) sdk.Iterator {
	store := ctx.KVStore(keeper.HistoryKey)
	return sdk.KVStorePrefixIterator(store, []byte(""))
}
