package handlers

import (
	"encoding/json"
	"strings"
	"testing"

	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	"github.com/MikeSofaer/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestHandlerMsgCreateTrade(t *testing.T) {
	mockedCoinInput := keep.SetupTestCoinInput()

	sender, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
	sender2, _ := sdk.AccAddressFromBech32("cosmos16wfryel63g7axeamw68630wglalcnk3l0zuadc")
	cbData := CreateCBResponse{}
	mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, sender, types.NewPylon(1000000))
	mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, sender2, types.NewPylon(1000000))

	cookbookMsg := msgs.NewMsgCreateCookbook("cookbook-0001", "this has to meet character limits", "SketchyCo", "1.0.0", "example@example.com", 1, msgs.DefaultCostPerBlock, sender)
	cookbookResult := HandlerMsgCreateCookbook(mockedCoinInput.Ctx, mockedCoinInput.PlnK, cookbookMsg)
	err := json.Unmarshal(cookbookResult.Data, &cbData)
	require.True(t, err == nil)
	require.True(t, len(cbData.CookbookID) > 0)

	item := keep.GenItem(cbData.CookbookID, sender, "Raichu")
	err = mockedCoinInput.PlnK.SetItem(mockedCoinInput.Ctx, *item)
	require.True(t, err == nil)

	item2 := keep.GenItem(cbData.CookbookID, sender2, "Pichu")
	err = mockedCoinInput.PlnK.SetItem(mockedCoinInput.Ctx, *item2)
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
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {

			msg := msgs.NewMsgCreateTrade(tc.inputCoinList, tc.inputItemList, tc.outputCoinList, tc.outputItemList, "", tc.sender)
			result := HandlerMsgCreateTrade(mockedCoinInput.Ctx, mockedCoinInput.PlnK, msg)
			if !tc.showError {
				ctRespData := CreateTradeResponse{}
				err := json.Unmarshal(result.Data, &ctRespData)
				require.True(t, err == nil)
				require.True(t, len(ctRespData.TradeID) > 0)
			} else {
				require.True(t, strings.Contains(result.Log, tc.desiredError))
			}
		})
	}
}
