package handlers

import (
	"strings"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/google/uuid"
	"github.com/stretchr/testify/require"
)

func TestHandlerMsgCreateTrade(t *testing.T) {
	tci := keeper.SetupTestCoinInput()
	tci.PlnH = NewMsgServerImpl(tci.PlnK)
	sender, sender2, _, _ := keeper.SetupTestAccounts(t, tci, types.NewPylon(100000), nil, nil, nil)

	err := tci.Bk.AddCoins(tci.Ctx, sender2, types.NewPylon(100000))
	require.NoError(t, err)

	cookbookMsg := types.NewMsgCreateCookbook(
		"cookbook-0001",
		"cookbook-id-0001",
		"this has to meet character limits",
		"SketchyCo",
		"1.0.0",
		"example@example.com",
		1,
		types.DefaultCostPerBlock,
		sender.String(),
	)
	cookbookResult, _ := tci.PlnH.CreateCookbook(sdk.WrapSDKContext(tci.Ctx), &cookbookMsg)
	require.True(t, len(cookbookResult.CookbookID) > 0)

	item := keeper.GenItem(cookbookResult.CookbookID, sender, "Raichu")
	err = tci.PlnK.SetItem(tci.Ctx, item)
	require.NoError(t, err)

	item1 := keeper.GenItem(cookbookResult.CookbookID, sender, "Raichu")
	err = tci.PlnK.SetItem(tci.Ctx, item1)
	require.NoError(t, err)

	item2 := keeper.GenItem(cookbookResult.CookbookID, sender2, "Pichu")
	err = tci.PlnK.SetItem(tci.Ctx, item2)
	require.NoError(t, err)

	item3 := keeper.GenItem(cookbookResult.CookbookID, sender, "Raichu")
	err = tci.PlnK.SetItem(tci.Ctx, item3)
	require.NoError(t, err)

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
				item1,
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
				item1,
			},
			showError:    true,
			desiredError: "there should be more than 10 amount of pylon per trade",
		},
		"less than minimum amount pylons trading test": {
			sender:        sender,
			inputItemList: types.GenTradeItemInputList(cookbookResult.CookbookID, []string{"Pikachu"}),
			outputItemList: types.ItemList{
				item1,
			},
			outputCoinList: types.NewPylon(1),
			desiredError:   "there should be more than 10 amount of pylon per trade",
			showError:      true,
		},
		"trade with item and coins": {
			sender:        sender,
			inputItemList: types.GenTradeItemInputList(cookbookResult.CookbookID, []string{"Pikachu"}),
			outputItemList: types.ItemList{
				item,
			},
			outputCoinList: types.NewPylon(10000),
			showError:      false,
		},
		"trade items failure due to sender not being owner": {
			sender:        sender,
			inputCoinList: types.GenCoinInputList(types.Pylon, 10),
			outputItemList: types.ItemList{
				item2,
			},
			desiredError: "is not owned by sender",
			showError:    true,
		},
		"trade with coin and item failure due to low balance": {
			sender:        sender,
			inputItemList: types.GenTradeItemInputList(cookbookResult.CookbookID, []string{"Pikachu"}),
			outputItemList: types.ItemList{
				item3,
			},
			outputCoinList: types.NewPylon(1000000),
			desiredError:   "sender doesn't have enough coins for the trade",
			showError:      true,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {

			msg := types.NewMsgCreateTrade(tc.inputCoinList, tc.inputItemList, tc.outputCoinList, tc.outputItemList, "", tc.sender.String())

			result, err := tci.PlnH.CreateTrade(sdk.WrapSDKContext(tci.Ctx), &msg)
			if !tc.showError {
				require.NoError(t, err)
				require.True(t, len(result.TradeID) > 0)
			} else {
				require.True(t, err != nil)
				require.True(t, strings.Contains(err.Error(), tc.desiredError), err.Error())
			}
		})
	}
}

// TestHandlerMsgFulfillTrade is fulfill trade test
func TestHandlerMsgFulfillTrade(t *testing.T) {
	tci := keeper.SetupTestCoinInput()
	tci.PlnH = NewMsgServerImpl(tci.PlnK)
	sender, sender2, sender3, sender4 := keeper.SetupTestAccounts(t, tci, sdk.Coins{
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

	item := keeper.GenItem(cookbookResult.CookbookID, sender, "Raichu")
	err = tci.PlnK.SetItem(tci.Ctx, item)
	require.NoError(t, err)

	item2 := keeper.GenItem(cookbookResult.CookbookID, sender2, "Pikachu")
	item2.SetTransferFee(200)
	err = tci.PlnK.SetItem(tci.Ctx, item2)
	require.NoError(t, err)

	item3 := keeper.GenItem(cookbookResult.CookbookID, sender2, "Rikchu")
	item3.SetTransferFee(50)
	err = tci.PlnK.SetItem(tci.Ctx, item3)
	require.NoError(t, err)

	item5 := keeper.GenItem(cookbookResult.CookbookID, sender2, "Pychu")
	item5.SetTransferFee(50)
	err = tci.PlnK.SetItem(tci.Ctx, item5)
	require.NoError(t, err)

	// Create cookbook for sender3
	cookbookMsg1 := types.NewMsgCreateCookbook("cookbook-0002", "", "this has to meet character limits", "SketchyCo", "1.0.0", "example@example.com", 1, types.DefaultCostPerBlock, sender3.String())
	cookbookResult1, _ := tci.PlnH.CreateCookbook(sdk.WrapSDKContext(tci.Ctx), &cookbookMsg1)
	require.True(t, len(cookbookResult1.CookbookID) > 0)

	item4 := keeper.GenItem(cookbookResult1.CookbookID, sender4, "Tachu")
	item4.SetTransferFee(70)
	err = tci.PlnK.SetItem(tci.Ctx, item4)
	require.NoError(t, err)

	item6 := keeper.GenItem(cookbookResult1.CookbookID, sender4, "Bhachu")
	item6.SetTransferFee(70)
	err = tci.PlnK.SetItem(tci.Ctx, item6)
	require.NoError(t, err)

	item8 := keeper.GenItem(cookbookResult1.CookbookID, sender5, "Bhachu8")
	item8.SetTransferFee(70)
	err = tci.PlnK.SetItem(tci.Ctx, item8)
	require.NoError(t, err)

	item7 := keeper.GenItem("wrongCBID", sender2, "Pikachu")
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

func TestHandlerMsgDisableTrade(t *testing.T) {
	tci := keeper.SetupTestCoinInput()
	tci.PlnH = NewMsgServerImpl(tci.PlnK)
	sender, sender2, _, _ := keeper.SetupTestAccounts(t, tci, types.NewPylon(100000), nil, nil, nil)

	err := tci.Bk.AddCoins(tci.Ctx, sender2, types.NewPylon(100000))
	require.NoError(t, err)

	id := uuid.New()
	id2 := uuid.New()
	id3 := uuid.New()
	id4 := uuid.New()

	cookbookMsg := types.NewMsgCreateCookbook(
		"cookbook-0001",
		"cookbook-id-0001",
		"this has to meet character limits",
		"SketchyCo",
		"1.0.0",
		"example@example.com",
		1,
		types.DefaultCostPerBlock,
		sender.String(),
	)
	cookbookResult, _ := tci.PlnH.CreateCookbook(sdk.WrapSDKContext(tci.Ctx), &cookbookMsg)
	require.True(t, len(cookbookResult.CookbookID) > 0)

	item := keeper.GenItem(cookbookResult.CookbookID, sender, "Raichu")
	item.OwnerTradeID = id.String()
	err = tci.PlnK.SetItem(tci.Ctx, item)
	require.NoError(t, err)

	// add trades for tests, one open trade by each sender and one closed trade
	err = tci.PlnK.SetTrade(tci.Ctx, types.Trade{
		ID:          id.String(),
		ItemInputs:  types.GenTradeItemInputList("LOUD-CB-001", []string{"Pikachu"}),
		ItemOutputs: types.ItemList{item},
		CoinOutputs: types.NewPylon(10000),
		Sender:      sender.String(),
	})
	require.NoError(t, err)

	err = tci.PlnK.SetTrade(tci.Ctx, types.Trade{
		ID:          id2.String(),
		ItemInputs:  types.GenTradeItemInputList("LOUD-CB-001", []string{"Richu"}),
		CoinOutputs: types.NewPylon(10000),
		Sender:      sender2.String(),
	})
	require.NoError(t, err)

	err = tci.PlnK.SetTrade(tci.Ctx, types.Trade{
		ID:          id3.String(),
		ItemInputs:  types.GenTradeItemInputList("LOUD-CB-001", []string{"Pichu"}),
		CoinOutputs: types.NewPylon(1000),
		Sender:      sender2.String(),
		FulFiller:   sender.String(),
		Completed:   true,
	})
	require.NoError(t, err)

	err = tci.PlnK.SetTrade(tci.Ctx, types.Trade{
		ID:          id4.String(),
		ItemInputs:  types.GenTradeItemInputList("LOUD-CB-001", []string{"Pikachu"}),
		ItemOutputs: types.ItemList{item},
		CoinOutputs: types.NewPylon(10000),
		Sender:      sender2.String(),
	})
	require.NoError(t, err)

	cases := map[string]struct {
		tradeID      string
		sender       sdk.AccAddress
		desiredError string
		showError    bool
	}{
		"disable a trade successfully": {
			tradeID: id.String(),
			sender:  sender,
		},
		"disable a trade failure due to unauthorized sender": {
			tradeID:      id2.String(),
			showError:    true,
			sender:       sender,
			desiredError: "Trade initiator is not the same as sender",
		},
		"disable a completed trade with failure": {
			tradeID:      id3.String(),
			showError:    true,
			sender:       sender2,
			desiredError: "Cannot disable a completed trade",
		},
		"disable wrong item id owner trade with failure": {
			tradeID:      id4.String(),
			showError:    true,
			sender:       sender2,
			desiredError: "is not owned by the trade creator",
		},
	}

	for name, tc := range cases {
		t.Run(name, func(t *testing.T) {

			delTrdMsg := types.NewMsgDisableTrade(tc.tradeID, tc.sender.String())
			_, err := tci.PlnH.DisableTrade(sdk.WrapSDKContext(tci.Ctx), &delTrdMsg)
			if tc.showError == false {
				trd, _ := tci.PlnK.GetTrade(tci.Ctx, tc.tradeID)
				require.True(t, trd.Disabled)
				if trd.ItemOutputs != nil && len(trd.ItemOutputs) > 0 {
					require.True(t, trd.ItemOutputs[0].OwnerTradeID == "")
				}
			} else {
				require.True(t, err != nil)
				require.True(t, strings.Contains(err.Error(), tc.desiredError), err.Error())
			}
		})
	}

}

func TestHandlerMsgEnableTrade(t *testing.T) {
	tci := keeper.SetupTestCoinInput()
	tci.PlnH = NewMsgServerImpl(tci.PlnK)
	sender, sender2, _, _ := keeper.SetupTestAccounts(t, tci, types.NewPylon(100000), nil, nil, nil)

	err := tci.Bk.AddCoins(tci.Ctx, sender2, types.NewPylon(100000))
	require.NoError(t, err)

	id := uuid.New()
	id2 := uuid.New()
	id3 := uuid.New()

	cookbookMsg := types.NewMsgCreateCookbook(
		"cookbook-0001",
		"cookbook-id-0001",
		"this has to meet character limits",
		"SketchyCo",
		"1.0.0",
		"example@example.com",
		1,
		types.DefaultCostPerBlock,
		sender.String(),
	)

	cookbookResult, _ := tci.PlnH.CreateCookbook(sdk.WrapSDKContext(tci.Ctx), &cookbookMsg)
	require.True(t, len(cookbookResult.CookbookID) > 0)

	item := keeper.GenItem(cookbookResult.CookbookID, sender, "Raichu")
	// item.OwnerTradeID = id.String()
	err = tci.PlnK.SetItem(tci.Ctx, item)
	require.NoError(t, err)

	// add 3 trades. one open trade by each sender and one closed trade
	err = tci.PlnK.SetTrade(tci.Ctx, types.Trade{
		ID:          id.String(),
		ItemInputs:  types.GenTradeItemInputList("LOUD-CB-001", []string{"Pikachu"}),
		ItemOutputs: types.ItemList{item},
		CoinOutputs: types.NewPylon(10000),
		Sender:      sender.String(),
		Disabled:    true, // we disable this trade initially
	})
	require.NoError(t, err)

	err = tci.PlnK.SetTrade(tci.Ctx, types.Trade{
		ID:          id2.String(),
		ItemInputs:  types.GenTradeItemInputList("LOUD-CB-001", []string{"Richu"}),
		CoinOutputs: types.NewPylon(10000),
		Sender:      sender2.String(),
	})
	require.NoError(t, err)

	err = tci.PlnK.SetTrade(tci.Ctx, types.Trade{
		ID:          id3.String(),
		ItemInputs:  types.GenTradeItemInputList("LOUD-CB-001", []string{"Pikachu"}),
		ItemOutputs: types.ItemList{item},
		CoinOutputs: types.NewPylon(10000),
		Sender:      sender2.String(),
		Disabled:    true, // we disable this trade initially
	})
	require.NoError(t, err)

	cases := map[string]struct {
		tradeID      string
		sender       sdk.AccAddress
		desiredError string
		showError    bool
	}{
		"enable a trade successfully": {
			tradeID: id.String(),
			sender:  sender,
		},
		"enable a trade failure due to unauthorized sender": {
			tradeID:      id2.String(),
			showError:    true,
			sender:       sender,
			desiredError: "Trade initiator is not the same as sender",
		},
		"enable wrong item id owner trade with failure": {
			tradeID:      id3.String(),
			showError:    true,
			sender:       sender2,
			desiredError: "is not owned by the trade creator",
		},
	}

	for name, tc := range cases {
		t.Run(name, func(t *testing.T) {

			delTrdMsg := types.NewMsgEnableTrade(tc.tradeID, tc.sender.String())
			_, err := tci.PlnH.EnableTrade(sdk.WrapSDKContext(tci.Ctx), &delTrdMsg)
			if tc.showError == false {
				trd, _ := tci.PlnK.GetTrade(tci.Ctx, tc.tradeID)
				require.True(t, !trd.Disabled)
				if trd.ItemOutputs != nil && len(trd.ItemOutputs) > 0 {
					require.True(t, trd.ItemOutputs[0].OwnerTradeID != "")
				}
			} else {
				require.True(t, err != nil)
				require.True(t, strings.Contains(err.Error(), tc.desiredError), err.Error())
			}
		})
	}
}
