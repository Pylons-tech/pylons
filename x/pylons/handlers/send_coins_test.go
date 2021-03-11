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

func TestHandlerMsgSendCoins(t *testing.T) {
	tci := keep.SetupTestCoinInput()
	tci.PlnH = NewMsgServerImpl(tci.PlnK)

	initialCoins := sdk.Coins{sdk.NewInt64Coin("pylon", 50000), sdk.NewInt64Coin("loudcoin", 10000)}
	sender1, sender2, _, _ := keep.SetupTestAccounts(t, tci, initialCoins, nil, nil, nil)

	cases := map[string]struct {
		amount       sdk.Coins
		fromAddress  sdk.AccAddress
		toAddress    sdk.AccAddress
		desiredError string
		showError    bool
	}{
		"successful check": {
			amount:       sdk.Coins{sdk.NewInt64Coin("pylon", 500), sdk.NewInt64Coin("loudcoin", 100)},
			fromAddress:  sender1,
			toAddress:    sender2,
			desiredError: "",
			showError:    false,
		},
		"not enough balance check": {
			amount:       types.NewPylon(5000),
			fromAddress:  sender2,
			toAddress:    sender1,
			desiredError: "Sender does not have enough coins",
			showError:    true,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			msg := msgs.NewMsgSendCoins(tc.amount, tc.fromAddress, tc.toAddress)
			_, err := tci.PlnH.SendCoins(sdk.WrapSDKContext(tci.Ctx), &msg)

			if !tc.showError {
				require.True(t, tci.PlnK.CoinKeeper.GetAllBalances(tci.Ctx, tc.toAddress).IsEqual(tc.amount))
				require.True(t, tci.PlnK.CoinKeeper.GetAllBalances(tci.Ctx, tc.fromAddress).IsEqual(initialCoins.Sub(tc.amount)))
			} else {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			}
		})
	}
}
