package handlers

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/require"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func TestHandlerMsgCreateAccount(t *testing.T) {
	tci := keeper.SetupTestCoinInput()
	tci.PlnH = NewMsgServerImpl(tci.PlnK)
	sender1, _, _, _ := keeper.SetupTestAccounts(t, tci, nil, nil, nil, nil)

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
		"empty requester": {
			fromAddress:  nil,
			desiredError: "invalid address",
			showError:    true,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			msg := types.NewMsgCreateAccount(tc.fromAddress.String())
			_, err := tci.PlnH.CreateAccount(sdk.WrapSDKContext(tci.Ctx), &msg)

			if tc.showError {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				require.NoError(t, err)
			}
		})
	}
}
