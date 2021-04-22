package inttest

import (
	testing "github.com/Pylons-tech/pylons_sdk/cmd/evtesting"

	"github.com/Pylons-tech/pylons_sdk/x/pylons/handlers"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/msgs"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/types"

	inttestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test_utils"
	sdk "github.com/cosmos/cosmos-sdk/types"
	banktypes "github.com/cosmos/cosmos-sdk/x/bank/types"
)

///////////ACCOUNT///////////////////////////////////////////////

// MockAccount generate local key and do initial get-pylons to create cookbook
func MockAccount(key string, t *testing.T) {
	// add local key
	localKeyResult, err := inttestSDK.AddNewLocalKey(key)
	t.WithFields(testing.Fields{
		"key":              key,
		"local_key_result": localKeyResult,
	}).MustNil(err, "error creating local Key")

	addr := localKeyResult["address"]

	// send message for creating account
	result, logstr, err := inttestSDK.CreateChainAccount(key)
	t.WithFields(testing.Fields{
		"result": result,
		"logstr": logstr,
	}).MustNil(err, "error creating account on chain")

	// fetch txhash from result log
	caTxHash := inttestSDK.GetTxHashFromLog(result)
	t.MustTrue(caTxHash != "", "error fetching txhash from result")
	t.WithFields(testing.Fields{
		"txhash": caTxHash,
	}).Info("started waiting for create account transaction")

	// wait for txhash to be confirmed
	txResponseBytes, err := inttestSDK.WaitAndGetTxData(caTxHash, inttestSDK.GetMaxWaitBlock(), t)
	t.WithFields(testing.Fields{
		"result": string(txResponseBytes),
	}).MustNil(err, "error waiting for create account transaction")
	inttestSDK.GetAccountInfoFromAddr(addr, t)

	// get initial balance
	sdkAddr, err := sdk.AccAddressFromBech32(addr)
	t.MustNil(err, "error converting string cosmos address to sdk struct")
	getPylonsMsg := msgs.NewMsgGetPylons(types.PremiumTier.Fee, sdkAddr.String())
	txhash, err := inttestSDK.TestTxWithMsgWithNonce(t, &getPylonsMsg, key, false)
	t.WithFields(testing.Fields{
		"txhash": txhash,
	}).MustNil(err, "error sending transaction")

	txResponseBytes, err = inttestSDK.WaitAndGetTxData(txhash, inttestSDK.GetMaxWaitBlock(), t)
	t.WithFields(testing.Fields{
		"result": string(txResponseBytes),
	}).MustNil(err, "error waiting for get pylons transaction")
}

// FaucetGameCoins get faucet game coins from faucet server
func FaucetGameCoins(key string, amount sdk.Coins, t *testing.T) {
	fromSdkAddr := GetSDKAddressFromKey("node0", t)
	toSdkAddr := GetSDKAddressFromKey(key, t)

	sendCoinsMsg := banktypes.NewMsgSend(fromSdkAddr, toSdkAddr, amount)
	txhash, err := inttestSDK.TestTxWithMsgWithNonce(t, sendCoinsMsg, "node0", false)
	t.WithFields(testing.Fields{
		"txhash": txhash,
	}).MustNil(err, "error sending transaction")

	txResponseBytes, err := inttestSDK.WaitAndGetTxData(txhash, inttestSDK.GetMaxWaitBlock(), t)
	t.WithFields(testing.Fields{
		"result": string(txResponseBytes),
	}).MustNil(err, "error waiting for getting faucet transaction")
}

///////////COOKBOOK//////////////////////////////////////////////

// MockCookbook mock a cookbook which can refer to on all tests
// currently there's no need to create more than 2 cookbooks
func MockCookbook(ownerKey string, createNew bool, t *testing.T) string {
	guid, exist, err := CheckCookbookExist(ownerKey, t)
	t.MustNil(err, "error checking cookbook exist")

	if exist && !createNew { // finish mock if already available
		return guid
	}
	cbOwnerSdkAddr := GetSDKAddressFromKey(ownerKey, t)
	cbMsg := msgs.NewMsgCreateCookbook(
		"COOKBOOK_MOCK_001_"+ownerKey,
		"",
		"this has to meet character limits lol",
		"SketchyCo",
		"1.0.0",
		"example@example.com",
		0,
		msgs.DefaultCostPerBlock,
		cbOwnerSdkAddr.String(),
	)
	txhash, err := inttestSDK.TestTxWithMsgWithNonce(t, &cbMsg, ownerKey, false)
	if err != nil {
		TxBroadcastErrorCheck(txhash, err, t)
		return ""
	}

	WaitOneBlockWithErrorCheck(t)

	txHandleResBytes := GetTxHandleResult(txhash, t)
	resp := msgs.MsgCreateCookbookResponse{}
	err = inttestSDK.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
	TxResBytesUnmarshalErrorCheck(txhash, err, txHandleResBytes, t)
	return resp.CookbookID
}

// CheckCookbookExist is a cookbook existence checker
func CheckCookbookExist(ownerKey string, t *testing.T) (string, bool, error) {
	cbOwnerSdkAddr := GetSDKAddressFromKey(ownerKey, t)
	cbList, err := inttestSDK.ListCookbookViaCLI(cbOwnerSdkAddr.String())
	if err != nil {
		return "", false, err
	}
	if len(cbList) > 0 {
		return cbList[0].ID, true, nil
	}
	return "", false, nil
}

// GetMockedCookbook get mocked cookbook
func GetMockedCookbook(senderName string, createNew bool, t *testing.T) types.Cookbook {
	guid := MockCookbook(senderName, createNew, t)

	cb, err := inttestSDK.GetCookbookByGUID(guid)
	t.MustNil(err, "error getting cookbook by guid")
	return cb
}

// MockNoDelayItemGenRecipeGUID mock no delay item generation recipe
func MockNoDelayItemGenRecipeGUID(cbOwnerKey, name string, outputItemName string, t *testing.T) string {
	return MockRecipeGUID(cbOwnerKey, 0, false, name, "", outputItemName, t)
}

// MockRecipeGUID mock recipe and returns GUID
func MockRecipeGUID(
	cbOwnerKey string,
	interval int64,
	isUpgrdRecipe bool,
	name, curItemName, desItemName string,
	t *testing.T) string {
	if !isUpgrdRecipe {
		return MockDetailedRecipeGUID(
			cbOwnerKey,
			name,
			types.GenCoinInputList("pylon", 5),
			types.ItemInputList{},
			types.EntriesList{
				ItemOutputs: []types.ItemOutput{types.GenItemOnlyEntry(desItemName)},
			},
			types.GenOneOutput(desItemName),
			interval,
			t,
		)
	}
	return MockDetailedRecipeGUID(
		cbOwnerKey,
		name,
		types.GenCoinInputList("pylon", 5),
		types.GenItemInputList(curItemName),
		types.GenEntriesItemNameUpgrade(curItemName, desItemName),
		types.GenOneOutput(desItemName),
		interval,
		t,
	)
}

// MockPopularRecipeGUID mock popular recipe and returns GUID
func MockPopularRecipeGUID(
	cbOwnerKey string,
	hfrt handlers.PopularRecipeType,
	rcpName string,
	t *testing.T,
) string {
	ciL, iiL, entries, outputs, bI := handlers.GetParamsForPopularRecipe(hfrt)
	return MockDetailedRecipeGUID(cbOwnerKey, rcpName, ciL, iiL, entries, outputs, bI, t)
}

// MockDetailedRecipeGUID mock detailed recipe and returns GUID
func MockDetailedRecipeGUID(
	cbOwnerKey string,
	rcpName string,
	ciL types.CoinInputList,
	iiL types.ItemInputList,
	entries types.EntriesList,
	outputs types.WeightedOutputsList,
	interval int64,
	t *testing.T,
) string {
	mCB := GetMockedCookbook(cbOwnerKey, false, t)

	sdkAddr := GetSDKAddressFromKey(cbOwnerKey, t)
	rcpMsg := msgs.NewMsgCreateRecipe(
		rcpName,
		mCB.ID,
		"",
		"this has to meet character limits lol",
		ciL,
		iiL,
		entries,
		outputs,
		interval,
		sdkAddr.String(),
	)
	txhash, err := inttestSDK.TestTxWithMsgWithNonce(t, &rcpMsg, cbOwnerKey, false)
	if err != nil {
		TxBroadcastErrorCheck(txhash, err, t)
		return ""
	}

	WaitOneBlockWithErrorCheck(t)

	txHandleResBytes := GetTxHandleResult(txhash, t)
	resp := msgs.MsgCreateRecipeResponse{}
	err = inttestSDK.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
	TxResBytesUnmarshalErrorCheck(txhash, err, txHandleResBytes, t)

	return resp.RecipeID
}

// MockItemGUID mock item and return item's GUID
func MockItemGUID(cbID, sender, name string, t *testing.T) string {

	sdkAddr := GetSDKAddressFromKey(sender, t)
	itmMsg := msgs.NewMsgFiatItem(
		cbID,
		types.DoubleKeyValueList{},
		types.LongKeyValueList{},
		types.StringKeyValueList{
			List: []types.StringKeyValue{
				{
					Key:   "Name",
					Value: name,
				},
			},
		},
		sdkAddr.String(),
		0,
	)
	txhash, err := inttestSDK.TestTxWithMsgWithNonce(t, &itmMsg, sender, false)
	if err != nil {
		TxBroadcastErrorCheck(txhash, err, t)
		return ""
	}

	WaitOneBlockWithErrorCheck(t)

	txHandleResBytes := GetTxHandleResult(txhash, t)
	resp := msgs.MsgFiatItemResponse{}
	err = inttestSDK.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
	TxResBytesUnmarshalErrorCheck(txhash, err, txHandleResBytes, t)

	return resp.ItemID
}

// MockItemGUIDWithFee mock item with additional transfer fee and return item's GUID
func MockItemGUIDWithFee(cbID, sender, name string, transferFee int64, t *testing.T) string {
	itemOwnerSdkAddr := GetSDKAddressFromKey(sender, t)
	itmMsg := msgs.NewMsgFiatItem(
		cbID,
		types.DoubleKeyValueList{},
		types.LongKeyValueList{},
		types.StringKeyValueList{
			{
				Key:   "Name",
				Value: name,
			},
		},
		itemOwnerSdkAddr.String(),
		transferFee,
	)
	txhash, err := inttestSDK.TestTxWithMsgWithNonce(t, &itmMsg, sender, false)
	if err != nil {
		TxBroadcastErrorCheck(txhash, err, t)
		return ""
	}

	WaitOneBlockWithErrorCheck(t)

	txHandleResBytes := GetTxHandleResult(txhash, t)
	resp := msgs.MsgFiatItemResponse{}
	err = inttestSDK.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
	TxResBytesUnmarshalErrorCheck(txhash, err, txHandleResBytes, t)

	return resp.ItemID
}

// MockDetailedTradeGUID mock trade and return GUID
func MockDetailedTradeGUID(
	tradeCreatorKey string,
	cbID string,
	inputCoinList types.CoinInputList,
	hasInputItem bool, inputItemName string,
	outputCoins sdk.Coins,
	hasOutputItem bool, outputItemID string,
	extraInfo string,
	t *testing.T,
) string {

	sdkAddr := GetSDKAddressFromKey(tradeCreatorKey, t)

	inputItemList := types.GenTradeItemInputList(cbID, []string{inputItemName})
	if !hasInputItem {
		inputItemList = nil
	}
	var outputItems types.ItemList
	if hasOutputItem {
		outputItem, err := inttestSDK.GetItemByGUID(outputItemID)
		t.WithFields(testing.Fields{
			"item_guid": outputItemID,
		}).MustNil(err, "error getting item with target guid")
		outputItems = types.ItemList{
			List: []types.Item{outputItem},
		}
	}

	trdCMsg := msgs.NewMsgCreateTrade(
		inputCoinList,
		inputItemList,
		outputCoins,
		outputItems,
		extraInfo,
		sdkAddr.String(),
	)
	txhash, err := inttestSDK.TestTxWithMsgWithNonce(t, &trdCMsg, tradeCreatorKey, false)
	if err != nil {
		TxBroadcastErrorCheck(txhash, err, t)
		return ""
	}

	GetTxHandleResult(txhash, t)
	// check trade created after transaction is mined
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
