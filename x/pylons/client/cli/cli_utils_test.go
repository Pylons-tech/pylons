package cli_test

import (
	"testing"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"

	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
)

// ParseCoinArguments parses a cli argument of the format "10000000utoken,10000000ustake" and
// returns a slice of type sdk.Coin
func TestParseCoinArguments(t *testing.T){


	for _, tc := range []struct {
		desc    string
		input 	string
		converted sdk.Coin
		err     error
	}{
		{
			desc:     "Test_Valid_1",
			input:	  "100000upylon",
			converted: sdk.NewCoin("pylon",sdk.NewInt(100000)),
		},
		{
			desc:     "Test_Valid_2",
			input:	  "10000.00pylon",
			converted: sdk.NewCoin("pylon",sdk.NewInt(100000)),
		},
		{
			desc:     "Test_Invalid_1",
			input:	  "100000",
		},
		{
			desc:     "Test_Invalid_2",
			input:	  "100,000",
		},
		{
			desc:     "Test_Invalid_3",
			input:	  "pylons100000",
		},
		{
			desc:     "Test_Invalid_4",
			input:	  "-100000",
		},

	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			val,err := cli.ParseCoinArguments(tc.input)
			require.NoError(t, err)
			require.Equal(t, val[0], tc.converted)
		})
	}


}
