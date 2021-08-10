package keeper

import (
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// LockCoins sends an account's coins to the Coins Locker Module Account for Pylons
func (k Keeper) LockCoins(ctx sdk.Context, senderAddr sdk.AccAddress, amt sdk.Coins) error {
	err := k.bankKeeper.SendCoinsFromAccountToModule(ctx, senderAddr, types.PylonsCoinsLockerName, amt)
	if err != nil {
		return err
	}

	return nil
}

// UnlockCoins sends the locked coins from the Coins Locker Module Account to an account
func (k Keeper) UnlockCoins(ctx sdk.Context, recieverAddr sdk.AccAddress, amt sdk.Coins) error {
	err := k.bankKeeper.SendCoinsFromModuleToAccount(ctx, types.PylonsCoinsLockerName, recieverAddr, amt)
	if err != nil {
		return err
	}

	return nil
}
