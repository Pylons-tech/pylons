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
	// TODO should update to MsgSendCoins and add game coin test case too and pylons sdk update
	tci := keep.SetupTestCoinInput()

	initialAmount := int64(50000)
	sender1, sender2, _, _ := keep.SetupTestAccounts(t, tci, types.NewPylon(initialAmount), nil, nil, nil)

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
			_, err := HandlerMsgSendPylons(tci.Ctx, tci.PlnK, msg)

			if !tc.showError {
				require.True(t, keep.HasCoins(tci.PlnK, tci.Ctx, tc.toAddress, types.NewPylon(tc.amount)))
				require.False(t, keep.HasCoins(tci.PlnK, tci.Ctx, tc.toAddress, types.NewPylon(tc.amount+1)))
				require.True(t, keep.HasCoins(tci.PlnK, tci.Ctx, tc.toAddress, types.NewPylon(tc.amount-1)))

				require.True(t, keep.HasCoins(tci.PlnK, tci.Ctx, tc.fromAddress, types.NewPylon(initialAmount-tc.amount)))
				require.False(t, keep.HasCoins(tci.PlnK, tci.Ctx, tc.fromAddress, types.NewPylon(initialAmount-tc.amount+1)))
				require.True(t, keep.HasCoins(tci.PlnK, tci.Ctx, tc.fromAddress, types.NewPylon(initialAmount-tc.amount-1)))
			} else {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			}
		})
	}
}
