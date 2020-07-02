package handlers

import (
	"strings"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestHandlerMsgCreateAccount(t *testing.T) {
	tci := keep.SetupTestCoinInput()
	sender1, _, _ := keep.SetupTestAccounts(t, tci, nil, nil, nil)

	cases := map[string]struct {
		fromAddress  sdk.AccAddress
		desiredError string
		showError    bool
	}{
		"successful check": {
			fromAddress:  sender1,
			desiredError: "",
			showError:    false,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			msg := msgs.NewMsgCreateAccount(tc.fromAddress)
			_, err := HandlerMsgCreateAccount(tci.Ctx, tci.PlnK, msg)

			if !tc.showError {
			} else {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			}
		})
	}
}
