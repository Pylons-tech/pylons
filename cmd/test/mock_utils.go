package inttest

import (
	"fmt"

	testing "github.com/Pylons-tech/pylons_sdk/cmd/evtesting"

	"github.com/Pylons-tech/pylons_sdk/x/pylons/handlers"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/msgs"
	"github.com/Pylons-tech/pylons_sdk/x/pylons/types"

	inttestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test_utils"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/x/bank"
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
	getPylonsMsg := msgs.NewMsgGetPylons(types.PremiumTier.Fee, sdkAddr)
	txhash, err := inttestSDK.TestTxWithMsgWithNonce(t, getPylonsMsg, key, false)
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
	fromAddress := inttestSDK.GetAccountAddr("node0", t)
	fromSdkAddr, err := sdk.AccAddressFromBech32(fromAddress)
	t.MustNil(err, "error converting string cosmos address to sdk struct")

	toAddress := inttestSDK.GetAccountAddr(key, t)
	toSdkAddr, err := sdk.AccAddressFromBech32(toAddress)
	t.MustNil(err, "error converting string cosmos address to sdk struct")

	sendCoinsMsg := bank.NewMsgSend(fromSdkAddr, toSdkAddr, amount)
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
func MockCookbook(senderName string, createNew bool, t *testing.T) (string, error) {
	guid, exist, err := CheckCookbookExist(senderName, t)
	if err != nil {
		return "", err
	}

	if exist && !createNew { // finish mock if already available
		return guid, nil
	}
	senderAddr := inttestSDK.GetAccountAddr(senderName, t)
	sdkAddr, err := sdk.AccAddressFromBech32(senderAddr)
	t.MustNil(err, fmt.Sprintf("error converting %s to AccAddress struct", senderName))

	txhash, err := inttestSDK.TestTxWithMsgWithNonce(t, msgs.NewMsgCreateCookbook(
		"COOKBOOK_MOCK_001_"+senderName,
		"",
		"this has to meet character limits lol",
		"SketchyCo",
		"1.0.0",
		"example@example.com",
		0,
		msgs.DefaultCostPerBlock,
		sdkAddr),
		senderName,
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
func CheckCookbookExist(senderName string, t *testing.T) (string, bool, error) {
	senderAddr := inttestSDK.GetAccountAddr(senderName, t)
	senderSdkAddr, err := sdk.AccAddressFromBech32(senderAddr)

	if err != nil {
		return "", false, err
	}

	cbList, err := inttestSDK.ListCookbookViaCLI(senderSdkAddr.String())
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
	guid, err := MockCookbook(senderName, createNew, t)
	t.MustNil(err, "error mocking cookbook")

	cb, err := inttestSDK.GetCookbookByGUID(guid)
	t.MustNil(err, "error mocking cookbook")
	return cb
}

// MockNoDelayItemGenRecipeGUID mock no delay item generation recipe
func MockNoDelayItemGenRecipeGUID(cbOwnerKey, name string, outputItemName string, t *testing.T) (string, error) {
	return MockRecipeGUID(cbOwnerKey, 0, false, name, "", outputItemName, t)
}

// MockRecipeGUID mock recipe and returns GUID
func MockRecipeGUID(
	cbOwnerKey string,
	interval int64,
	isUpgrdRecipe bool,
	name, curItemName, desItemName string,
	t *testing.T) (string, error) {
	if !isUpgrdRecipe {
		return MockDetailedRecipeGUID(
			cbOwnerKey,
			name,
			types.GenCoinInputList("pylon", 5),
			types.ItemInputList{},
			types.GenItemOnlyEntry(desItemName),
			types.GenOneOutput(1),
			interval,
			t,
		)
	}
	return MockDetailedRecipeGUID(
		cbOwnerKey,
		name,
		types.GenCoinInputList("pylon", 5),
		types.GenItemInputList(curItemName),
		types.GenEntriesFirstItemNameUpgrade(desItemName),
		types.GenOneOutput(1),
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
) (string, error) {
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
) (string, error) {
	mCB := GetMockedCookbook(cbOwnerKey, false, t)

	eugenAddr := inttestSDK.GetAccountAddr(cbOwnerKey, t)
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
		cbOwnerKey,
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
func MockItemGUIDWithFee(cbID, sender, name string, transferFee int64, t *testing.T) string {

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
		transferFee,
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
	tradeCreatorKey string,
	cbID string,
	inputCoinList types.CoinInputList,
	hasInputItem bool, inputItemName string,
	hasOutputCoin bool, outputCoinName string, outputCoinAmount int64,
	hasOutputItem bool, outputItemID string,
	extraInfo string,
	t *testing.T,
) string {
	eugenAddr := inttestSDK.GetAccountAddr(tradeCreatorKey, t)
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
		tradeCreatorKey,
		false,
	)
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
