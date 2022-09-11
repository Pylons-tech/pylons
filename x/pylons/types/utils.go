package types

import (
	"strings"
)

const (
	// MainnetChainID defines the Pylons EIP155 chain ID for mainnet
	MainnetChainID = ""
	// TestnetChainID defines the Pylons EIP155 chain ID for testnet
	TestnetChainID = ""
)

// IsMainnet returns true if the chain-id has the Pylons mainnet EIP155 chain prefix.
func IsMainnet(chainID string) bool {
	return strings.HasPrefix(chainID, MainnetChainID)
}

// IsTestnet returns true if the chain-id has the Pylons testnet EIP155 chain prefix.
func IsTestnet(chainID string) bool {
	return strings.HasPrefix(chainID, TestnetChainID)
}
