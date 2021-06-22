package queriers

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/require"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/handlers"
	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func TestListTrades(t *testing.T) {
	tci := keeper.SetupTestCoinInput()
	tci.PlnH = handlers.NewMsgServerImpl(tci.PlnK)
	tci.PlnQ = NewQuerierServerImpl(tci.PlnK)

	sender1, _, _, _ := keeper.SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)

	err := tci.Bk.AddCoins(tci.Ctx, sender1, types.GenCoinInputList("wood", 100).ToCoins())
	require.NoError(t, err)

	// mock cookbook
	_, err = handlers.MockTrade(
		tci,
		types.GenCoinInputList("wood", 100),
		types.TradeItemInputList{},
		types.NewPylon(1000),
		types.ItemList{},
		sender1,
	)

	require.True(t, err == nil, err)

	_, err = handlers.MockTrade(
		tci,
		types.GenCoinInputList("stone", 100),
		types.TradeItemInputList{},
		types.NewPylon(2000),
		types.ItemList{},
		sender1,
	)

	require.NoError(t, err)

	cases := map[string]struct {
		address       string
		desiredError  string
		showError     bool
		desiredExcCnt int
	}{
		"error check when providing invalid address": {
			address:       "invalid_address",
			showError:     true,
			desiredError:  "decoding bech32 failed: invalid index of 1",
			desiredExcCnt: 0,
		},
		"list trade successful check": {
			address:       sender1.String(),
			showError:     false,
			desiredError:  "",
			desiredExcCnt: 2,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			result, err := tci.PlnQ.ListTrade(
				sdk.WrapSDKContext(tci.Ctx),
				&types.ListTradeRequest{
					Address: tc.address,
				},
			)
			if tc.showError {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				require.NoError(t, err)
				require.Equal(t, len(result.Trades), tc.desiredExcCnt)
			}
		})
	}
}
