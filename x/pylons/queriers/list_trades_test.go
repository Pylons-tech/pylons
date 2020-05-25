package queriers

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/require"

	abci "github.com/tendermint/tendermint/abci/types"

	"github.com/Pylons-tech/pylons/x/pylons/handlers"
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

func TestListTrades(t *testing.T) {
	mockedCoinInput := keep.SetupTestCoinInput()

	sender := "cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337"
	senderAccAddress, _ := sdk.AccAddressFromBech32(sender)

	mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, senderAccAddress, types.NewPylon(100000))
	mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, senderAccAddress, types.GenCoinInputList("wood", 100).ToCoins())
	// mock cookbook

	_, err := handlers.MockTrade(
		mockedCoinInput,
		types.GenCoinInputList("wood", 100),
		types.ItemInputList{},
		types.NewPylon(1000),
		types.ItemList{},
		senderAccAddress,
	)

	require.True(t, err == nil)

	_, err = handlers.MockTrade(
		mockedCoinInput,
		types.GenCoinInputList("stone", 100),
		types.ItemInputList{},
		types.NewPylon(2000),
		types.ItemList{},
		senderAccAddress,
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
			path:          []string{sender},
			showError:     false,
			desiredError:  "",
			desiredExcCnt: 2,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			result, err := ListTrade(
				mockedCoinInput.Ctx,
				tc.path,
				abci.RequestQuery{
					Path: sender,
					Data: []byte{},
				},
				mockedCoinInput.PlnK,
			)
			if tc.showError {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			} else {
				require.True(t, err == nil)
				trdList := types.TradeList{}
				trdListErr := mockedCoinInput.PlnK.Cdc.UnmarshalJSON(result, &trdList)

				require.True(t, trdListErr == nil)
				require.True(t, len(trdList.Trades) == tc.desiredExcCnt)
			}
		})
	}
}
