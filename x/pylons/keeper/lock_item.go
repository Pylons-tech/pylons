package keeper

import (
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// LockItem sends an account's items to the provided module account
// Changing ownership of the item in the store will unlock the item from the module account
func (k Keeper) lockItem(ctx sdk.Context, item types.Item, modAccName string) {
	// lock item by transferring ownership to module account
	modAcc := k.accountKeeper.GetModuleAddress(modAccName)
	item.Owner = modAcc.String()
	k.SetItem(ctx, item)
}

func (k Keeper) LockItemForExecution(ctx sdk.Context, item types.Item) {
	k.lockItem(ctx, item, types.ExecutionsLockerName)
}

func (k Keeper) LockItemForTrade(ctx sdk.Context, item types.Item) {
	k.lockItem(ctx, item, types.TradesLockerName)
}