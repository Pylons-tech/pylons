package intTest

import (
	testing "github.com/Pylons-tech/pylons_sdk/cmd/fixtures_test/evtesting"

	"github.com/Pylons-tech/pylons_sdk/x/pylons/handlers"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/msgs"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	intTestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test"
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
	eugenAddr := intTestSDK.GetAccountAddr("eugen", t)
	sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
	t.MustNil(err)

	txhash := intTestSDK.TestTxWithMsgWithNonce(t, msgs.NewMsgCreateCookbook(
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

	err = intTestSDK.WaitForNextBlock()
	intTestSDK.ErrValidation(t, "error waiting for creating cookbook %+v", err)

	txHandleResBytes, err := intTestSDK.WaitAndGetTxData(txhash, 3, t)
	t.MustNil(err)
	resp := handlers.CreateCBResponse{}
	err = intTestSDK.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
	t.MustNil(err)

	return resp.CookbookID, nil
}

func CheckCookbookExist() (string, bool, error) {
	cbList, err := intTestSDK.ListCookbookViaCLI("")
	if err != nil {
		return "", false, err
	}
	if len(cbList) > 0 {
		return cbList[0].ID, true, nil
	}
	return "", false, nil
}

func GetMockedCookbook(t *testing.T) (types.Cookbook, error) {
	guid, err := MockCookbook(t)
	intTestSDK.ErrValidation(t, "error mocking cookbook %+v", err)

	return intTestSDK.GetCookbookByGUID(guid)
}

///////////RECIPE//////////////////////////////////////////////

func MockNoDelayItemGenRecipeGUID(name string, outputItemName string, t *testing.T) (string, error) {
	return MockRecipeGUID(0, false, name, "", outputItemName, t)
}

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
	} else {
		return MockDetailedRecipeGUID(name,
			types.GenCoinInputList("pylon", 5),
			types.GenItemInputList(curItemName),
			types.GenEntriesFirstItemNameUpgrade(desItemName),
			types.GenOneOutput(1),
			interval,
			t,
		)
	}
}

func MockPopularRecipeGUID(hfrt handlers.PopularRecipeType,
	rcpName string,
	t *testing.T,
) (string, error) {
	ciL, iiL, entries, outputs, bI := handlers.GetParamsForPopularRecipe(hfrt)
	return MockDetailedRecipeGUID(rcpName, ciL, iiL, entries, outputs, bI, t)
}

func MockDetailedRecipeGUID(
	rcpName string,
	ciL types.CoinInputList,
	iiL types.ItemInputList,
	entries types.EntriesList,
	outputs types.WeightedOutputsList,
	interval int64,
	t *testing.T,
) (string, error) {
	guid, err := intTestSDK.GetRecipeGUIDFromName(rcpName, "")
	intTestSDK.ErrValidation(t, "error checking if recipe already exist %+v", err)

	if len(guid) > 0 { // finish mock if already available
		return guid, nil
	}

	mCB, err := GetMockedCookbook(t)
	intTestSDK.ErrValidation(t, "error getting mocked cookbook %+v", err)

	eugenAddr := intTestSDK.GetAccountAddr("eugen", t)
	sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
	t.MustNil(err)
	txhash := intTestSDK.TestTxWithMsgWithNonce(t,
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

	err = intTestSDK.WaitForNextBlock()
	intTestSDK.ErrValidation(t, "error waiting for creating recipe %+v", err)

	txHandleResBytes, err := intTestSDK.WaitAndGetTxData(txhash, 3, t)
	t.MustNil(err)
	resp := handlers.CreateRecipeResponse{}
	err = intTestSDK.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
	t.MustNil(err)

	return resp.RecipeID, nil
}

///////////ITEM//////////////////////////////////////////////

func MockItemGUID(name string, t *testing.T) string {
	mCB, err := GetMockedCookbook(t)
	intTestSDK.ErrValidation(t, "error getting mocked cookbook %+v", err)

	eugenAddr := intTestSDK.GetAccountAddr("eugen", t)
	sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
	t.MustNil(err)

	txhash := intTestSDK.TestTxWithMsgWithNonce(t, msgs.NewMsgFiatItem(mCB.ID,
		[]types.DoubleKeyValue{},
		[]types.LongKeyValue{},
		[]types.StringKeyValue{
			types.StringKeyValue{
				Key:   "Name",
				Value: name,
			},
		},
		sdkAddr,
	),
		"eugen",
		false,
	)

	err = intTestSDK.WaitForNextBlock()
	intTestSDK.ErrValidation(t, "error waiting for creating item %+v", err)

	txHandleResBytes, err := intTestSDK.WaitAndGetTxData(txhash, 3, t)
	t.MustNil(err)
	resp := handlers.FiatItemResponse{}
	err = intTestSDK.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
	t.MustNil(err)

	return resp.ItemID
}

//////////// TRADE //////////////////////////

func MockDetailedTradeGUID(
	hasInputCoin bool, inputCoinName string, inputCoinAmount int64,
	hasInputItem bool, inputItemName string,
	hasOutputCoin bool, outputCoinName string, outputCoinAmount int64,
	hasOutputItem bool, outputItemID string,
	extraInfo string,
	t *testing.T,
) string {
	eugenAddr := intTestSDK.GetAccountAddr("eugen", t)
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
	outputCoins := sdk.Coins{}
	if !hasOutputCoin {
		outputCoins = nil
	} else {
		outputCoins = sdk.Coins{sdk.NewInt64Coin(outputCoinName, outputCoinAmount)}
	}
	var outputItems types.ItemList = nil
	if hasOutputItem {
		outputItem, err := intTestSDK.GetItemByGUID(outputItemID)
		t.MustNil(err)
		outputItems = types.ItemList{outputItem}
	} else {
		outputItems = nil
	}

	txhash := intTestSDK.TestTxWithMsgWithNonce(t,
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

	_, err = intTestSDK.WaitAndGetTxData(txhash, 3, t)
	intTestSDK.ErrValidation(t, "error waiting for creating trade %+v", err)
	// check trade created after 1 block
	tradeID, exist, err := intTestSDK.GetTradeIDFromExtraInfo(extraInfo)
	t.MustNil(err)
	t.MustTrue(exist)
	t.MustTrue(len(tradeID) > 0)
	return tradeID
}
