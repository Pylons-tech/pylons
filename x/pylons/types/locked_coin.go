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

// LockedCoinList is a list of LockedCoin
type LockedCoinList []LockedCoin

func (lc LockedCoin) String() string {
	return fmt.Sprintf(`
	LockedCoin{ 
		Address: %s,
		Amount: %s,
	}`, lc.Sender.String(), lc.Amount.String())
}

func (lcl LockedCoinList) String() string {
	lc := "LockedCoinList{"

	for _, param := range lcl {
		lc += param.String() + ",\n"
	}

	lc += "}"
	return lc
}

// NewLockedCoin return a new locked coin
func NewLockedCoin(sender sdk.AccAddress, amount sdk.Coins) LockedCoin {
	lc := LockedCoin{
		Sender: sender,
		Amount: amount,
	}

	return lc
}
