package handlers

import (
	"strings"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestHandlerMsgGetPylons(t *testing.T) {
	mockedCoinInput := keep.SetupTestCoinInput()

	sender1, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")

	cases := map[string]struct {
		reqAmount    int64
		fromAddress  sdk.AccAddress
		desiredError string
		showError    bool
	}{
		"successful check": {
			reqAmount:    500,
			fromAddress:  sender1,
			desiredError: "",
			showError:    false,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			msg := msgs.NewMsgGetPylons(types.NewPylon(tc.reqAmount), tc.fromAddress)
			_, err := HandlerMsgGetPylons(mockedCoinInput.Ctx, mockedCoinInput.PlnK, msg)

			if !tc.showError {
				require.True(t, mockedCoinInput.PlnK.CoinKeeper.HasCoins(mockedCoinInput.Ctx, tc.fromAddress, types.NewPylon(tc.reqAmount)))
				require.False(t, mockedCoinInput.PlnK.CoinKeeper.HasCoins(mockedCoinInput.Ctx, tc.fromAddress, types.NewPylon(tc.reqAmount+1)))
				require.True(t, mockedCoinInput.PlnK.CoinKeeper.HasCoins(mockedCoinInput.Ctx, tc.fromAddress, types.NewPylon(tc.reqAmount-1)))
			} else {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			}
		})
	}
}
