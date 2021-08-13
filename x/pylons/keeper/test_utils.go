package keeper

import (
	"strconv"
)

const (
	// original address: "cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337"
	validBech32AccAddr = "cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337" // nolint: deadcode
	baseAccAddrBech32  = "cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt33"
)

// CreateTestFakeAddressList creates a list of addresses from baseAccAddrBech32.
// Note, they are not valid Bech32 addresses (except the 7th element), so Bech32 decoding on these will fail
func CreateTestFakeAddressList(numAccount uint) []string {
	accounts := make([]string, numAccount)
	for i := uint(0); i < numAccount; i++ {
		addr := baseAccAddrBech32 + strconv.Itoa(int(i))
		accounts[i] = addr
	}

	return accounts
}
