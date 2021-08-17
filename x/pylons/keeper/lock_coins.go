package keeper

import (
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// lockCoins sends an account's coins to the given module account
func (k Keeper) lockCoins(ctx sdk.Context, senderAddr sdk.AccAddress, amt sdk.Coins, modAccName string) error {
	err := k.bankKeeper.SendCoinsFromAccountToModule(ctx, senderAddr, modAccName, amt)
	if err != nil {
		return err
	}

	return nil
}

// unlockCoins sends the locked coins from the given module account
func (k Keeper) unlockCoins(ctx sdk.Context, recieverAddr sdk.AccAddress, amt sdk.Coins, modAccName string) error {
	err := k.bankKeeper.SendCoinsFromModuleToAccount(ctx, modAccName, recieverAddr, amt)
	if err != nil {
		return err
	}

	return nil
}

// PayFees transfers coins to the FeeCollector module account
func (k Keeper) PayFees(ctx sdk.Context, senderAddr sdk.AccAddress, amt sdk.Coins) error {
	return k.lockCoins(ctx, senderAddr, amt, types.FeeCollectorName)
}

func (k Keeper) LockCoinsForExecution(ctx sdk.Context, senderAddr sdk.AccAddress, amt sdk.Coins) error {
	return k.lockCoins(ctx, senderAddr, amt, types.ExecutionsLockerName)
}

func (k Keeper) LockCoinsForTrade(ctx sdk.Context, senderAddr sdk.AccAddress, amt sdk.Coins) error {
	return k.lockCoins(ctx, senderAddr, amt, types.TradesLockerName)
}

func (k Keeper) UnLockCoinsForExecution(ctx sdk.Context, revcAddr sdk.AccAddress, amt sdk.Coins) error {
	return k.unlockCoins(ctx, revcAddr, amt, types.ExecutionsLockerName)
}

func (k Keeper) UnLockCoinsForTrade(ctx sdk.Context, revcAddr sdk.AccAddress, amt sdk.Coins) error {
	return k.unlockCoins(ctx, revcAddr, amt, types.TradesLockerName)
}