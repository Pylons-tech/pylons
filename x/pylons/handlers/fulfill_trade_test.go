package handlers

import (
	"encoding/json"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

// TestHandlerMsgFulfillTrade is fulfill trade test
func TestHandlerMsgFulfillTrade(t *testing.T) {
	tci := keep.SetupTestCoinInput()
	sender, sender2, sender3, sender4 := keep.SetupTestAccounts(t, tci, sdk.Coins{
		sdk.NewInt64Coin("chair", 100000),
		sdk.NewInt64Coin(types.Pylon, 100000),
	}, types.NewPylon(100000), types.NewPylon(100000), types.NewPylon(100000))

	_, err := tci.Bk.AddCoins(tci.Ctx, sender2, sdk.Coins{
		sdk.NewInt64Coin("aaaa", 100000),
		sdk.NewInt64Coin("cccc", 100000),
		sdk.NewInt64Coin(types.Pylon, 100000),
		sdk.NewInt64Coin("zzzz", 100000),
	})
	require.True(t, err == nil)

	cbData := CreateCookbookResponse{}
	cbData1 := CreateCookbookResponse{}

	cookbookMsg := msgs.NewMsgCreateCookbook("cookbook-0001", "", "this has to meet character limits", "SketchyCo", "1.0.0", "example@example.com", 1, msgs.DefaultCostPerBlock, sender)
	cookbookResult, _ := HandlerMsgCreateCookbook(tci.Ctx, tci.PlnK, cookbookMsg)
	err = json.Unmarshal(cookbookResult.Data, &cbData)
	require.True(t, err == nil)
	require.True(t, len(cbData.CookbookID) > 0)

	item := keep.GenItem(cbData.CookbookID, sender, "Raichu")
	err = tci.PlnK.SetItem(tci.Ctx, *item)
	require.True(t, err == nil)

	item2 := keep.GenItem(cbData.CookbookID, sender2, "Pikachu")
	item2.SetTransferFee(200)
	err = tci.PlnK.SetItem(tci.Ctx, *item2)
	require.True(t, err == nil)

	item3 := keep.GenItem(cbData.CookbookID, sender2, "Rikchu")
	item3.SetTransferFee(50)
	err = tci.PlnK.SetItem(tci.Ctx, *item3)
	require.True(t, err == nil)

	item5 := keep.GenItem(cbData.CookbookID, sender2, "Pychu")
	item5.SetTransferFee(50)
	err = tci.PlnK.SetItem(tci.Ctx, *item5)
	require.True(t, err == nil)

	// Create cookbook for sender3
	cookbookMsg1 := msgs.NewMsgCreateCookbook("cookbook-0002", "", "this has to meet character limits", "SketchyCo", "1.0.0", "example@example.com", 1, msgs.DefaultCostPerBlock, sender3)
	cookbookResult1, _ := HandlerMsgCreateCookbook(tci.Ctx, tci.PlnK, cookbookMsg1)
	err = json.Unmarshal(cookbookResult1.Data, &cbData1)
	require.True(t, err == nil)
	require.True(t, len(cbData1.CookbookID) > 0)

	item4 := keep.GenItem(cbData1.CookbookID, sender4, "Tachu")
	item4.SetTransferFee(70)
	err = tci.PlnK.SetItem(tci.Ctx, *item4)
	require.True(t, err == nil)

	item6 := keep.GenItem(cbData1.CookbookID, sender4, "Bhachu")
	item6.SetTransferFee(70)
	err = tci.PlnK.SetItem(tci.Ctx, *item6)
	require.True(t, err == nil)

	cases := map[string]struct {
		sender                sdk.AccAddress
		fulfiller             sdk.AccAddress
		inputCoinList         types.CoinInputList
		inputItemList         types.TradeItemInputList
		outputCoinList        sdk.Coins
		outputItemList        types.ItemList
		fulfillInputItemIDs   []string
		desiredError          string
		showError             bool
		senderAmountDiffer    types.CoinInputList
		sender2AmountDiffer   types.CoinInputList
		sender3AmountDiffer   types.CoinInputList
		sender4AmountDiffer   types.CoinInputList
		pylonsLLCAmountDiffer types.CoinInputList
	}{
		"trade pylon distribution test": {
			sender:         sender,
			fulfiller:      sender2,
			inputCoinList:  types.GenCoinInputList(types.Pylon, 100),
			outputCoinList: sdk.Coins{sdk.NewInt64Coin("chair", 10)},
			desiredError:   "",
			showError:      false,
			senderAmountDiffer: []types.CoinInput{
				{Coin: types.Pylon, Count: 90},
				{Coin: "chair", Count: -10},
			},
			sender2AmountDiffer: []types.CoinInput{
				{Coin: types.Pylon, Count: -100},
				{Coin: "chair", Count: 10},
			},
		},
		"trade unordered coin input test": {
			sender:    sender,
			fulfiller: sender2,
			inputCoinList: []types.CoinInput{
				{Coin: types.Pylon, Count: 100},
				{Coin: "aaaa", Count: 100},
				{Coin: "zzzz", Count: 100},
				{Coin: "cccc", Count: 100},
			},
			outputCoinList: sdk.Coins{sdk.NewInt64Coin("chair", 10)},
			desiredError:   "",
			showError:      false,
			senderAmountDiffer: []types.CoinInput{
				{Coin: types.Pylon, Count: 90},
				{Coin: "aaaa", Count: 100},
				{Coin: "zzzz", Count: 100},
				{Coin: "cccc", Count: 100},
			},
			sender2AmountDiffer: []types.CoinInput{
				{Coin: types.Pylon, Count: -100},
				{Coin: "aaaa", Count: -100},
				{Coin: "zzzz", Count: -100},
				{Coin: "cccc", Count: -100},
			},
		},
		"empty fulfill item on item trading fulfill test": {
			sender:              sender,
			fulfiller:           sender2,
			inputCoinList:       types.GenCoinInputList(types.Pylon, 100),
			inputItemList:       types.GenTradeItemInputList(cbData.CookbookID, []string{"Pikachu"}),
			outputCoinList:      sdk.Coins{sdk.NewInt64Coin("chair", 10)},
			fulfillInputItemIDs: []string{},
			desiredError:        "the item IDs count doesn't match the trade input",
			showError:           true,
		},
		"input item with wrong cookbook id fulfill trade test": {
			sender:         sender,
			fulfiller:      sender2,
			inputCoinList:  types.GenCoinInputList(types.Pylon, 100),
			inputItemList:  types.GenTradeItemInputList(cbData.CookbookID, []string{"Pikachu"}),
			outputCoinList: sdk.Coins{sdk.NewInt64Coin("chair", 10)},
			desiredError:   "the sender doesn't have the trade item attributes",
			showError:      true,
		},
		"item trade with small pylons amout": {
			sender:              sender2,
			fulfiller:           sender4,
			inputCoinList:       types.GenCoinInputList(types.Pylon, 20),
			inputItemList:       types.GenTradeItemInputList(cbData1.CookbookID, []string{"Tachu"}),
			outputCoinList:      types.NewPylon(10),
			outputItemList:      types.ItemList{*item3},
			fulfillInputItemIDs: []string{item4.ID},
			desiredError:        "total pylons amount is not enough to pay fees",
			showError:           true,
		},
		"correct item trading fulfill test": {
			sender:              sender,
			fulfiller:           sender2,
			inputCoinList:       types.GenCoinInputList(types.Pylon, 800),
			inputItemList:       types.GenTradeItemInputList(cbData.CookbookID, []string{"Pikachu"}),
			outputCoinList:      sdk.Coins{sdk.NewInt64Coin("chair", 10)},
			fulfillInputItemIDs: []string{item2.ID},
			desiredError:        "",
			showError:           false,
			senderAmountDiffer: []types.CoinInput{
				{Coin: types.Pylon, Count: 780},
				{Coin: "chair", Count: -10},
			},
			sender2AmountDiffer: []types.CoinInput{
				{Coin: types.Pylon, Count: -800},
				{Coin: "chair", Count: 10},
			},
			pylonsLLCAmountDiffer: []types.CoinInput{{Coin: types.Pylon, Count: 20}},
		},
		"correct item trading fulfill test with 2 items and 2 amounts": {
			sender:                sender2,
			fulfiller:             sender4,
			inputCoinList:         types.GenCoinInputList(types.Pylon, 50),
			inputItemList:         types.GenTradeItemInputList(cbData1.CookbookID, []string{"Bhachu"}),
			outputCoinList:        types.NewPylon(200),
			outputItemList:        types.ItemList{*item5},
			fulfillInputItemIDs:   []string{item6.ID},
			desiredError:          "",
			showError:             false,
			senderAmountDiffer:    []types.CoinInput{{Coin: types.Pylon, Count: 45}},
			sender2AmountDiffer:   []types.CoinInput{{Coin: types.Pylon, Count: -174}},
			sender3AmountDiffer:   []types.CoinInput{{Coin: types.Pylon, Count: 63}},
			sender4AmountDiffer:   []types.CoinInput{{Coin: types.Pylon, Count: 54}},
			pylonsLLCAmountDiffer: []types.CoinInput{{Coin: types.Pylon, Count: 12}},
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			// get pylons amount of all accounts
			senderAmountFirst := tci.PlnK.CoinKeeper.GetCoins(tci.Ctx, sender)
			sender2AmountFirst := tci.PlnK.CoinKeeper.GetCoins(tci.Ctx, sender2)
			sender3AmountFirst := tci.PlnK.CoinKeeper.GetCoins(tci.Ctx, sender3)
			sender4AmountFirst := tci.PlnK.CoinKeeper.GetCoins(tci.Ctx, sender4)

			// get pylons LLC address
			pylonsLLCAddress, err := sdk.AccAddressFromBech32(config.Config.Validators.PylonsLLC)
			require.True(t, err == nil)

			// get pylons amount of pylons LLC amount
			pylonsLLCAmountFirst := tci.PlnK.CoinKeeper.GetCoins(tci.Ctx, pylonsLLCAddress)

			ctMsg := msgs.NewMsgCreateTrade(tc.inputCoinList, tc.inputItemList, tc.outputCoinList, tc.outputItemList, "", tc.sender)
			ctResult, err := HandlerMsgCreateTrade(tci.Ctx, tci.PlnK, ctMsg)
			if err != nil {
				t.Log(err)
			}
			require.True(t, err == nil)
			ctRespData := CreateTradeResponse{}
			err = json.Unmarshal(ctResult.Data, &ctRespData)
			require.True(t, err == nil)
			require.True(t, len(ctRespData.TradeID) > 0)
			ffMsg := msgs.NewMsgFulfillTrade(ctRespData.TradeID, tc.fulfiller, tc.fulfillInputItemIDs)
			ffResult, err := HandlerMsgFulfillTrade(tci.Ctx, tci.PlnK, ffMsg)
			if !tc.showError {
				if err != nil {
					t.Log(err)
				}
				require.True(t, err == nil)
				ffRespData := FulfillTradeResponse{}
				err = json.Unmarshal(ffResult.Data, &ffRespData)
				require.True(t, err == nil)
				require.True(t, ffRespData.Status == "Success")
				require.True(t, ffRespData.Message == "successfully fulfilled the trade")

				for _, diff := range tc.senderAmountDiffer {
					d := tci.PlnK.CoinKeeper.GetCoins(tci.Ctx, sender).AmountOf(diff.Coin).Int64() - senderAmountFirst.AmountOf(diff.Coin).Int64()
					require.True(t, d == diff.Count)
				}
				for _, diff := range tc.sender2AmountDiffer {
					d := tci.PlnK.CoinKeeper.GetCoins(tci.Ctx, sender2).AmountOf(diff.Coin).Int64() - sender2AmountFirst.AmountOf(diff.Coin).Int64()
					require.True(t, d == diff.Count)
				}
				for _, diff := range tc.sender3AmountDiffer {
					d := tci.PlnK.CoinKeeper.GetCoins(tci.Ctx, sender3).AmountOf(diff.Coin).Int64() - sender3AmountFirst.AmountOf(diff.Coin).Int64()
					require.True(t, d == diff.Count)
				}
				for _, diff := range tc.sender4AmountDiffer {
					d := tci.PlnK.CoinKeeper.GetCoins(tci.Ctx, sender4).AmountOf(diff.Coin).Int64() - sender4AmountFirst.AmountOf(diff.Coin).Int64()
					require.True(t, d == diff.Count)
				}
				for _, diff := range tc.pylonsLLCAmountDiffer {
					d := tci.PlnK.CoinKeeper.GetCoins(tci.Ctx, pylonsLLCAddress).AmountOf(diff.Coin).Int64() - pylonsLLCAmountFirst.AmountOf(diff.Coin).Int64()
					require.True(t, d == diff.Count)
				}
			}
		})
	}
}
