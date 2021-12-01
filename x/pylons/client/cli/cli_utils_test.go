package cli_test

import (
	"errors"
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
			input:	  "100000pylon",
			converted: sdk.NewCoin("pylon",sdk.NewInt(100000)),
		},
		{
			desc:     "Test_Valid_2",
			input:	  "10000.00pylon",
			err: errors.New("coin is invalid"),
		},
		{
			desc:     "Test_Invalid_1",
			input:	  "100000",
			err: errors.New("coin is invalid"),
		},
		{
			desc:     "Test_Invalid_2",
			input:	  "100,000",
			err: errors.New("coin is invalid"),
		},
		{
			desc:     "Test_Invalid_3",
			input:	  "pylons_100000",
			err: errors.New("coin is invalid"),
		},
		{
			desc:     "Test_Invalid_4",
			input:	  "-100000",
			err: errors.New("coin is invalid"),
		},

	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			val,err := cli.ParseCoinArguments(tc.input)
			if tc.err==nil {
				require.NoError(t, err)
				equal := val[0].Amount.Equal(tc.converted.Amount) && val[0].Denom == tc.converted.Denom
				require.True(t, equal)
			}else{
				require.EqualError(t, tc.err,"coin is invalid")
			}

		})
	}
}

