package pylons

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// Pylon the currency identifier
const Pylon = "pylon"

// NewPylon Returns pylon currency
func NewPylon(amount int64) sdk.Coins {
	return sdk.Coins{sdk.NewInt64Coin(Pylon, amount)}
}
