package config

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
)

const (
	// PylonsCoinDenom is the pylons denom string
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
		BaseFee: sdk.Coins{sdk.NewInt64Coin(PylonsCoinDenom, DefaultBasicFee)},
	}
}

// GoogleIAPConfiguration is a struct to manage google iap packages and products
type GoogleIAPConfiguration struct {
	PackageName string `yaml:"package_name"`
	ProductID   string `yaml:"product_id"`
	Amount      int64  `yaml:"amount"`
}

// Configuration is a struct to manage game configuration
type Configuration struct {
	GoogleIAP       []GoogleIAPConfiguration `yaml:"google_iap"`
	GoogleIAPPubKey string                   `yaml:"google_iap_pubkey"`
}

// Config is for managing configuration
var Config Configuration

func init() {
	ReadConfig()
}

// ReadConfig is a function to read configuration
func ReadConfig() {
	Config = Configuration{
		GoogleIAP: []GoogleIAPConfiguration{
			{
				PackageName: "com.pylons.loud",
				ProductID:   "pylons_1000",
				Amount:      1000,
			},
			{
				PackageName: "com.pylons.loud",
				ProductID:   "pylons_55000",
				Amount:      55000,
			},
		},
		GoogleIAPPubKey: "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwZsjhk6eN5Pve9pP3uqz2MwBFixvmCRtQJoDQLTEJo3zTd9VMZcXoerQX8cnDPclZWmMZWkO+BWcN1ikYdGHvU2gC7yBLi+TEkhsEkixMlbqOGRdmNptJJhqxuVmXK+drWTb6W0IgQ9g8CuCjZUiMTc0UjHb5mPOE/IhcuTZ0wCHdoqc5FS2spdQqrohvSEP7gR4ZgGzYNI1U+YZHskIEm2qC4ZtSaX9J/fDkAmmJFV2hzeDMcljCxY9+ZM1mdzIpZKwM7O6UdWRpwD1QJ7yXND8AQ9M46p16F0VQuZbbMKCs90NIcKkx6jDDGbVmJrFnUT1Oq1uYxNYtiZjTp+JowIDAQAB",
	}
}
