package msgs

import (
	"strings"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestGetPylonsValidateBasic(t *testing.T) {
	sender, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")

	cases := map[string]struct {
		amount       sdk.Coins
		requester    sdk.AccAddress
		showError    bool
		desiredError string
	}{
		"successful check": {
			amount:       types.NewPylon(500),
			requester:    sender,
			showError:    false,
			desiredError: "",
		},
		"nil balance check": {
			amount:       nil,
			requester:    sender,
			showError:    true,
			desiredError: "Amount cannot be less than 0/negative: unknown request",
		},
		"zero balance check": {
			amount:       sdk.Coins{},
			requester:    sender,
			showError:    true,
			desiredError: "Amount cannot be less than 0/negative: unknown request",
		},
		"empty address check": {
			amount:       types.NewPylon(500),
			requester:    sdk.AccAddress{},
			showError:    true,
			desiredError: "invalid address",
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			msg := NewMsgGetPylons(tc.amount, tc.requester.String())
			err := msg.ValidateBasic()
			if !tc.showError {
				require.True(t, err == nil, err)
			} else {
				require.True(t, err != nil)
				require.True(t, strings.Contains(err.Error(), tc.desiredError), err.Error())
			}
		})
	}
}
