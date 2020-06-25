package inttest

import (
	testing "github.com/Pylons-tech/pylons_sdk/cmd/fixtures_test/evtesting"

	"github.com/Pylons-tech/pylons_sdk/x/pylons/handlers"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/msgs"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/types"

	inttestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

///////////COOKBOOK//////////////////////////////////////////////

// MockCookbook mock a cookbook which can refer to on all tests
// currently there's no need to create more than 2 cookbooks
func MockCookbook(createNew bool, t *testing.T) (string, error) {
	guid, exist, err := CheckCookbookExist()
	if err != nil {
		return "", err
	}
	if exist && !createNew { // finish mock if already available
		return guid, nil
	}
	eugenAddr := inttestSDK.GetAccountAddr("eugen", t)
	sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
	t.MustNil(err, "error converting string address to AccAddress struct")

	txhash, err := inttestSDK.TestTxWithMsgWithNonce(t, msgs.NewMsgCreateCookbook(
		"COOKBOOK_MOCK_001",
		"",
		"this has to meet character limits lol",
		"SketchyCo",
		"1.0.0",
		"example@example.com",
		0,
		msgs.DefaultCostPerBlock,
		sdkAddr),
		"eugen",
		false,
	)
	if err != nil {
		TxBroadcastErrorCheck(txhash, err, t)
		return "", err
	}

	WaitOneBlockWithErrorCheck(t)

	txHandleResBytes := GetTxHandleResult(txhash, t)
	resp := handlers.CreateCookbookResponse{}
	err = inttestSDK.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
	TxResBytesUnmarshalErrorCheck(txhash, err, txHandleResBytes, t)
	return resp.CookbookID, nil
}

// CheckCookbookExist is a cookbook existence checker
func CheckCookbookExist() (string, bool, error) {
	cbList, err := inttestSDK.ListCookbookViaCLI("")
	if err != nil {
		return "", false, err
	}
	if len(cbList) > 0 {
		return cbList[0].ID, true, nil
	}
	return "", false, nil
}

// GetMockedCookbook get mocked cookbook
func GetMockedCookbook(createNew bool, t *testing.T) types.Cookbook {
	guid, err := MockCookbook(createNew, t)
	if err != nil {
		t.WithFields(testing.Fields{
			"error": err,
		}).Fatal("error mocking cookbook")
	}

	cb, err := inttestSDK.GetCookbookByGUID(guid)
	if err != nil {
		t.WithFields(testing.Fields{
			"error": err,
		}).Fatal("error mocking cookbook")
	}
	return cb
}

// MockNoDelayItemGenRecipeGUID mock no delay item generation recipe
func MockNoDelayItemGenRecipeGUID(name string, outputItemName string, t *testing.T) (string, error) {
	return MockRecipeGUID(0, false, name, "", outputItemName, t)
}

// MockRecipeGUID mock recipe and returns GUID
func MockRecipeGUID(
	interval int64,
	isUpgrdRecipe bool,
	name, curItemName, desItemName string,
	t *testing.T) (string, error) {
	if !isUpgrdRecipe {
		return MockDetailedRecipeGUID(name,
			types.GenCoinInputList("pylon", 5),
			types.ItemInputList{},
			types.GenItemOnlyEntry(desItemName),
			types.GenOneOutput(1),
			interval,
			t,
		)
	}
	return MockDetailedRecipeGUID(name,
		types.GenCoinInputList("pylon", 5),
		types.GenItemInputList(curItemName),
		types.GenEntriesFirstItemNameUpgrade(desItemName),
		types.GenOneOutput(1),
		interval,
		t,
	)
}

// MockPopularRecipeGUID mock popular recipe and returns GUID
func MockPopularRecipeGUID(hfrt handlers.PopularRecipeType,
	rcpName string,
	t *testing.T,
) (string, error) {
	ciL, iiL, entries, outputs, bI := handlers.GetParamsForPopularRecipe(hfrt)
	return MockDetailedRecipeGUID(rcpName, ciL, iiL, entries, outputs, bI, t)
}

// MockDetailedRecipeGUID mock detailed recipe and returns GUID
func MockDetailedRecipeGUID(
	rcpName string,
	ciL types.CoinInputList,
	iiL types.ItemInputList,
	entries types.EntriesList,
	outputs types.WeightedOutputsList,
	interval int64,
	t *testing.T,
) (string, error) {
	guid, err := inttestSDK.GetRecipeGUIDFromName(rcpName, "")
	if err != nil {
		t.WithFields(testing.Fields{
			"error": err,
		}).Fatal("error checking if recipe already exist")
	}

	if len(guid) > 0 { // finish mock if already available
		return guid, nil
	}

	mCB := GetMockedCookbook(false, t)
	if err != nil {
		t.WithFields(testing.Fields{
			"error": err,
		}).Fatal("error getting mocked cookbook")
	}

	eugenAddr := inttestSDK.GetAccountAddr("eugen", t)
	sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
	t.MustNil(err, "error converting string address to AccAddress struct")
	txhash, err := inttestSDK.TestTxWithMsgWithNonce(t,
		msgs.NewMsgCreateRecipe(
			rcpName,
			mCB.ID,
			"",
			"this has to meet character limits lol",
			ciL,
			iiL,
			entries,
			outputs,
			interval,
			sdkAddr),
		"eugen",
		false,
	)
	if err != nil {
		TxBroadcastErrorCheck(txhash, err, t)
		return "", err
	}

	WaitOneBlockWithErrorCheck(t)

	txHandleResBytes := GetTxHandleResult(txhash, t)
	resp := handlers.CreateRecipeResponse{}
	err = inttestSDK.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
	TxResBytesUnmarshalErrorCheck(txhash, err, txHandleResBytes, t)

	return resp.RecipeID, nil
}

// MockItemGUID mock item and return item's GUID
func MockItemGUID(cbID, sender, name string, t *testing.T) string {

	eugenAddr := inttestSDK.GetAccountAddr(sender, t)
	sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
	t.MustNil(err, "error converting string address to AccAddress struct")

	txhash, err := inttestSDK.TestTxWithMsgWithNonce(t, msgs.NewMsgFiatItem(
		cbID,
		[]types.DoubleKeyValue{},
		[]types.LongKeyValue{},
		[]types.StringKeyValue{
			{
				Key:   "Name",
				Value: name,
			},
		},
		sdkAddr,
		0,
	),
		sender,
		false,
	)
	if err != nil {
		TxBroadcastErrorCheck(txhash, err, t)
		return ""
	}

	WaitOneBlockWithErrorCheck(t)

	txHandleResBytes := GetTxHandleResult(txhash, t)
	resp := handlers.FiatItemResponse{}
	err = inttestSDK.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
	TxResBytesUnmarshalErrorCheck(txhash, err, txHandleResBytes, t)

	return resp.ItemID
}

// MockItemGUIDWithFee mock item with additional transfer fee and return item's GUID
func MockItemGUIDWithFee(cbID, sender, name string, additionalFee int64, t *testing.T) string {

	senderAddr := inttestSDK.GetAccountAddr(sender, t)
	sdkAddr, err := sdk.AccAddressFromBech32(senderAddr)
	t.MustNil(err, "error converting string address to AccAddress struct")

	txhash, err := inttestSDK.TestTxWithMsgWithNonce(t, msgs.NewMsgFiatItem(
		cbID,
		[]types.DoubleKeyValue{},
		[]types.LongKeyValue{},
		[]types.StringKeyValue{
			{
				Key:   "Name",
				Value: name,
			},
		},
		sdkAddr,
		additionalFee,
	),
		sender,
		false,
	)
	if err != nil {
		TxBroadcastErrorCheck(txhash, err, t)
		return ""
	}

	WaitOneBlockWithErrorCheck(t)

	txHandleResBytes := GetTxHandleResult(txhash, t)
	resp := handlers.FiatItemResponse{}
	err = inttestSDK.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
	TxResBytesUnmarshalErrorCheck(txhash, err, txHandleResBytes, t)

	return resp.ItemID
}

// MockDetailedTradeGUID mock trade and return GUID
func MockDetailedTradeGUID(
	cbID string,
	inputCoinList types.CoinInputList,
	hasInputItem bool, inputItemName string,
	hasOutputCoin bool, outputCoinName string, outputCoinAmount int64,
	hasOutputItem bool, outputItemID string,
	extraInfo string,
	t *testing.T,
) string {
	eugenAddr := inttestSDK.GetAccountAddr("eugen", t)
	sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
	t.MustNil(err, "error converting string address to AccAddress struct")

	inputItemList := types.GenTradeItemInputList(cbID, []string{inputItemName})
	if !hasInputItem {
		inputItemList = nil
	}
	var outputCoins sdk.Coins
	if !hasOutputCoin {
		outputCoins = nil
	} else {
		outputCoins = sdk.Coins{sdk.NewInt64Coin(outputCoinName, outputCoinAmount)}
	}
	var outputItems types.ItemList
	if hasOutputItem {
		outputItem, err := inttestSDK.GetItemByGUID(outputItemID)
		t.WithFields(testing.Fields{
			"item_guid": outputItemID,
		}).MustNil(err, "error getting item with target guid")
		outputItems = types.ItemList{outputItem}
	}

	txhash, err := inttestSDK.TestTxWithMsgWithNonce(t,
		msgs.NewMsgCreateTrade(
			inputCoinList,
			inputItemList,
			outputCoins,
			outputItems,
			extraInfo,
			sdkAddr),
		"eugen",
		false,
	)
	if err != nil {
		TxBroadcastErrorCheck(txhash, err, t)
		return ""
	}

	GetTxHandleResult(txhash, t)
	// check trade created after 1 block
	tradeID, exist, err := inttestSDK.GetTradeIDFromExtraInfo(extraInfo)
	t.WithFields(testing.Fields{
		"extra_info": extraInfo,
	}).MustNil(err, "error getting trade id from extra info")
	t.WithFields(testing.Fields{
		"extra_info": extraInfo,
	}).MustTrue(exist, "trade id with the extra info does not exist")
	t.MustTrue(len(tradeID) > 0, "trade id should not be empty")
	return tradeID
}
