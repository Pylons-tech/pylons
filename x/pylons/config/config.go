package config

import sdk "github.com/cosmos/cosmos-sdk/types"

const (
	PylonsCoinDenom = "pylon"

	// DefaultBasicFee holds the value of the default basic fee if not configured externally
	DefaultBasicFee = 10000
)

var (
	nodeVersionString = "dev"
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
	BaseFee sdk.Coins
}

func NewFeeConfig() FeeConfig {
	return FeeConfig{
		BaseFee: sdk.Coins{sdk.NewInt64Coin(pylonsCoinDenom, DefaultBasicFee)},
	}
}
