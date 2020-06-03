package queriers

import (
	"strings"
	"testing"
	"encoding/json"

	"github.com/stretchr/testify/require"

	abci "github.com/tendermint/tendermint/abci/types"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

func TestQuerierPylonsBalance(t *testing.T) {
	mockedCoinInput := keep.SetupTestCoinInput()

	sender := "cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337"
	senderAccAddress, _ := sdk.AccAddressFromBech32(sender)
	sender2 := "cosmos16wfryel63g7axeamw68630wglalcnk3l0zuadc"

	_, err := mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, senderAccAddress, types.NewPylon(int64(1000)))
	require.True(t, err == nil)

	cases := map[string]struct {
		path    []string
		desiredError  string
		desiredAmount int64
		showError     bool
	}{
		"not existing sender": {
			path:    []string{"invalidSender"},
			desiredError:  "decoding bech32 failed: string not all lowercase or all uppercase",
			desiredAmount: 0,
			showError:     true,
		},
		"error check when not providing sender": {
			path:    []string{},
			desiredError:  "no sender is provided in path",
			desiredAmount: 0,
			showError:     true,
		},
		"sender with no balance": {
			path:    []string{sender2},
			desiredError:  "",
			desiredAmount: 0,
			showError:     false,
		},
		"sender with balance": {
			path:    []string{sender},
			desiredError:  "",
			desiredAmount: 1000,
			showError:     false,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			result, err := PylonsBalance(
				mockedCoinInput.Ctx,
				tc.path,
				abci.RequestQuery{
					Path: "",
					Data: []byte{},
				},
				mockedCoinInput.PlnK,
			)

			// t.Errorf("Querier.ItemsByCookbookTest LOG:: %+v", err)

			if tc.showError {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				require.True(t, err == nil)

				balanceResp := QueryResBalance{}
				balanceRespErr := json.Unmarshal(result, &balanceResp)
				require.True(t, balanceRespErr == nil)

				balance := balanceResp.Balance
				require.True(t, balance == tc.desiredAmount)
			}
		})
	}
}
