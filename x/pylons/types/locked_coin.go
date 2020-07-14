package types

import (
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// TypeLockedCoin is a store key for lockedCoin
const TypeLockedCoin = "lockedCoin"

// LockedCoin describes the locked coin struct
type LockedCoin struct {
	Sender sdk.AccAddress
	Amount sdk.Coins
}

func (lc LockedCoin) String() string {
	return fmt.Sprintf(`
	LockedCoin{ 
		Address: %s,
		Amount: %s,
	}`, lc.Sender.String(), lc.Amount.String())
}

// NewLockedCoin return a new locked coin
func NewLockedCoin(sender sdk.AccAddress, amount sdk.Coins) LockedCoin {
	lc := LockedCoin{
		Sender: sender,
		Amount: amount,
	}

	return lc
}
