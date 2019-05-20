package pylons

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// Pylon the currency identifier
const Pylon = "Pylon"

// NewPylon Returns pylon currency
func NewPylon(amount int64) sdk.Coin {
	return sdk.NewInt64Coin(Pylon, amount)
}
