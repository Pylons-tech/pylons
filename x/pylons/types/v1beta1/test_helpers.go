package v1beta1

import (
	"encoding/binary"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/bech32"
)

// GenTestBech32List creates a list of bech32-encoded strings that can be used as bech32-encoded AccAddress for testing.
// Note, addresses generated with this function should only be used for testing.
func GenTestBech32List(numAccount int) []string {
	bech32PrefixAccAddr := sdk.GetConfig().GetBech32AccountAddrPrefix()

	accounts := make([]string, numAccount)
	// valid AccAddress is 20 bytes - an uint64 is 8 bytes. We pad with 12 fixed characters
	prefix := "testAddress-"
	for i := 0; i < numAccount; i++ {
		val := make([]byte, 8)
		binary.LittleEndian.PutUint64(val, uint64(i))
		val = append([]byte(prefix), val...)
		addr, _ := bech32.ConvertAndEncode(bech32PrefixAccAddr, val)
		accounts[i] = addr
	}

	return accounts
}

// GenTestBech32FromString creates a bech32-encoded string padding or trimming the input string to be exactly
// 20 bytes. Note, addresses generated with this function should only be used for testing.
func GenTestBech32FromString(s string) string {
	bech32PrefixAccAddr := sdk.GetConfig().GetBech32AccountAddrPrefix()

	if len(s) < 20 {
		pad := 20 - len(s)
		for i := 0; i < pad; i++ {
			s += "-"
		}
	} else {
		s = s[:20]
	}
	addr, _ := bech32.ConvertAndEncode(bech32PrefixAccAddr, []byte(s))

	return addr
}

func GenAccAddressFromString(s string) sdk.AccAddress {
	addrStr := GenTestBech32FromString(s)
	addr, _ := sdk.AccAddressFromBech32(addrStr)
	return addr
}
