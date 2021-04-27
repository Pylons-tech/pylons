package handlers

import (
	"strings"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

// TestHandlerMsgFulfillTrade is fulfill trade test
func TestHandlerMsgFulfillTrade(t *testing.T) {
	tci := keep.SetupTestCoinInput()
	tci.PlnH = NewMsgServerImpl(tci.PlnK)
	sender, sender2, sender3, sender4 := keep.SetupTestAccounts(t, tci, sdk.Coins{
		sdk.NewInt64Coin("chair", 100000),
		sdk.NewInt64Coin(types.Pylon, 100000),
	}, types.NewPylon(100000), types.NewPylon(100000), types.NewPylon(100000))

	_, sender5, _ := GenAccount()

	err := tci.Bk.AddCoins(tci.Ctx, sender2, sdk.Coins{
		sdk.NewInt64Coin("aaaa", 100000),
		sdk.NewInt64Coin("cccc", 100000),
		sdk.NewInt64Coin(types.Pylon, 100000),
		sdk.NewInt64Coin("zzzz", 100000),
	})
	require.NoError(t, err)

	cookbookMsg := types.NewMsgCreateCookbook("cookbook-0001", "", "this has to meet character limits", "SketchyCo", "1.0.0", "example@example.com", 1, types.DefaultCostPerBlock, sender.String())
	cookbookResult, _ := tci.PlnH.CreateCookbook(sdk.WrapSDKContext(tci.Ctx), &cookbookMsg)
	require.True(t, len(cookbookResult.CookbookID) > 0)

	item := keep.GenItem(cookbookResult.CookbookID, sender, "Raichu")
	err = tci.PlnK.SetItem(tci.Ctx, item)
	require.NoError(t, err)

	item2 := keep.GenItem(cookbookResult.CookbookID, sender2, "Pikachu")
	item2.SetTransferFee(200)
	err = tci.PlnK.SetItem(tci.Ctx, item2)
	require.NoError(t, err)

	item3 := keep.GenItem(cookbookResult.CookbookID, sender2, "Rikchu")
	item3.SetTransferFee(50)
	err = tci.PlnK.SetItem(tci.Ctx, item3)
	require.NoError(t, err)

	item5 := keep.GenItem(cookbookResult.CookbookID, sender2, "Pychu")
	item5.SetTransferFee(50)
	err = tci.PlnK.SetItem(tci.Ctx, item5)
	require.NoError(t, err)

	// Create cookbook for sender3
	cookbookMsg1 := types.NewMsgCreateCookbook("cookbook-0002", "", "this has to meet character limits", "SketchyCo", "1.0.0", "example@example.com", 1, types.DefaultCostPerBlock, sender3.String())
	cookbookResult1, _ := tci.PlnH.CreateCookbook(sdk.WrapSDKContext(tci.Ctx), &cookbookMsg1)
	require.True(t, len(cookbookResult1.CookbookID) > 0)

	item4 := keep.GenItem(cookbookResult1.CookbookID, sender4, "Tachu")
	item4.SetTransferFee(70)
	err = tci.PlnK.SetItem(tci.Ctx, item4)
	require.NoError(t, err)

	item6 := keep.GenItem(cookbookResult1.CookbookID, sender4, "Bhachu")
	item6.SetTransferFee(70)
	err = tci.PlnK.SetItem(tci.Ctx, item6)
	require.NoError(t, err)

	item8 := keep.GenItem(cookbookResult1.CookbookID, sender5, "Bhachu8")
	item8.SetTransferFee(70)
	err = tci.PlnK.SetItem(tci.Ctx, item8)
	require.NoError(t, err)

	item7 := keep.GenItem("wrongCBID", sender2, "Pikachu")
	err = tci.PlnK.SetItem(tci.Ctx, item7)
	require.NoError(t, err)

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
			senderAmountDiffer: types.CoinInputList{
				{Coin: types.Pylon, Count: 90},
				{Coin: "chair", Count: -10},
			},
			sender2AmountDiffer: types.CoinInputList{
				{Coin: types.Pylon, Count: -100},
				{Coin: "chair", Count: 10},
			},
		},
		"trade unordered coin input test": {
			sender:    sender,
			fulfiller: sender2,
			inputCoinList: types.CoinInputList{
				{Coin: types.Pylon, Count: 100},
				{Coin: "aaaa", Count: 100},
				{Coin: "zzzz", Count: 100},
				{Coin: "cccc", Count: 100},
			},
			outputCoinList: sdk.Coins{sdk.NewInt64Coin("chair", 10)},
			desiredError:   "",
			showError:      false,
			senderAmountDiffer: types.CoinInputList{
				{Coin: types.Pylon, Count: 90},
				{Coin: "aaaa", Count: 100},
				{Coin: "zzzz", Count: 100},
				{Coin: "cccc", Count: 100},
			},
			sender2AmountDiffer: types.CoinInputList{
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
			inputItemList:       types.GenTradeItemInputList(cookbookResult.CookbookID, []string{"Pikachu"}),
			outputCoinList:      sdk.Coins{sdk.NewInt64Coin("chair", 10)},
			fulfillInputItemIDs: []string{},
			desiredError:        "the item IDs count doesn't match the trade input",
			showError:           true,
		},
		"input item with wrong cookbook id fulfill trade test": {
			sender:              sender,
			fulfiller:           sender2,
			inputCoinList:       types.GenCoinInputList(types.Pylon, 100),
			inputItemList:       types.GenTradeItemInputList(cookbookResult.CookbookID, []string{"Pikachu"}),
			outputCoinList:      sdk.Coins{sdk.NewInt64Coin("chair", 10)},
			fulfillInputItemIDs: []string{item7.ID},
			desiredError:        "[0]th item does not match: cookbook id does not match",
			showError:           true,
		},
		"item trade with small pylons amout": {
			sender:              sender2,
			fulfiller:           sender4,
			inputCoinList:       types.GenCoinInputList(types.Pylon, 20),
			inputItemList:       types.GenTradeItemInputList(cookbookResult1.CookbookID, []string{"Tachu"}),
			outputCoinList:      types.NewPylon(10),
			outputItemList:      types.ItemList{item3},
			fulfillInputItemIDs: []string{item4.ID},
			desiredError:        "total pylons amount is not enough to pay fees",
			showError:           true,
		},
		"correct item trading fulfill test": {
			sender:              sender,
			fulfiller:           sender2,
			inputCoinList:       types.GenCoinInputList(types.Pylon, 800),
			inputItemList:       types.GenTradeItemInputList(cookbookResult.CookbookID, []string{"Pikachu"}),
			outputCoinList:      sdk.Coins{sdk.NewInt64Coin("chair", 10)},
			fulfillInputItemIDs: []string{item2.ID},
			desiredError:        "",
			showError:           false,
			senderAmountDiffer: types.CoinInputList{
				{Coin: types.Pylon, Count: 780},
				{Coin: "chair", Count: -10},
			},
			sender2AmountDiffer: types.CoinInputList{
				{Coin: types.Pylon, Count: -800},
				{Coin: "chair", Count: 10},
			},
			pylonsLLCAmountDiffer: types.CoinInputList{{Coin: types.Pylon, Count: 20}},
		},
		"correct item trading fulfill test with 2 items and 2 amounts": {
			sender:                sender2,
			fulfiller:             sender4,
			inputCoinList:         types.GenCoinInputList(types.Pylon, 50),
			inputItemList:         types.GenTradeItemInputList(cookbookResult1.CookbookID, []string{"Bhachu"}),
			outputCoinList:        types.NewPylon(200),
			outputItemList:        types.ItemList{item5},
			fulfillInputItemIDs:   []string{item6.ID},
			desiredError:          "",
			showError:             false,
			senderAmountDiffer:    types.CoinInputList{{Coin: types.Pylon, Count: 45}},
			sender2AmountDiffer:   types.CoinInputList{{Coin: types.Pylon, Count: -174}},
			sender3AmountDiffer:   types.CoinInputList{{Coin: types.Pylon, Count: 63}},
			sender4AmountDiffer:   types.CoinInputList{{Coin: types.Pylon, Count: 54}},
			pylonsLLCAmountDiffer: types.CoinInputList{{Coin: types.Pylon, Count: 12}},
		},
		"empty coin output trade success test with no locked coin sender": {
			sender:              sender5,
			fulfiller:           sender4,
			inputCoinList:       types.GenCoinInputList(types.Pylon, 500),
			inputItemList:       types.TradeItemInputList{},
			outputCoinList:      nil,
			outputItemList:      types.ItemList{item8},
			fulfillInputItemIDs: []string{},
			desiredError:        "",
			showError:           false,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			// get pylons amount of all accounts
			senderAmountFirst := tci.PlnK.CoinKeeper.GetAllBalances(tci.Ctx, sender)
			sender2AmountFirst := tci.PlnK.CoinKeeper.GetAllBalances(tci.Ctx, sender2)
			sender3AmountFirst := tci.PlnK.CoinKeeper.GetAllBalances(tci.Ctx, sender3)
			sender4AmountFirst := tci.PlnK.CoinKeeper.GetAllBalances(tci.Ctx, sender4)

			// get pylons LLC address
			pylonsLLCAddress, err := sdk.AccAddressFromBech32(config.Config.Validators.PylonsLLC)
			require.NoError(t, err)

			// get pylons amount of pylons LLC amount
			pylonsLLCAmountFirst := tci.PlnK.CoinKeeper.GetAllBalances(tci.Ctx, pylonsLLCAddress)

			ctMsg := types.NewMsgCreateTrade(tc.inputCoinList, tc.inputItemList, tc.outputCoinList, tc.outputItemList, "", tc.sender.String())
			ctResult, err := tci.PlnH.CreateTrade(sdk.WrapSDKContext(tci.Ctx), &ctMsg)
			require.NoError(t, err)
			require.True(t, len(ctResult.TradeID) > 0)
			ffMsg := types.NewMsgFulfillTrade(ctResult.TradeID, tc.fulfiller.String(), tc.fulfillInputItemIDs)
			ffResult, err := tci.PlnH.FulfillTrade(sdk.WrapSDKContext(tci.Ctx), &ffMsg)
			if !tc.showError {
				require.NoError(t, err)
				require.True(t, ffResult.Status == "Success")
				require.True(t, ffResult.Message == "successfully fulfilled the trade")

				for _, diff := range tc.senderAmountDiffer {
					d := tci.PlnK.CoinKeeper.GetAllBalances(tci.Ctx, sender).AmountOf(diff.Coin).Int64() - senderAmountFirst.AmountOf(diff.Coin).Int64()
					require.True(t, d == diff.Count)
				}
				for _, diff := range tc.sender2AmountDiffer {
					d := tci.PlnK.CoinKeeper.GetAllBalances(tci.Ctx, sender2).AmountOf(diff.Coin).Int64() - sender2AmountFirst.AmountOf(diff.Coin).Int64()
					require.True(t, d == diff.Count)
				}
				for _, diff := range tc.sender3AmountDiffer {
					d := tci.PlnK.CoinKeeper.GetAllBalances(tci.Ctx, sender3).AmountOf(diff.Coin).Int64() - sender3AmountFirst.AmountOf(diff.Coin).Int64()
					require.True(t, d == diff.Count)
				}
				for _, diff := range tc.sender4AmountDiffer {
					d := tci.PlnK.CoinKeeper.GetAllBalances(tci.Ctx, sender4).AmountOf(diff.Coin).Int64() - sender4AmountFirst.AmountOf(diff.Coin).Int64()
					require.True(t, d == diff.Count)
				}
				for _, diff := range tc.pylonsLLCAmountDiffer {
					d := tci.PlnK.CoinKeeper.GetAllBalances(tci.Ctx, pylonsLLCAddress).AmountOf(diff.Coin).Int64() - pylonsLLCAmountFirst.AmountOf(diff.Coin).Int64()
					require.True(t, d == diff.Count)
				}
			} else {
				require.True(t, err != nil)
				require.True(t, strings.Contains(err.Error(), tc.desiredError), err.Error(), tc.desiredError)
			}
		})
	}
}
