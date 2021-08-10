package keeper

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// LockItems sends an account's items to the Items Locker Module Account for Pylons
func (k Keeper) LockItems(ctx sdk.Context, senderAddr sdk.AccAddress, itemIDs []string) error {
	// TODO complete
	for _, itemID := range itemIDs {
		panic(itemID)

		// check if items belong to senderAddr
		// set owner to Item Locker Module Account
	}

	return nil
}

// UnlockItems sends the locked coins from the Coins Locker Module Account to an account
func (k Keeper) UnlockItems(ctx sdk.Context, recieverAddr sdk.AccAddress, itemIDs []string) error {
	// TODO complete
	for _, itemID := range itemIDs {
		panic(itemID)

		// check if items belong to Item Locker Module Account
		// set owner to recieverAddr
	}

	return nil
}
