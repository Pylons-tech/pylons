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

// LockItem sends an account's items to the provided module account
// Changing ownership of the item in the store will unlock the item from the module account
func (k Keeper) lockItem(ctx sdk.Context, item types.Item, modAccName string) {
	// lock item by transferring ownership to module account
	modAcc := k.accountKeeper.GetModuleAddress(modAccName)
	prevAddr, _ := sdk.AccAddressFromBech32(item.Owner)
	item.Owner = modAcc.String()
	k.UpdateItem(ctx, item, prevAddr)
}

func (k Keeper) unlockItem(ctx sdk.Context, item types.Item, modAccName, addr string) {
	modAcc := k.accountKeeper.GetModuleAddress(modAccName)
	item.Owner = addr
	k.UpdateItem(ctx, item, modAcc)
}

func (k Keeper) LockItemForExecution(ctx sdk.Context, item types.Item) {
	k.lockItem(ctx, item, types.ExecutionsLockerName)
}

func (k Keeper) UnlockItemForExecution(ctx sdk.Context, item types.Item, addr string) {
	k.unlockItem(ctx, item, types.ExecutionsLockerName, addr)
}

func (k Keeper) LockItemForTrade(ctx sdk.Context, item types.Item) {
	k.lockItem(ctx, item, types.TradesLockerName)
}

func (k Keeper) UnlockItemForTrade(ctx sdk.Context, item types.Item, addr string) {
	k.unlockItem(ctx, item, types.TradesLockerName, addr)
}
