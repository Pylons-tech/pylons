package fixturetest

import (
	"encoding/json"

	testing "github.com/Pylons-tech/pylons_sdk/cmd/evtesting"
	fixturetestSDK "github.com/Pylons-tech/pylons_sdk/cmd/fixture_utils"

	testutils "github.com/Pylons-tech/pylons/test/test_utils"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"

	"github.com/Pylons-tech/pylons/x/pylons/handlers"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// TxBroadcastErrorCheck check error is same as expected when it exist
func TxBroadcastErrorCheck(err error, step fixturetestSDK.FixtureStep, t *testing.T) {
	if step.Output.TxResult.BroadcastError != "" {
		t.MustContain(err.Error(), step.Output.TxResult.BroadcastError, "broadcast error is different from expected one")
	} else {
		t.MustNil(err, "unexpected transaction broadcast error")
	}
}

// TxErrorLogCheck check expected error log is produced correctly
func TxErrorLogCheck(err error, ErrorLog string, t *testing.T) {
	if len(ErrorLog) > 0 {
		t.MustTrue(err != nil, "result is nil unexpectedly")
		t.MustContain(err.Error(), ErrorLog, "transaction error log is different from expected one.")
	}
}

// TxResultStatusMessageCheck check result status and message
func TxResultStatusMessageCheck(status, message string, step fixturetestSDK.FixtureStep, t *testing.T) {
	if len(step.Output.TxResult.Status) > 0 {
		t.WithFields(testing.Fields{
			"original_status": status,
			"target_status":   step.Output.TxResult.Status,
		}).MustTrue(status == step.Output.TxResult.Status, "transaction result status is different from expected")
	}
	if len(step.Output.TxResult.Message) > 0 {
		t.WithFields(testing.Fields{
			"original_message": message,
			"target_message":   step.Output.TxResult.Message,
		}).MustTrue(message == step.Output.TxResult.Message, "transaction result message is different from expected")
	}
}

// TxResultDecodingErrorCheck check error for tx response data unmarshal
func TxResultDecodingErrorCheck(err error, t *testing.T) {
	t.WithFields(testing.Fields{}).MustNil(err, "error unmarshaling tx response")
}

// WaitForNextBlockWithErrorCheck wait 1 block and check the error result
func WaitForNextBlockWithErrorCheck(t *testing.T) {
	testutils.WaitForNextBlock()
}

// RunCreateAccount is a function to create account
func RunCreateAccount(step fixturetestSDK.FixtureStep, t *testing.T) {

	if step.ParamsRef != "" {
		caKey := GetAccountKeyFromTempName(step.ParamsRef, t)
		address, err := testutils.AddNewLocalKey(caKey)
		t.WithFields(testing.Fields{
			"key":              caKey,
			"local_key_result": address,
		}).MustNil(err, "error creating local Key")
		err = testutils.CreateChainAccount(caKey)
		t.MustNil(err, "error creating account on chain")
	}
}

// GetPylonsMsgFromRef is a function to get GetPylons message from reference
func GetPylonsMsgFromRef(ref string, t *testing.T) msgs.MsgGetPylons {
	gpAddr := GetAccountAddressFromTempName(ref, t)
	return msgs.NewMsgGetPylons(
		types.NewPylon(55000),
		gpAddr,
	)
}

// SendCoinsMsgFromRef is a function to SendCoins message from reference
func SendCoinsMsgFromRef(ref string, t *testing.T) msgs.MsgSendCoins {
	byteValue := ReadFile(ref, t)
	// translate sender from account name to account address
	newByteValue := UpdateSenderKeyToAddress(byteValue, t)
	newByteValue = UpdateReceiverKeyToAddress(newByteValue, t)

	var siType struct {
		Sender   sdk.AccAddress
		Receiver sdk.AccAddress
		Amount   sdk.Coins
	}

	err := testutils.GetAminoCdc().UnmarshalJSON(newByteValue, &siType)
	t.WithFields(testing.Fields{
		"siType":    testutils.AminoCodecFormatter(siType),
		"new_bytes": string(newByteValue),
	}).MustNil(err, "error reading using GetAminoCdc")

	return msgs.NewMsgSendCoins(siType.Amount, siType.Sender, siType.Receiver)
}

// RunGetPylons is a function to run GetPylos message
func RunGetPylons(step fixturetestSDK.FixtureStep, t *testing.T) {

	if step.ParamsRef != "" {
		gpMsg := GetPylonsMsgFromRef(step.ParamsRef, t)
		err := gpMsg.ValidateBasic()
		if err != nil {
			TxBroadcastErrorCheck(err, step, t)
			return
		}
		WaitForNextBlockWithErrorCheck(t)
		tci := testutils.GetTestCoinInput()
		result, err := handlers.HandlerMsgGetPylons(tci.Ctx, tci.PlnK, gpMsg)
		t.MustTrue(err == nil, "error should be empty")
		t.MustTrue(result != nil, "result should not be empty")
		resp := handlers.GetPylonsResponse{}
		err = testutils.GetAminoCdc().UnmarshalJSON(result.Data, &resp) // nolint:staticcheck
		TxResultDecodingErrorCheck(err, t)
		TxResultStatusMessageCheck(resp.Status, resp.Message, step, t)
	}
}

// RunSendCoins is a function to send coins from one address to another
func RunSendCoins(step fixturetestSDK.FixtureStep, t *testing.T) {

	if step.ParamsRef != "" {
		scMsg := SendCoinsMsgFromRef(step.ParamsRef, t)
		err := scMsg.ValidateBasic()
		if err != nil {
			TxBroadcastErrorCheck(err, step, t)
			return
		}

		WaitForNextBlockWithErrorCheck(t)
		tci := testutils.GetTestCoinInput()
		result, err := handlers.HandlerMsgSendCoins(tci.Ctx, tci.PlnK, scMsg)

		TxErrorLogCheck(err, step.Output.TxResult.ErrorLog, t)
		if len(step.Output.TxResult.ErrorLog) > 0 {
			return
		}

		t.MustTrue(result != nil, "result should not be empty")
		resp := handlers.GetPylonsResponse{}
		err = testutils.GetAminoCdc().UnmarshalJSON(result.Data, &resp) // nolint:staticcheck
		TxResultDecodingErrorCheck(err, t)
		TxResultStatusMessageCheck(resp.Status, resp.Message, step, t)
	}
}

// RunMockAccount = RunCreateAccount + RunGetPylons
func RunMockAccount(step fixturetestSDK.FixtureStep, t *testing.T) {

	if step.ParamsRef != "" {
		RunCreateAccount(step, t)
		RunGetPylons(step, t)
	}
}

// RunMultiMsgTx is a function to send multiple messages in a transaction
// This support only 1 sender multi transaction for now
// TODO we need to support multi-message multi sender transaction
func RunMultiMsgTx(step fixturetestSDK.FixtureStep, t *testing.T) {

	tci := testutils.GetTestCoinInput()

	if len(step.MsgRefs) != 0 {
		for _, ref := range step.MsgRefs {
			switch ref.Action {
			case "fiat_item":
				msg := FiatItemMsgFromRef(ref.ParamsRef, t)
				_, err := handlers.HandlerMsgFiatItem(tci.Ctx, tci.PlnK, msg)
				t.MustNil(err)
			case "update_item_string":
				msg := UpdateItemStringMsgFromRef(ref.ParamsRef, t)
				_, err := handlers.HandlerMsgUpdateItemString(tci.Ctx, tci.PlnK, msg)
				t.MustNil(err)
			case "create_cookbook":
				msg := CreateCookbookMsgFromRef(ref.ParamsRef, t)
				_, err := handlers.HandlerMsgCreateCookbook(tci.Ctx, tci.PlnK, msg)
				t.MustNil(err)
			case "create_recipe":
				msg := CreateRecipeMsgFromRef(ref.ParamsRef, t)
				_, err := handlers.HandlerMsgCreateRecipe(tci.Ctx, tci.PlnK, msg)
				t.MustNil(err)
			case "execute_recipe":
				msg := ExecuteRecipeMsgFromRef(ref.ParamsRef, t)
				_, err := handlers.HandlerMsgExecuteRecipe(tci.Ctx, tci.PlnK, msg)
				t.MustNil(err)
			case "check_execution":
				msg := CheckExecutionMsgFromRef(ref.ParamsRef, t)
				_, err := handlers.HandlerMsgCheckExecution(tci.Ctx, tci.PlnK, msg)
				t.MustNil(err)
			case "create_trade":
				msg := CreateTradeMsgFromRef(ref.ParamsRef, t)
				_, err := handlers.HandlerMsgCreateTrade(tci.Ctx, tci.PlnK, msg)
				t.MustNil(err)
			case "fulfill_trade":
				msg := FulfillTradeMsgFromRef(ref.ParamsRef, t)
				_, err := handlers.HandlerMsgFulfillTrade(tci.Ctx, tci.PlnK, msg)
				t.MustNil(err)
			case "disable_trade":
				msg := DisableTradeMsgFromRef(ref.ParamsRef, t)
				_, err := handlers.HandlerMsgDisableTrade(tci.Ctx, tci.PlnK, msg)
				t.MustNil(err)
			}
		}
	}
}

// CheckExecutionMsgFromRef collect check execution message from reference string
func CheckExecutionMsgFromRef(ref string, t *testing.T) msgs.MsgCheckExecution {
	byteValue := ReadFile(ref, t)
	// translate sender from account name to account address
	newByteValue := UpdateSenderKeyToAddress(byteValue, t)
	// translate execRef to execID
	newByteValue = UpdateExecID(newByteValue, t)

	var execType struct {
		ExecID        string
		PayToComplete bool
		Sender        sdk.AccAddress
	}
	err := testutils.GetAminoCdc().UnmarshalJSON(newByteValue, &execType)
	t.WithFields(testing.Fields{
		"execType": testutils.AminoCodecFormatter(execType),
	}).MustNil(err, "error reading using GetAminoCdc")

	return msgs.NewMsgCheckExecution(
		execType.ExecID,
		execType.PayToComplete,
		execType.Sender,
	)
}

// RunCheckExecution is a function to execute check execution
func RunCheckExecution(step fixturetestSDK.FixtureStep, t *testing.T) {

	if step.ParamsRef != "" {
		chkExecMsg := CheckExecutionMsgFromRef(step.ParamsRef, t)
		err := chkExecMsg.ValidateBasic()
		if err != nil {
			TxBroadcastErrorCheck(err, step, t)
			return
		}

		WaitForNextBlockWithErrorCheck(t)
		tci := testutils.GetTestCoinInput()
		result, err := handlers.HandlerMsgCheckExecution(tci.Ctx, tci.PlnK, chkExecMsg)

		TxErrorLogCheck(err, step.Output.TxResult.ErrorLog, t)
		if len(step.Output.TxResult.ErrorLog) > 0 {
			return
		}

		t.MustTrue(result != nil, "result should not be empty")
		resp := handlers.CheckExecutionResponse{}
		err = testutils.GetAminoCdc().UnmarshalJSON(result.Data, &resp) // nolint:staticcheck
		TxResultDecodingErrorCheck(err, t)
		TxResultStatusMessageCheck(resp.Status, resp.Message, step, t)
	}
}

// FiatItemMsgFromRef collect check execution message from reference string
func FiatItemMsgFromRef(ref string, t *testing.T) msgs.MsgFiatItem {
	byteValue := ReadFile(ref, t)
	// translate sender from account name to account address
	newByteValue := UpdateSenderKeyToAddress(byteValue, t)
	// translate cookbook name to cookbook ID
	newByteValue = UpdateCBNameToID(newByteValue, t)

	var itemType types.Item
	err := testutils.GetAminoCdc().UnmarshalJSON(newByteValue, &itemType)
	t.WithFields(testing.Fields{
		"itemType": testutils.AminoCodecFormatter(itemType),
	}).MustNil(err, "error reading using GetAminoCdc")

	return msgs.NewMsgFiatItem(
		itemType.CookbookID,
		itemType.Doubles,
		itemType.Longs,
		itemType.Strings,
		itemType.Sender,
		itemType.TransferFee,
	)
}

// RunFiatItem is a function to execute fiat item
func RunFiatItem(step fixturetestSDK.FixtureStep, t *testing.T) {

	if step.ParamsRef != "" {
		itmMsg := FiatItemMsgFromRef(step.ParamsRef, t)
		err := itmMsg.ValidateBasic()
		if err != nil {
			TxBroadcastErrorCheck(err, step, t)
			return
		}

		WaitForNextBlockWithErrorCheck(t)
		tci := testutils.GetTestCoinInput()
		result, err := handlers.HandlerMsgFiatItem(tci.Ctx, tci.PlnK, itmMsg)

		TxErrorLogCheck(err, step.Output.TxResult.ErrorLog, t)
		if len(step.Output.TxResult.ErrorLog) > 0 {
			return
		}

		t.MustTrue(result != nil, "result should not be empty")
		resp := handlers.FiatItemResponse{}
		err = testutils.GetAminoCdc().UnmarshalJSON(result.Data, &resp) // nolint:staticcheck
		TxResultDecodingErrorCheck(err, t)
		t.MustTrue(resp.ItemID != "", "item id shouldn't be empty")
	}
}

// SendItemsMsgFromRef is a function to collect SendItems from reference string
func SendItemsMsgFromRef(ref string, t *testing.T) msgs.MsgSendItems {
	byteValue := ReadFile(ref, t)
	// translate sender from account name to account address
	newByteValue := UpdateSenderKeyToAddress(byteValue, t)
	newByteValue = UpdateReceiverKeyToAddress(newByteValue, t)

	var siType struct {
		Sender   sdk.AccAddress
		Receiver sdk.AccAddress
		ItemIDs  []string `json:"ItemIDs"`
	}

	err := testutils.GetAminoCdc().UnmarshalJSON(newByteValue, &siType)
	t.WithFields(testing.Fields{
		"siType":    testutils.AminoCodecFormatter(siType),
		"new_bytes": string(newByteValue),
	}).MustNil(err, "error reading using GetAminoCdc")

	// translate itemNames to itemIDs
	ItemIDs := GetItemIDsFromNames(newByteValue, siType.Sender, false, false, t)

	return msgs.NewMsgSendItems(ItemIDs, siType.Sender, siType.Receiver)
}

// RunSendItems is a function to send items to another user
func RunSendItems(step fixturetestSDK.FixtureStep, t *testing.T) {

	if step.ParamsRef != "" {
		siMsg := SendItemsMsgFromRef(step.ParamsRef, t)
		err := siMsg.ValidateBasic()
		if err != nil {
			TxBroadcastErrorCheck(err, step, t)
			return
		}

		WaitForNextBlockWithErrorCheck(t)
		tci := testutils.GetTestCoinInput()
		result, err := handlers.HandlerMsgSendItems(tci.Ctx, tci.PlnK, siMsg)

		TxErrorLogCheck(err, step.Output.TxResult.ErrorLog, t)
		if len(step.Output.TxResult.ErrorLog) > 0 {
			return
		}

		t.MustTrue(result != nil, "result should not be empty")
		resp := handlers.SendItemsResponse{}
		err = testutils.GetAminoCdc().UnmarshalJSON(result.Data, &resp) // nolint:staticcheck
		TxResultDecodingErrorCheck(err, t)
		TxResultStatusMessageCheck(resp.Status, resp.Message, step, t)
	}
}

// UpdateItemStringMsgFromRef is a function to collect UpdateItemStringMsg from reference string
func UpdateItemStringMsgFromRef(ref string, t *testing.T) msgs.MsgUpdateItemString {
	byteValue := ReadFile(ref, t)
	// translate sender from account name to account address
	newByteValue := UpdateSenderKeyToAddress(byteValue, t)
	// translate item name to item ID
	newByteValue = UpdateItemIDFromName(newByteValue, false, false, t)

	var sTypeMsg msgs.MsgUpdateItemString
	err := json.Unmarshal(newByteValue, &sTypeMsg)
	t.WithFields(testing.Fields{
		"sTypeMsg":  testutils.AminoCodecFormatter(sTypeMsg),
		"new_bytes": string(newByteValue),
	}).MustNil(err, "error reading using GetAminoCdc")
	return sTypeMsg
}

// RunUpdateItemString is a function to update item's string value
func RunUpdateItemString(step fixturetestSDK.FixtureStep, t *testing.T) {

	if step.ParamsRef != "" {
		sTypeMsg := UpdateItemStringMsgFromRef(step.ParamsRef, t)
		err := sTypeMsg.ValidateBasic()
		if err != nil {
			TxBroadcastErrorCheck(err, step, t)
			return
		}
		WaitForNextBlockWithErrorCheck(t)
		tci := testutils.GetTestCoinInput()
		result, err := handlers.HandlerMsgUpdateItemString(tci.Ctx, tci.PlnK, sTypeMsg)

		TxErrorLogCheck(err, step.Output.TxResult.ErrorLog, t)
		if len(step.Output.TxResult.ErrorLog) > 0 {
			return
		}

		t.MustTrue(result != nil, "result should not be empty")
		resp := handlers.UpdateItemStringResponse{}
		err = testutils.GetAminoCdc().UnmarshalJSON(result.Data, &resp) // nolint:staticcheck
		TxResultDecodingErrorCheck(err, t)
	}
}

// CreateCookbookMsgFromRef is a function to get create cookbook message from reference
func CreateCookbookMsgFromRef(ref string, t *testing.T) msgs.MsgCreateCookbook {
	byteValue := ReadFile(ref, t)
	// translate sender from account name to account address
	newByteValue := UpdateSenderKeyToAddress(byteValue, t)

	var cbType types.Cookbook
	err := testutils.GetAminoCdc().UnmarshalJSON(newByteValue, &cbType)
	t.WithFields(testing.Fields{
		"cbType":    testutils.AminoCodecFormatter(cbType),
		"new_bytes": string(newByteValue),
	}).MustNil(err, "error reading using GetAminoCdc")

	return msgs.NewMsgCreateCookbook(
		cbType.Name,
		cbType.ID,
		cbType.Description,
		cbType.Developer,
		cbType.Version,
		cbType.SupportEmail,
		cbType.Level,
		cbType.CostPerBlock,
		cbType.Sender,
	)
}

// RunCreateCookbook is a function to create cookbook
func RunCreateCookbook(step fixturetestSDK.FixtureStep, t *testing.T) {

	if step.ParamsRef != "" {
		cbMsg := CreateCookbookMsgFromRef(step.ParamsRef, t)
		err := cbMsg.ValidateBasic()
		if err != nil {
			TxBroadcastErrorCheck(err, step, t)
			return
		}

		WaitForNextBlockWithErrorCheck(t)
		tci := testutils.GetTestCoinInput()
		result, err := handlers.HandlerMsgCreateCookbook(tci.Ctx, tci.PlnK, cbMsg)

		TxErrorLogCheck(err, step.Output.TxResult.ErrorLog, t)
		if len(step.Output.TxResult.ErrorLog) > 0 {
			return
		}

		t.MustTrue(result != nil, "result should not be empty")
		resp := handlers.CreateCookbookResponse{}
		err = testutils.GetAminoCdc().UnmarshalJSON(result.Data, &resp) // nolint:staticcheck
		TxResultDecodingErrorCheck(err, t)
		t.MustTrue(resp.CookbookID != "", "coookbook id shouldn't be empty")
	}
}

// RunMockCookbook = RunMockAccount + RunCreateCookbook
func RunMockCookbook(step fixturetestSDK.FixtureStep, t *testing.T) {
	if step.ParamsRef != "" {
		sender := GetSenderKeyFromRef(step.ParamsRef, t)
		RunMockAccount(fixturetestSDK.FixtureStep{ParamsRef: sender}, t)
		RunCreateCookbook(step, t)
	}
}

// CreateRecipeMsgFromRef is a function to get create cookbook message from reference
func CreateRecipeMsgFromRef(ref string, t *testing.T) msgs.MsgCreateRecipe {
	byteValue := ReadFile(ref, t)
	// translate sender from account name to account address
	newByteValue := UpdateSenderKeyToAddress(byteValue, t)
	// translate cookbook name to cookbook id
	newByteValue = UpdateCBNameToID(newByteValue, t)
	// get item inputs from fileNames
	itemInputs := GetItemInputsFromBytes(newByteValue, t)
	// get entries from fileNames
	entries := GetEntriesFromBytes(newByteValue, t)

	var rcpTempl types.Recipe
	err := testutils.GetAminoCdc().UnmarshalJSON(newByteValue, &rcpTempl)
	t.WithFields(testing.Fields{
		"rcpTempl":  testutils.AminoCodecFormatter(rcpTempl),
		"new_bytes": string(newByteValue),
	}).MustNil(err, "error reading using GetAminoCdc")

	return msgs.NewMsgCreateRecipe(
		rcpTempl.Name,
		rcpTempl.CookbookID,
		rcpTempl.ID,
		rcpTempl.Description,
		rcpTempl.CoinInputs,
		itemInputs,
		entries,
		rcpTempl.Outputs,
		rcpTempl.BlockInterval,
		rcpTempl.Sender,
	)
}

// RunCreateRecipe is a function to create recipe
func RunCreateRecipe(step fixturetestSDK.FixtureStep, t *testing.T) {

	if step.ParamsRef != "" {
		rcpMsg := CreateRecipeMsgFromRef(step.ParamsRef, t)
		err := rcpMsg.ValidateBasic()
		if err != nil {
			TxBroadcastErrorCheck(err, step, t)
			return
		}

		WaitForNextBlockWithErrorCheck(t)
		tci := testutils.GetTestCoinInput()
		result, err := handlers.HandlerMsgCreateRecipe(tci.Ctx, tci.PlnK, rcpMsg)

		TxErrorLogCheck(err, step.Output.TxResult.ErrorLog, t)
		if len(step.Output.TxResult.ErrorLog) > 0 {
			return
		}

		t.MustTrue(result != nil, "result should not be empty")
		resp := handlers.CreateRecipeResponse{}
		err = testutils.GetAminoCdc().UnmarshalJSON(result.Data, &resp) // nolint:staticcheck
		TxResultDecodingErrorCheck(err, t)
		t.MustTrue(resp.RecipeID != "", "recipe id shouldn't be empty")
	}
}

// ExecuteRecipeMsgFromRef collect execute recipe msg from reference string
func ExecuteRecipeMsgFromRef(ref string, t *testing.T) msgs.MsgExecuteRecipe {
	byteValue := ReadFile(ref, t)
	// translate sender from account name to account address
	newByteValue := UpdateSenderKeyToAddress(byteValue, t)
	// translate recipe name to recipe id
	newByteValue = UpdateRecipeName(newByteValue, t)

	var execType struct {
		RecipeID string
		Sender   sdk.AccAddress
		ItemIDs  []string `json:"ItemIDs"`
	}

	err := testutils.GetAminoCdc().UnmarshalJSON(newByteValue, &execType)
	t.WithFields(testing.Fields{
		"execType":  testutils.AminoCodecFormatter(execType),
		"new_bytes": string(newByteValue),
	}).MustNil(err, "error reading using GetAminoCdc")
	// translate itemNames to itemIDs
	ItemIDs := GetItemIDsFromNames(newByteValue, execType.Sender, false, false, t)

	return msgs.NewMsgExecuteRecipe(execType.RecipeID, execType.Sender, ItemIDs)
}

// RunExecuteRecipe is executed when an action "execute_recipe" is called
func RunExecuteRecipe(step fixturetestSDK.FixtureStep, t *testing.T) {
	// TODO should check item ID is returned
	// TODO when items are generated, rather than returning whole should return only ID [if multiple, array of item IDs]

	if step.ParamsRef != "" {
		execMsg := ExecuteRecipeMsgFromRef(step.ParamsRef, t)
		err := execMsg.ValidateBasic()
		if err != nil {
			TxBroadcastErrorCheck(err, step, t)
			return
		}

		WaitForNextBlockWithErrorCheck(t)
		tci := testutils.GetTestCoinInput()
		result, err := handlers.HandlerMsgExecuteRecipe(tci.Ctx, tci.PlnK, execMsg)

		TxErrorLogCheck(err, step.Output.TxResult.ErrorLog, t)
		if len(step.Output.TxResult.ErrorLog) > 0 {
			return
		}

		t.MustTrue(result != nil, "result should not be empty")
		resp := handlers.ExecuteRecipeResponse{}
		err = testutils.GetAminoCdc().UnmarshalJSON(result.Data, &resp) // nolint:staticcheck
		TxResultDecodingErrorCheck(err, t)
		TxResultStatusMessageCheck(resp.Status, resp.Message, step, t)

		if resp.Message == "scheduled the recipe" { // delayed execution
			var scheduleRes handlers.ExecuteRecipeScheduleOutput

			err := json.Unmarshal(resp.Output, &scheduleRes)
			t.WithFields(testing.Fields{
				"response_output": string(resp.Output),
			}).MustNil(err, "error decoding raw json")
			execIDRWMutex.Lock()
			execIDs[step.ID] = scheduleRes.ExecID
			execIDRWMutex.Unlock()
			for _, itemID := range execMsg.ItemIDs {
				item, err := testutils.GetItemByGUID(itemID)
				t.WithFields(testing.Fields{
					"item_id": itemID,
				}).MustNil(err, "error getting item from id")
				t.MustTrue(len(item.OwnerRecipeID) != 0, "OwnerRecipeID shouldn't be set but it's set")
			}

			t.WithFields(testing.Fields{
				"exec_id": scheduleRes.ExecID,
			}).Debug("scheduled execution")
		} else { // straight execution
			t.WithFields(testing.Fields{
				"output": string(resp.Output),
			}).Debug("straight execution result")
		}
	}
}

// CreateTradeMsgFromRef collect create trade msg from reference
func CreateTradeMsgFromRef(ref string, t *testing.T) msgs.MsgCreateTrade {
	byteValue := ReadFile(ref, t)
	// translate sender from account name to account address
	newByteValue := UpdateSenderKeyToAddress(byteValue, t)
	// get item inputs from fileNames
	tradeItemInputs := GetTradeItemInputsFromBytes(newByteValue, t)
	var trdType types.Trade
	err := testutils.GetAminoCdc().UnmarshalJSON(newByteValue, &trdType)
	t.WithFields(testing.Fields{
		"trdType":   testutils.AminoCodecFormatter(trdType),
		"new_bytes": string(newByteValue),
	}).MustNil(err, "error reading using GetAminoCdc")

	// get ItemOutputs from ItemOutputNames
	itemOutputs := GetItemOutputsFromBytes(newByteValue, trdType.Sender, t)

	return msgs.NewMsgCreateTrade(
		trdType.CoinInputs,
		tradeItemInputs,
		trdType.CoinOutputs,
		itemOutputs,
		trdType.ExtraInfo,
		trdType.Sender,
	)
}

// RunCreateTrade is a function to create trade
func RunCreateTrade(step fixturetestSDK.FixtureStep, t *testing.T) {

	if step.ParamsRef != "" {
		createTrd := CreateTradeMsgFromRef(step.ParamsRef, t)
		t.WithFields(testing.Fields{
			"tx_msgs": testutils.AminoCodecFormatter(createTrd),
		}).AddFields(testutils.GetLogFieldsFromMsgs([]sdk.Msg{createTrd})).Debug("createTrd")
		err := createTrd.ValidateBasic()
		if err != nil {
			TxBroadcastErrorCheck(err, step, t)
			return
		}

		WaitForNextBlockWithErrorCheck(t)
		tci := testutils.GetTestCoinInput()
		result, err := handlers.HandlerMsgCreateTrade(tci.Ctx, tci.PlnK, createTrd)

		TxErrorLogCheck(err, step.Output.TxResult.ErrorLog, t)
		if len(step.Output.TxResult.ErrorLog) > 0 {
			return
		}

		t.MustTrue(result != nil, "result should not be empty")
		resp := handlers.CreateTradeResponse{}
		err = testutils.GetAminoCdc().UnmarshalJSON(result.Data, &resp) // nolint:staticcheck
		TxResultDecodingErrorCheck(err, t)
		t.MustTrue(resp.TradeID != "", "trade id shouldn't be empty")
	}
}

// FulfillTradeMsgFromRef collect fulfill trade message from reference string
func FulfillTradeMsgFromRef(ref string, t *testing.T) msgs.MsgFulfillTrade {
	byteValue := ReadFile(ref, t)
	// translate sender from account name to account address
	newByteValue := UpdateSenderKeyToAddress(byteValue, t)
	// translate extra info to trade id
	newByteValue = UpdateTradeExtraInfoToID(newByteValue, t)

	var trdType struct {
		TradeID string
		Sender  sdk.AccAddress
		ItemIDs []string `json:"ItemIDs"`
	}

	err := testutils.GetAminoCdc().UnmarshalJSON(newByteValue, &trdType)
	t.WithFields(testing.Fields{
		"trdType":   testutils.AminoCodecFormatter(trdType),
		"new_bytes": string(newByteValue),
	}).MustNil(err, "error reading using GetAminoCdc")
	// translate itemNames to itemIDs
	ItemIDs := GetItemIDsFromNames(newByteValue, trdType.Sender, false, false, t)

	return msgs.NewMsgFulfillTrade(trdType.TradeID, trdType.Sender, ItemIDs)
}

// RunFulfillTrade is a function to fulfill trade
func RunFulfillTrade(step fixturetestSDK.FixtureStep, t *testing.T) {

	if step.ParamsRef != "" {
		ffTrdMsg := FulfillTradeMsgFromRef(step.ParamsRef, t)
		err := ffTrdMsg.ValidateBasic()
		if err != nil {
			TxBroadcastErrorCheck(err, step, t)
			return
		}

		WaitForNextBlockWithErrorCheck(t)
		tci := testutils.GetTestCoinInput()
		result, err := handlers.HandlerMsgFulfillTrade(tci.Ctx, tci.PlnK, ffTrdMsg)

		TxErrorLogCheck(err, step.Output.TxResult.ErrorLog, t)
		if len(step.Output.TxResult.ErrorLog) > 0 {
			return
		}

		t.MustTrue(result != nil, "result should not be empty")
		resp := handlers.FulfillTradeResponse{}
		err = testutils.GetAminoCdc().UnmarshalJSON(result.Data, &resp) // nolint:staticcheck
		TxResultDecodingErrorCheck(err, t)
		TxResultStatusMessageCheck(resp.Status, resp.Message, step, t)
	}
}

// DisableTradeMsgFromRef collect disable trade msg from reference string
func DisableTradeMsgFromRef(ref string, t *testing.T) msgs.MsgDisableTrade {
	byteValue := ReadFile(ref, t)
	// translate sender from account name to account address
	newByteValue := UpdateSenderKeyToAddress(byteValue, t)
	// translate extra info to trade id
	newByteValue = UpdateTradeExtraInfoToID(newByteValue, t)

	var trdType struct {
		TradeID string
		Sender  sdk.AccAddress
	}

	err := testutils.GetAminoCdc().UnmarshalJSON(newByteValue, &trdType)
	t.WithFields(testing.Fields{
		"trdType":   testutils.AminoCodecFormatter(trdType),
		"new_bytes": string(newByteValue),
	}).MustNil(err, "error reading using GetAminoCdc")

	return msgs.NewMsgDisableTrade(trdType.TradeID, trdType.Sender)
}

// RunDisableTrade is a function to disable trade
func RunDisableTrade(step fixturetestSDK.FixtureStep, t *testing.T) {

	if step.ParamsRef != "" {
		dsTrdMsg := DisableTradeMsgFromRef(step.ParamsRef, t)
		err := dsTrdMsg.ValidateBasic()
		if err != nil {
			TxBroadcastErrorCheck(err, step, t)
			return
		}

		WaitForNextBlockWithErrorCheck(t)
		tci := testutils.GetTestCoinInput()
		result, err := handlers.HandlerMsgDisableTrade(tci.Ctx, tci.PlnK, dsTrdMsg)

		TxErrorLogCheck(err, step.Output.TxResult.ErrorLog, t)
		if len(step.Output.TxResult.ErrorLog) > 0 {
			return
		}

		t.MustTrue(result != nil, "result should not be empty")
		resp := handlers.DisableTradeResponse{}
		err = testutils.GetAminoCdc().UnmarshalJSON(result.Data, &resp) // nolint:staticcheck
		TxResultDecodingErrorCheck(err, t)
		TxResultStatusMessageCheck(resp.Status, resp.Message, step, t)
	}
}
