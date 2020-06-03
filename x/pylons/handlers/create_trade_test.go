package handlers

import (
	"encoding/json"
	"strings"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestHandlerMsgCreateTrade(t *testing.T) {
	tci := keep.SetupTestCoinInput()

	sender, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
	sender2, _ := sdk.AccAddressFromBech32("cosmos16wfryel63g7axeamw68630wglalcnk3l0zuadc")
	cbData := CreateCBResponse{}
	_, err := tci.Bk.AddCoins(tci.Ctx, sender, types.NewPylon(100000))
	require.True(t, err == nil)

	_, err = tci.Bk.AddCoins(tci.Ctx, sender2, types.NewPylon(100000))
	require.True(t, err == nil)

	cookbookMsg := msgs.NewMsgCreateCookbook("cookbook-0001", "", "this has to meet character limits", "SketchyCo", "1.0.0", "example@example.com", 1, msgs.DefaultCostPerBlock, sender)
	cookbookResult, _ := HandlerMsgCreateCookbook(tci.Ctx, tci.PlnK, cookbookMsg)
	err = json.Unmarshal(cookbookResult.Data, &cbData)
	require.True(t, err == nil)
	require.True(t, len(cbData.CookbookID) > 0)

	item := keep.GenItem(cbData.CookbookID, sender, "Raichu")
	err = tci.PlnK.SetItem(tci.Ctx, *item)
	require.True(t, err == nil)

	item2 := keep.GenItem(cbData.CookbookID, sender2, "Pichu")
	err = tci.PlnK.SetItem(tci.Ctx, *item2)
	require.True(t, err == nil)

	cases := map[string]struct {
		sender         sdk.AccAddress
		inputCoinList  types.CoinInputList
		inputItemList  types.ItemInputList
		outputCoinList sdk.Coins
		outputItemList types.ItemList
		desiredError   string
		showError      bool
	}{
		"trade with only items": {
			sender:        sender,
			inputItemList: types.GenItemInputList("Pikachu"),
			outputItemList: types.ItemList{
				*item,
			},
			showError: false,
		},
		"trade with item and coins": {
			sender:        sender,
			inputItemList: types.GenItemInputList("Pikachu"),
			outputItemList: types.ItemList{
				*item,
			},
			outputCoinList: types.NewPylon(10000),
			showError:      false,
		},
		"trade with only items failure due to sender not being owner": {
			sender:        sender,
			inputItemList: types.GenItemInputList("Pikachu"),
			outputItemList: types.ItemList{
				*item2,
			},
			desiredError: "is not owned by sender",
			showError:    true,
		},
		"trade with coin and item failure due to low balance": {
			sender:        sender,
			inputItemList: types.GenItemInputList("Pikachu"),
			outputItemList: types.ItemList{
				*item,
			},
			outputCoinList: types.NewPylon(1000000),
			desiredError:   "sender doesn't have enough coins for the trade",
			showError:      true,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {

			msg := msgs.NewMsgCreateTrade(tc.inputCoinList, tc.inputItemList, tc.outputCoinList, tc.outputItemList, "", tc.sender)
			result, err := HandlerMsgCreateTrade(tci.Ctx, tci.PlnK, msg)
			if !tc.showError {
				ctRespData := CreateTradeResponse{}
				err := json.Unmarshal(result.Data, &ctRespData)
				require.True(t, err == nil)
				require.True(t, len(ctRespData.TradeID) > 0)
			} else {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			}
		})
	}
}
