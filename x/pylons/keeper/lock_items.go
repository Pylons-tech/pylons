package keeper

import (
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// LockItem sends an account's items to the Items Locker Module Account for Pylons
// Changing ownership of the item in the store will unlock the item from the module account
func (k Keeper) LockItem(ctx sdk.Context, item types.Item) {
	// lock item by transferring ownership to module account
	modAcc := k.accountKeeper.GetModuleAddress(types.PylonsItemsLockerName)
	item.Owner = modAcc.String()
	k.SetItem(ctx, item)
}
