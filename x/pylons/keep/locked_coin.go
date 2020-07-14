package keep

import (
	"encoding/json"
	"errors"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// LockCoin sets the lockedCoin with the name as the key
func (k Keeper) LockCoin(ctx sdk.Context, lockedCoin types.LockedCoin) error {
	if lockedCoin.Sender.Empty() {
		return errors.New("LockCoin: the sender cannot be empty")
	}

	oldLc, err := k.GetLockedCoin(ctx, lockedCoin.Sender)

	if err != nil {
		return k.SetObject(ctx, types.TypeLockedCoin, lockedCoin.Sender.String(), k.LockedCoinKey, lockedCoin)
	}

	newAmount := oldLc.Amount.Add(lockedCoin.Amount.Sort()...)

	lc := types.LockedCoin{}

	lc.Sender = lockedCoin.Sender
	lc.Amount = newAmount

	return k.updateLockedCoin(ctx, lc)
}

// UnlockCoin unlock coin from keeper
func (k Keeper) UnlockCoin(ctx sdk.Context, lockedCoin types.LockedCoin) error {
	if lockedCoin.Sender.Empty() {
		return errors.New("LockCoin: the sender cannot be empty")
	}

	oldLc, err := k.GetLockedCoin(ctx, lockedCoin.Sender)

	var newAmount sdk.Coins

	// the locked coin doesn't exist
	if err != nil {
		return err
	}

	// Compare already locked amount and unlocking amount
	if oldLc.Amount.IsAllGTE(lockedCoin.Amount) {
		newAmount = oldLc.Amount.Sub(lockedCoin.Amount.Sort())

		if newAmount.IsZero() {
			return k.DeleteLockedCoin(ctx, oldLc.Sender)
		}

		lc := types.LockedCoin{}

		lc.Sender = lockedCoin.Sender
		lc.Amount = newAmount

		return k.updateLockedCoin(ctx, lc)
	}

	return errors.New("Unlocking amount exceeds the locked amount")
}

// GetLockedCoin returns lockedCoin based on UUID
func (k Keeper) GetLockedCoin(ctx sdk.Context, sender sdk.AccAddress) (types.LockedCoin, error) {
	lockedCoin := types.LockedCoin{}
	err := k.GetObject(ctx, types.TypeLockedCoin, sender.String(), k.LockedCoinKey, &lockedCoin)

	return lockedCoin, err
}

func (k Keeper) updateLockedCoin(ctx sdk.Context, lockedCoin types.LockedCoin) error {
	if lockedCoin.Sender.Empty() {
		return errors.New("updateLockedCoin: the sender cannot be empty")
	}

	return k.UpdateObject(ctx, types.TypeLockedCoin, lockedCoin.Sender.String(), k.LockedCoinKey, lockedCoin)
}

// GetLockedCoinsIterator returns an iterator for all the lockedCoins
func (k Keeper) GetLockedCoinsIterator(ctx sdk.Context) sdk.Iterator {
	store := ctx.KVStore(k.LockedCoinKey)
	return sdk.KVStorePrefixIterator(store, []byte(""))
}

// GetAllLockedCoins returns all lockedCoins
func (k Keeper) GetAllLockedCoins(ctx sdk.Context) ([]types.LockedCoin, error) {

	var lockedCoins []types.LockedCoin
	iterator := k.GetLockedCoinsIterator(ctx)

	for ; iterator.Valid(); iterator.Next() {

		var lockedCoin types.LockedCoin

		mCB := iterator.Value()
		err := json.Unmarshal(mCB, &lockedCoin)

		if err != nil {
			return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
		}

		lockedCoins = append(lockedCoins, lockedCoin)
	}

	return lockedCoins, nil
}

// GetAllLockedCoinsCount returns the lockedCoin count returns 0 if no lockedCoin is found
func (k Keeper) GetAllLockedCoinsCount(ctx sdk.Context) int {
	lockedCoins, _ := k.GetAllLockedCoins(ctx)
	return len(lockedCoins)
}

// DeleteLockedCoin is used to delete a lockedCoin based on the id
func (k Keeper) DeleteLockedCoin(ctx sdk.Context, sender sdk.AccAddress) error {
	return k.DeleteObject(ctx, types.TypeLockedCoin, sender.String(), k.LockedCoinKey)
}
