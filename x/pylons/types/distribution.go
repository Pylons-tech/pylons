package types

import sdk "github.com/cosmos/cosmos-sdk/types"

type DistributionPercentage struct {
	Address         string  `json:"address"`
	SharePercentage sdk.Dec `json:"sharesPercentage"`
}

type DistributionCoin struct {
	Address string    `json:"address"`
	Coins   sdk.Coins `json:"coins"`
}
