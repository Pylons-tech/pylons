package queriers

import (
	"encoding/json"
	"strings"
	"testing"

	"github.com/stretchr/testify/require"

	abci "github.com/tendermint/tendermint/abci/types"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func TestQuerierPylonsBalance(t *testing.T) {
	tci := keep.SetupTestCoinInput()
	sender1, sender2, _, _ := keep.SetupTestAccounts(t, tci, types.NewPylon(1000), nil, nil, nil)

	cases := map[string]struct {
		path          []string
		desiredError  string
		desiredAmount int64
		showError     bool
	}{
		"not existing sender": {
			path:          []string{"invalidSender"},
			desiredError:  "decoding bech32 failed: string not all lowercase or all uppercase",
			desiredAmount: 0,
			showError:     true,
		},
		"error check when not providing sender": {
			path:          []string{},
			desiredError:  "no sender is provided in path",
			desiredAmount: 0,
			showError:     true,
		},
		"sender with no balance": {
			path:          []string{sender2.String()},
			desiredError:  "",
			desiredAmount: 0,
			showError:     false,
		},
		"sender with balance": {
			path:          []string{sender1.String()},
			desiredError:  "",
			desiredAmount: 1000,
			showError:     false,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			result, err := PylonsBalance(
				tci.Ctx,
				tc.path,
				abci.RequestQuery{
					Path: "",
					Data: []byte{},
				},
				tci.PlnK,
			)

			if tc.showError {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				require.NoError(t, err)

				balanceResp := QueryResBalance{}
				balanceRespErr := json.Unmarshal(result, &balanceResp)
				require.True(t, balanceRespErr == nil)

				balance := balanceResp.Balance
				require.True(t, balance == tc.desiredAmount)
			}
		})
	}
}
