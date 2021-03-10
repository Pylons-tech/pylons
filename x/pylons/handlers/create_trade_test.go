package handlers

import (
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
	tci.PlnH = NewMsgServerImpl(tci.PlnK)
	sender, sender2, _, _ := keep.SetupTestAccounts(t, tci, types.NewPylon(100000), nil, nil, nil)

	err := tci.Bk.AddCoins(tci.Ctx, sender2, types.NewPylon(100000))
	require.True(t, err == nil)

	cookbookMsg := msgs.NewMsgCreateCookbook(
		"cookbook-0001",
		"cookbook-id-0001",
		"this has to meet character limits",
		"SketchyCo",
		types.SemVer{"1.0.0"},
		types.Email{`example@example.com`},
		types.Level{1},
		msgs.DefaultCostPerBlock,
		sender,
	)
	cookbookResult, _ := tci.PlnH.HandlerMsgCreateCookbook(sdk.WrapSDKContext(tci.Ctx), &cookbookMsg)
	require.True(t, len(cookbookResult.CookbookID) > 0)

	item := keep.GenItem(cookbookResult.CookbookID, sender, "Raichu")
	err = tci.PlnK.SetItem(tci.Ctx, item)
	require.True(t, err == nil)

	item1 := keep.GenItem(cookbookResult.CookbookID, sender, "Raichu")
	err = tci.PlnK.SetItem(tci.Ctx, item1)
	require.True(t, err == nil)

	item2 := keep.GenItem(cookbookResult.CookbookID, sender2, "Pichu")
	err = tci.PlnK.SetItem(tci.Ctx, item2)
	require.True(t, err == nil)

	item3 := keep.GenItem(cookbookResult.CookbookID, sender, "Raichu")
	err = tci.PlnK.SetItem(tci.Ctx, item3)
	require.True(t, err == nil)

	cases := map[string]struct {
		sender         sdk.AccAddress
		inputCoinList  types.CoinInputList
		inputItemList  types.TradeItemInputList
		outputCoinList sdk.Coins
		outputItemList types.ItemList
		desiredError   string
		showError      bool
	}{
		"empty cookbook trade input item validation": {
			sender:        sender,
			inputItemList: types.GenTradeItemInputList("", []string{"Pikachu"}),
			outputItemList: types.ItemList{
				List: []types.Item{item1},
			},
			outputCoinList: types.NewPylon(1000000),
			desiredError:   "There should be no empty cookbook ID inputs for trades",
			showError:      true,
		},
		"wrong cookbook id item input validation": {
			sender:         sender,
			inputItemList:  types.GenTradeItemInputList("not-existing-cookbook-id-0001", []string{"Pikachu"}),
			outputCoinList: types.NewPylon(10000),
			showError:      true,
			desiredError:   "You specified a cookbook that does not exist",
		},
		"trade without pylon": {
			sender:        sender,
			inputItemList: types.GenTradeItemInputList(cookbookResult.CookbookID, []string{"Pikachu"}),
			outputItemList: types.ItemList{
				List: []types.Item{item1},
			},
			showError:    true,
			desiredError: "there should be more than 10 amount of pylon per trade",
		},
		"less than minimum amount pylons trading test": {
			sender:        sender,
			inputItemList: types.GenTradeItemInputList(cookbookResult.CookbookID, []string{"Pikachu"}),
			outputItemList: types.ItemList{
				List: []types.Item{item1},
			},
			outputCoinList: types.NewPylon(1),
			desiredError:   "there should be more than 10 amount of pylon per trade",
			showError:      true,
		},
		"trade with item and coins": {
			sender:        sender,
			inputItemList: types.GenTradeItemInputList(cookbookResult.CookbookID, []string{"Pikachu"}),
			outputItemList: types.ItemList{
				List: []types.Item{item},
			},
			outputCoinList: types.NewPylon(10000),
			showError:      false,
		},
		"trade items failure due to sender not being owner": {
			sender:        sender,
			inputCoinList: types.GenCoinInputList(types.Pylon, 10),
			outputItemList: types.ItemList{
				List: []types.Item{item2},
			},
			desiredError: "is not owned by sender",
			showError:    true,
		},
		"trade with coin and item failure due to low balance": {
			sender:        sender,
			inputItemList: types.GenTradeItemInputList(cookbookResult.CookbookID, []string{"Pikachu"}),
			outputItemList: types.ItemList{
				List: []types.Item{item3},
			},
			outputCoinList: types.NewPylon(1000000),
			desiredError:   "sender doesn't have enough coins for the trade",
			showError:      true,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {

			msg := msgs.NewMsgCreateTrade(tc.inputCoinList, tc.inputItemList, tc.outputCoinList, tc.outputItemList, "", tc.sender)

			result, err := tci.PlnH.HandlerMsgCreateTrade(sdk.WrapSDKContext(tci.Ctx), &msg)
			if !tc.showError {
				require.True(t, err == nil)
				require.True(t, len(result.TradeID) > 0)
			} else {
				require.True(t, err != nil)
				require.True(t, strings.Contains(err.Error(), tc.desiredError), err.Error())
			}
		})
	}
}
