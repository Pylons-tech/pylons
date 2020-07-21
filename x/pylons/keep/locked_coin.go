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

	originLock := k.GetLockedCoin(ctx, lockedCoin.Sender)
	newLock := originLock.Amount.Add(lockedCoin.Amount.Sort()...)
	senderBalance := k.CoinKeeper.GetCoins(ctx, lockedCoin.Sender)

	if !senderBalance.IsAllGTE(newLock) {
		return errors.New("LockCoin: the sender does not have enough amount to lock")
	}

	if originLock.Amount.Empty() {
		return k.SetObject(ctx, types.TypeLockedCoin, lockedCoin.Sender.String(), k.LockedCoinKey, lockedCoin)
	}

	return k.updateLockedCoin(ctx, types.NewLockedCoin(lockedCoin.Sender, newLock))
}

// UnlockCoin unlock coin from keeper
func (k Keeper) UnlockCoin(ctx sdk.Context, lockedCoin types.LockedCoin) error {
	if lockedCoin.Sender.Empty() {
		return errors.New("LockCoin: the sender cannot be empty")
	}

	originLock := k.GetLockedCoin(ctx, lockedCoin.Sender)
	var newLock sdk.Coins

	// Compare already locked amount and unlocking amount
	if originLock.Amount.IsAllGTE(lockedCoin.Amount) {
		newLock = originLock.Amount.Sub(lockedCoin.Amount.Sort())

		if newLock.IsZero() {
			return k.DeleteLockedCoin(ctx, originLock.Sender)
		}

		return k.updateLockedCoin(ctx, types.NewLockedCoin(lockedCoin.Sender, newLock))
	}

	return errors.New("Unlocking amount exceeds the locked amount")
}

// GetLockedCoin returns lockedCoin based on sender
func (k Keeper) GetLockedCoin(ctx sdk.Context, sender sdk.AccAddress) types.LockedCoin {
	lockedCoin := types.LockedCoin{}
	err := k.GetObject(ctx, types.TypeLockedCoin, sender.String(), k.LockedCoinKey, &lockedCoin)
	if err != nil {
		lockedCoin.Sender = sender
		lockedCoin.Amount = sdk.Coins{}
	}
	return lockedCoin
}

// GetLockedCoinDetails return lockedCoinDetails based on sender
func (k Keeper) GetLockedCoinDetails(ctx sdk.Context, sender sdk.AccAddress) types.LockedCoinDetails {
	lcd := types.LockedCoinDetails{}
	lc := k.GetLockedCoin(ctx, sender)
	lcd.Sender, lcd.Amount = lc.Sender, lc.Amount

	if !sender.Empty() {
		iterator := k.GetTradesIteratorByCreator(ctx, sender)
		for ; iterator.Valid(); iterator.Next() {
			var trade types.Trade
			mRCP := iterator.Value()
			err := json.Unmarshal(mRCP, &trade)
			if err != nil {
				// this happens because we have multiple versions of breaking trades at times
				continue
			}

			if !trade.Disabled && !trade.CoinOutputs.Empty() {
				lcd.LockCoinTrades = append(lcd.LockCoinTrades, types.LockedCoinDescribe{
					ID:     trade.ID,
					Amount: trade.CoinOutputs,
				})
			}
		}
		execs, err := k.GetExecutionsBySender(ctx, sender)
		if err == nil {
			for _, exec := range execs {
				if !exec.CoinInputs.Empty() {
					lcd.LockCoinExecs = append(lcd.LockCoinExecs, types.LockedCoinDescribe{
						ID:     exec.ID,
						Amount: exec.CoinInputs,
					})
				}
			}
		}
	}

	return lcd
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

// DeleteLockedCoin is used to delete a lockedCoin based on the sender
func (k Keeper) DeleteLockedCoin(ctx sdk.Context, sender sdk.AccAddress) error {
	return k.DeleteObject(ctx, types.TypeLockedCoin, sender.String(), k.LockedCoinKey)
}
