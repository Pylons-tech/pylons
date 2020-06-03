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

func TestHandlerMsgSendPylons(t *testing.T) {
	mockedCoinInput := keep.SetupTestCoinInput()

	sender1, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
	sender2, _ := sdk.AccAddressFromBech32("cosmos16wfryel63g7axeamw68630wglalcnk3l0zuadc")

	initialAmount := int64(50000)
	_, err := mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, sender1, types.NewPylon(initialAmount))
	require.True(t, err == nil)

	cases := map[string]struct {
		amount       int64
		fromAddress  sdk.AccAddress
		toAddress    sdk.AccAddress
		desiredError string
		showError    bool
	}{
		"successful check": {
			amount:       500,
			fromAddress:  sender1,
			toAddress:    sender2,
			desiredError: "",
			showError:    false,
		},
		"not enough balance check": {
			amount:       5000,
			fromAddress:  sender2,
			toAddress:    sender1,
			desiredError: "Sender does not have enough coins",
			showError:    true,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			msg := msgs.NewMsgSendPylons(types.NewPylon(tc.amount), tc.fromAddress, tc.toAddress)
			_, err := HandlerMsgSendPylons(mockedCoinInput.Ctx, mockedCoinInput.PlnK, msg)

			if !tc.showError {
				require.True(t, mockedCoinInput.PlnK.CoinKeeper.HasCoins(mockedCoinInput.Ctx, tc.toAddress, types.NewPylon(tc.amount)))
				require.False(t, mockedCoinInput.PlnK.CoinKeeper.HasCoins(mockedCoinInput.Ctx, tc.toAddress, types.NewPylon(tc.amount+1)))
				require.True(t, mockedCoinInput.PlnK.CoinKeeper.HasCoins(mockedCoinInput.Ctx, tc.toAddress, types.NewPylon(tc.amount-1)))

				require.True(t, mockedCoinInput.PlnK.CoinKeeper.HasCoins(mockedCoinInput.Ctx, tc.fromAddress, types.NewPylon(initialAmount-tc.amount)))
				require.False(t, mockedCoinInput.PlnK.CoinKeeper.HasCoins(mockedCoinInput.Ctx, tc.fromAddress, types.NewPylon(initialAmount-tc.amount+1)))
				require.True(t, mockedCoinInput.PlnK.CoinKeeper.HasCoins(mockedCoinInput.Ctx, tc.fromAddress, types.NewPylon(initialAmount-tc.amount-1)))
			} else {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			}
		})
	}
}
