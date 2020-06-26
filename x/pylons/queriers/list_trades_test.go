package queriers

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/require"

	abci "github.com/tendermint/tendermint/abci/types"

	"github.com/Pylons-tech/pylons/x/pylons/handlers"
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func TestListTrades(t *testing.T) {
	tci := keep.SetupTestCoinInput()
	// sender1, _ := keep.SetupTestAccounts(t, tci, types.NewPylon(1000000))
	sender1, _, _ := keep.SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil)

	_, err := tci.Bk.AddCoins(tci.Ctx, sender1, types.GenCoinInputList("wood", 100).ToCoins())
	require.True(t, err == nil)

	// mock cookbook
	_, err = handlers.MockTrade(
		tci,
		types.GenCoinInputList("wood", 100),
		types.TradeItemInputList{},
		types.NewPylon(1000),
		types.ItemList{},
		sender1,
	)

	require.True(t, err == nil)

	_, err = handlers.MockTrade(
		tci,
		types.GenCoinInputList("stone", 100),
		types.TradeItemInputList{},
		types.NewPylon(2000),
		types.ItemList{},
		sender1,
	)

	require.True(t, err == nil)

	cases := map[string]struct {
		path          []string
		desiredError  string
		showError     bool
		desiredExcCnt int
	}{
		"error check when providing invalid address": {
			path:          []string{"invalid_address"},
			showError:     true,
			desiredError:  "decoding bech32 failed: invalid index of 1",
			desiredExcCnt: 0,
		},
		"list trade successful check": {
			path:          []string{sender1.String()},
			showError:     false,
			desiredError:  "",
			desiredExcCnt: 2,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			result, err := ListTrade(
				tci.Ctx,
				tc.path,
				abci.RequestQuery{
					Path: sender1.String(),
					Data: []byte{},
				},
				tci.PlnK,
			)
			if tc.showError {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				require.True(t, err == nil)
				trdList := types.TradeList{}
				trdListErr := tci.PlnK.Cdc.UnmarshalJSON(result, &trdList)

				require.True(t, trdListErr == nil)
				require.True(t, len(trdList.Trades) == tc.desiredExcCnt)
			}
		})
	}
}
