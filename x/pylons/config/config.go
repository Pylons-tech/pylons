package config

import sdk "github.com/cosmos/cosmos-sdk/types"

const (
	pylonsCoinDenom = "pylon"

	// DefaultBasicFee holds the value of the default basic fee if not configured externally
	DefaultBasicFee = 10000
	// DefaultPremiumFee holds the value of the default premium fee if not configured externally
	DefaultPremiumFee = 50000
)

var (
	nodeVersionString = ""
)

func SetNodeVersionString(s string) {
	nodeVersionString = s
}

func GetNodeVersionString() string {
	return nodeVersionString
}

// RequestFieldConfig holds parameters for validating request fields
type RequestFieldConfig struct {
	minNameLength        uint64
	minDescriptionLength uint64
}

func NewRequestFieldConfig() RequestFieldConfig {
	return RequestFieldConfig{
		minNameLength:        8,
		minDescriptionLength: 20,
	}
}

type FeeConfig struct {
	BasicFee   sdk.Coins
	PremiumFee sdk.Coins
}

func NewFeeConfig() FeeConfig {
	return FeeConfig{
		BasicFee:   sdk.Coins{sdk.NewInt64Coin(pylonsCoinDenom, DefaultBasicFee)},
		PremiumFee: sdk.Coins{sdk.NewInt64Coin(pylonsCoinDenom, DefaultPremiumFee)},
	}
}
