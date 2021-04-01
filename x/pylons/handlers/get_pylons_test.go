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
	tci := keep.SetupTestCoinInput()
	tci.PlnH = NewMsgServerImpl(tci.PlnK)
	sender1, _, _, _ := keep.SetupTestAccounts(t, tci, nil, nil, nil, nil)

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
			msg := msgs.NewMsgGetPylons(types.NewPylon(tc.reqAmount), tc.fromAddress.String())
			_, err := tci.PlnH.GetPylons(sdk.WrapSDKContext(tci.Ctx), &msg)

			if !tc.showError {
				require.True(t, keep.HasCoins(tci.PlnK, tci.Ctx, tc.fromAddress, types.NewPylon(tc.reqAmount)))
				require.False(t, keep.HasCoins(tci.PlnK, tci.Ctx, tc.fromAddress, types.NewPylon(tc.reqAmount+1)))
				require.True(t, keep.HasCoins(tci.PlnK, tci.Ctx, tc.fromAddress, types.NewPylon(tc.reqAmount-1)))
			} else {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			}
		})
	}
}
