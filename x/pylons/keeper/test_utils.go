package keeper

import (
	"strconv"
)

const (
	// original address: "cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337"
	baseAccAddrBech32 = "cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt33"
)

func CreateTestAddressList(numAccount uint) []string {
	accounts := make([]string, numAccount)
	for i := uint(0); i < numAccount; i++ {
		addr := baseAccAddrBech32 + strconv.Itoa(int(i))
		accounts[i] = addr
	}

	return accounts
}
