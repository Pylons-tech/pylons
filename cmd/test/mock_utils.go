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
func MockCookbook(t *testing.T) (string, error) {
	guid, exist, err := CheckCookbookExist()
	if err != nil {
		return "", err
	}
	if exist { // finish mock if already available
		return guid, nil
	}
	eugenAddr := inttestSDK.GetAccountAddr("eugen", t)
	sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
	t.MustNil(err)

	txhash := inttestSDK.TestTxWithMsgWithNonce(t, msgs.NewMsgCreateCookbook(
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

	err = inttestSDK.WaitForNextBlock()
	if err != nil {
		t.WithFields(testing.Fields{
			"error": err,
		}).Fatal("error waiting for creating cookbook")
	}

	txHandleResBytes, err := inttestSDK.WaitAndGetTxData(txhash, 3, t)
	t.MustNil(err)
	resp := handlers.CreateCBResponse{}
	err = inttestSDK.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
	t.MustNil(err)

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
func GetMockedCookbook(t *testing.T) (types.Cookbook, error) {
	guid, err := MockCookbook(t)
	if err != nil {
		t.WithFields(testing.Fields{
			"error": err,
		}).Fatal("error mocking cookbook")
	}

	return inttestSDK.GetCookbookByGUID(guid)
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

	mCB, err := GetMockedCookbook(t)
	if err != nil {
		t.WithFields(testing.Fields{
			"error": err,
		}).Fatal("error getting mocked cookbook")
	}

	eugenAddr := inttestSDK.GetAccountAddr("eugen", t)
	sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
	t.MustNil(err)
	txhash := inttestSDK.TestTxWithMsgWithNonce(t,
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

	err = inttestSDK.WaitForNextBlock()
	if err != nil {
		t.WithFields(testing.Fields{
			"error": err,
		}).Fatal("error waiting for creating recipe")
	}

	txHandleResBytes, err := inttestSDK.WaitAndGetTxData(txhash, 3, t)
	t.MustNil(err)
	resp := handlers.CreateRecipeResponse{}
	err = inttestSDK.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
	t.MustNil(err)

	return resp.RecipeID, nil
}

// MockItemGUID mock item and return item's GUID
func MockItemGUID(name string, t *testing.T) string {
	mCB, err := GetMockedCookbook(t)
	if err != nil {
		t.WithFields(testing.Fields{
			"error": err,
		}).Fatal("error getting mocked cookbook")
	}

	eugenAddr := inttestSDK.GetAccountAddr("eugen", t)
	sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
	t.MustNil(err)

	txhash := inttestSDK.TestTxWithMsgWithNonce(t, msgs.NewMsgFiatItem(mCB.ID,
		[]types.DoubleKeyValue{},
		[]types.LongKeyValue{},
		[]types.StringKeyValue{
			{
				Key:   "Name",
				Value: name,
			},
		},
		sdkAddr,
	),
		"eugen",
		false,
	)

	err = inttestSDK.WaitForNextBlock()
	if err != nil {
		t.WithFields(testing.Fields{
			"error": err,
		}).Fatal("error waiting for creating item")
	}

	txHandleResBytes, err := inttestSDK.WaitAndGetTxData(txhash, 3, t)
	t.MustNil(err)
	resp := handlers.FiatItemResponse{}
	err = inttestSDK.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
	t.MustNil(err)

	return resp.ItemID
}

// MockDetailedTradeGUID mock trade and return GUID
func MockDetailedTradeGUID(
	hasInputCoin bool, inputCoinName string, inputCoinAmount int64,
	hasInputItem bool, inputItemName string,
	hasOutputCoin bool, outputCoinName string, outputCoinAmount int64,
	hasOutputItem bool, outputItemID string,
	extraInfo string,
	t *testing.T,
) string {
	eugenAddr := inttestSDK.GetAccountAddr("eugen", t)
	sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
	t.MustNil(err)

	inputCoinList := types.GenCoinInputList(inputCoinName, inputCoinAmount)
	if !hasInputCoin {
		inputCoinList = nil
	}
	inputItemList := types.GenItemInputList(inputItemName)
	if !hasInputItem {
		inputItemList = nil
	}
	var outputCoins sdk.Coins
	if !hasOutputCoin {
		outputCoins = nil
	} else {
		outputCoins = sdk.Coins{sdk.NewInt64Coin(outputCoinName, outputCoinAmount)}
	}
	var outputItems types.ItemList = nil
	if hasOutputItem {
		outputItem, err := inttestSDK.GetItemByGUID(outputItemID)
		t.MustNil(err)
		outputItems = types.ItemList{outputItem}
	}

	txhash := inttestSDK.TestTxWithMsgWithNonce(t,
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

	_, err = inttestSDK.WaitAndGetTxData(txhash, 3, t)
	if err != nil {
		t.WithFields(testing.Fields{
			"error": err,
		}).Fatal("error waiting for creating trade")
	}
	// check trade created after 1 block
	tradeID, exist, err := inttestSDK.GetTradeIDFromExtraInfo(extraInfo)
	t.MustNil(err)
	t.MustTrue(exist)
	t.MustTrue(len(tradeID) > 0)
	return tradeID
}
