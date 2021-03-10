package types

import (
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// TypeLockedCoin is a store key for lockedCoin
const TypeLockedCoin = "lockedCoin"

// LockedCoin describes the locked coin struct
type LockedCoin struct {
	NodeVersion SemVer
	Sender      sdk.AccAddress
	Amount      sdk.Coins
}

func (lc LockedCoin) String() string {
	return fmt.Sprintf(`
	LockedCoin{ 
		NodeVersion: %s,
		Address: %s,
		Amount: %s,
	}`, lc.NodeVersion, lc.Sender.String(), lc.Amount.String())
}

// NewLockedCoin return a new locked coin
func NewLockedCoin(sender sdk.AccAddress, amount sdk.Coins) LockedCoin {
	lc := LockedCoin{
		NodeVersion: SemVer{"0.0.1"},
		Sender:      sender,
		Amount:      amount,
	}

	return lc
}

// LockedCoinDetails describes the locked coin struct with where it's locked in details
type LockedCoinDetails struct {
	Sender         string
	Amount         sdk.Coins
	LockCoinTrades []LockedCoinDescribe
	LockCoinExecs  []LockedCoinDescribe
}
