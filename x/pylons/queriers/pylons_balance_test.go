package queriers

import (
	"strings"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/handlers"
	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/stretchr/testify/require"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

func TestQuerierPylonsBalance(t *testing.T) {
	tci := keeper.SetupTestCoinInput()
	tci.PlnH = handlers.NewMsgServerImpl(tci.PlnK)
	tci.PlnQ = NewQuerierServerImpl(tci.PlnK)

	sender1, sender2, _, _ := keeper.SetupTestAccounts(t, tci, types.NewPylon(1000), nil, nil, nil)

	cases := map[string]struct {
		address       string
		desiredError  string
		desiredAmount int64
		showError     bool
	}{
		"not existing sender": {
			address:       "invalidSender",
			desiredError:  "decoding bech32 failed: string not all lowercase or all uppercase",
			desiredAmount: 0,
			showError:     true,
		},
		"error check when not providing sender": {
			address:       "",
			desiredError:  "no sender is provided in path",
			desiredAmount: 0,
			showError:     true,
		},
		"sender with no balance": {
			address:       sender2.String(),
			desiredError:  "",
			desiredAmount: 0,
			showError:     false,
		},
		"sender with balance": {
			address:       sender1.String(),
			desiredError:  "",
			desiredAmount: 1000,
			showError:     false,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			result, err := tci.PlnQ.PylonsBalance(
				sdk.WrapSDKContext(tci.Ctx),
				&types.PylonsBalanceRequest{
					Address: tc.address,
				},
			)

			if tc.showError {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				require.NoError(t, err)

				require.True(t, result.Balance == tc.desiredAmount)
			}
		})
	}
}
