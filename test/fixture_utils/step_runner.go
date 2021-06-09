package fixturetest

import (
	"encoding/base64"
	"encoding/json"

	testutils "github.com/Pylons-tech/pylons/test/test_utils"
	"github.com/Pylons-tech/pylons/x/pylons/handlers"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	testing "github.com/Pylons-tech/pylons_sdk/cmd/evtesting"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// TxBroadcastErrorCheck check error is same as expected when it exist
func TxBroadcastErrorCheck(err error, step FixtureStep, t *testing.T) {
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
func TxResultStatusMessageCheck(status, message string, step FixtureStep, t *testing.T) {
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
func RunCreateAccount(step FixtureStep, t *testing.T) {

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
func GetPylonsMsgFromRef(ref string, t *testing.T) types.MsgGetPylons {
	gpAddr := GetAccountAddressFromTempName(ref, t)
	return types.NewMsgGetPylons(
		types.NewPylon(55000),
		gpAddr.String(),
	)
}

// SendCoinsMsgFromRef is a function to SendCoins message from reference
func SendCoinsMsgFromRef(ref string, t *testing.T) types.MsgSendCoins {
	byteValue := ReadFile(ref, t)
	// translate sender from account name to account address
	newByteValue := UpdateSenderKeyToAddress(byteValue, t)
	newByteValue = UpdateReceiverKeyToAddress(newByteValue, t)

	var siType struct {
		Sender   string
		Receiver string
		Amount   string
	}

	err := json.Unmarshal(newByteValue, &siType)
	t.WithFields(testing.Fields{
		"siType":    testutils.AminoCodecFormatter(siType),
		"new_bytes": string(newByteValue),
	}).MustNil(err, "error reading using json Unmarshaler")

	amount, err := sdk.ParseCoinsNormalized(siType.Amount)
	t.WithFields(testing.Fields{
		"amount": siType.Amount,
	}).MustNil(err, "error parsing amount")

	return types.NewMsgSendCoins(amount, siType.Sender, siType.Receiver)
}

// RunGetPylons is a function to run GetPylos message
func RunGetPylons(step FixtureStep, t *testing.T) {

	if step.ParamsRef != "" {
		gpMsg := GetPylonsMsgFromRef(step.ParamsRef, t)
		err := gpMsg.ValidateBasic()
		if err != nil {
			TxBroadcastErrorCheck(err, step, t)
			return
		}
		WaitForNextBlockWithErrorCheck(t)
		tci := testutils.GetTestCoinInput()
		tci.PlnH = handlers.NewMsgServerImpl(tci.PlnK)
		result, err := tci.PlnH.GetPylons(sdk.WrapSDKContext(tci.Ctx), &gpMsg)
		t.MustTrue(err == nil, "error should be empty")
		t.MustTrue(result != nil, "result should not be empty")
		TxResultStatusMessageCheck(result.Status, result.Message, step, t)
	}
}

// GoogleIAPGetPylonsMsgFromRef is a function to get GoogleIAPGetPylons message from reference
func GoogleIAPGetPylonsMsgFromRef(ref string, t *testing.T) types.MsgGoogleIAPGetPylons {
	byteValue := ReadFile(ref, t)
	// translate requester from account name to account address
	newByteValue := UpdateRequesterKeyToAddress(byteValue, t)

	var gigpType struct {
		ProductID     string
		PurchaseToken string
		ReceiptData   string
		Signature     string
		Requester     string
	}

	err := json.Unmarshal(newByteValue, &gigpType)
	t.WithFields(testing.Fields{
		"gigpType":  testutils.AminoCodecFormatter(gigpType),
		"new_bytes": string(newByteValue),
	}).MustNil(err, "error reading using GetJSONMarshaler")

	receiptDataBase64 := base64.StdEncoding.EncodeToString([]byte(gigpType.ReceiptData))

	return types.NewMsgGoogleIAPGetPylons(
		gigpType.ProductID,
		gigpType.PurchaseToken,
		receiptDataBase64,
		gigpType.Signature,
		gigpType.Requester,
	)
}

// RunGoogleIAPGetPylons is a function to run GoogleIAPGetPylons message
func RunGoogleIAPGetPylons(step FixtureStep, t *testing.T) {
	if step.ParamsRef != "" {
		gigpMsg := GoogleIAPGetPylonsMsgFromRef(step.ParamsRef, t)
		err := gigpMsg.ValidateBasic()
		if err != nil {
			TxBroadcastErrorCheck(err, step, t)
			return
		}

		WaitForNextBlockWithErrorCheck(t)
		tci := testutils.GetTestCoinInput()
		tci.PlnH = handlers.NewMsgServerImpl(tci.PlnK)
		result, err := tci.PlnH.GoogleIAPGetPylons(sdk.WrapSDKContext(tci.Ctx), &gigpMsg)
		t.MustTrue(result != nil, "result should not be empty")
		TxResultStatusMessageCheck(result.Status, result.Message, step, t)
	}
}

// RunSendCoins is a function to send coins from one address to another
func RunSendCoins(step FixtureStep, t *testing.T) {

	if step.ParamsRef != "" {
		scMsg := SendCoinsMsgFromRef(step.ParamsRef, t)
		err := scMsg.ValidateBasic()
		if err != nil {
			TxBroadcastErrorCheck(err, step, t)
			return
		}

		WaitForNextBlockWithErrorCheck(t)
		tci := testutils.GetTestCoinInput()
		tci.PlnH = handlers.NewMsgServerImpl(tci.PlnK)
		result, err := tci.PlnH.SendCoins(sdk.WrapSDKContext(tci.Ctx), &scMsg)

		TxErrorLogCheck(err, step.Output.TxResult.ErrorLog, t)
		if len(step.Output.TxResult.ErrorLog) > 0 {
			return
		}

		t.MustTrue(result != nil, "result should not be empty")
	}
}

// RunMockAccount = RunCreateAccount + RunGetPylons
func RunMockAccount(step FixtureStep, t *testing.T) {

	if step.ParamsRef != "" {
		RunCreateAccount(step, t)
		RunGetPylons(step, t)
	}
}

// RunMultiMsgTx is a function to send multiple messages in a transaction
// This support only 1 sender multi transaction for now
// TODO we need to support multi-message multi sender transaction
func RunMultiMsgTx(step FixtureStep, t *testing.T) {

	tci := testutils.GetTestCoinInput()
	tci.PlnH = handlers.NewMsgServerImpl(tci.PlnK)

	if len(step.MsgRefs) != 0 {
		for _, ref := range step.MsgRefs {
			switch ref.Action {
			case "fiat_item":
				msg := FiatItemMsgFromRef(ref.ParamsRef, t)
				_, err := tci.PlnH.FiatItem(sdk.WrapSDKContext(tci.Ctx), &msg)
				t.MustNil(err)
			case "update_item_string":
				msg := UpdateItemStringMsgFromRef(ref.ParamsRef, t)
				_, err := tci.PlnH.UpdateItemString(sdk.WrapSDKContext(tci.Ctx), &msg)
				t.MustNil(err)
			case "create_cookbook":
				msg := CreateCookbookMsgFromRef(ref.ParamsRef, t)
				_, err := tci.PlnH.CreateCookbook(sdk.WrapSDKContext(tci.Ctx), &msg)
				t.MustNil(err)
			case "update_cookbook":
				msg := UpdateCookbookMsgFromRef(ref.ParamsRef, t)
				_, err := tci.PlnH.HandlerMsgUpdateCookbook(sdk.WrapSDKContext(tci.Ctx), &msg)
				t.MustNil(err)
			case "create_recipe":
				msg := CreateRecipeMsgFromRef(ref.ParamsRef, t)
				_, err := tci.PlnH.CreateRecipe(sdk.WrapSDKContext(tci.Ctx), &msg)
				t.MustNil(err)
			case "update_recipe":
				msg := UpdateRecipeMsgFromRef(ref.ParamsRef, t)
				_, err := tci.PlnH.HandlerMsgUpdateRecipe(sdk.WrapSDKContext(tci.Ctx), &msg)
				t.MustNil(err)
			case "enable_recipe":
				msg := EnableRecipeMsgFromRef(ref.ParamsRef, t)
				_, err := tci.PlnH.EnableRecipe(sdk.WrapSDKContext(tci.Ctx), &msg)
				t.MustNil(err)
			case "disable_recipe":
				msg := DisableRecipeMsgFromRef(ref.ParamsRef, t)
				_, err := tci.PlnH.DisableRecipe(sdk.WrapSDKContext(tci.Ctx), &msg)
				t.MustNil(err)
			case "execute_recipe":
				msg := ExecuteRecipeMsgFromRef(ref.ParamsRef, t)
				_, err := tci.PlnH.ExecuteRecipe(sdk.WrapSDKContext(tci.Ctx), &msg)
				t.MustNil(err)
			case "check_execution":
				msg := CheckExecutionMsgFromRef(ref.ParamsRef, t)
				_, err := tci.PlnH.CheckExecution(sdk.WrapSDKContext(tci.Ctx), &msg)
				t.MustNil(err)
			case "create_trade":
				msg := CreateTradeMsgFromRef(ref.ParamsRef, t)
				_, err := tci.PlnH.CreateTrade(sdk.WrapSDKContext(tci.Ctx), &msg)
				t.MustNil(err)
			case "fulfill_trade":
				msg := FulfillTradeMsgFromRef(ref.ParamsRef, t)
				_, err := tci.PlnH.FulfillTrade(sdk.WrapSDKContext(tci.Ctx), &msg)
				t.MustNil(err)
			case "disable_trade":
				msg := DisableTradeMsgFromRef(ref.ParamsRef, t)
				_, err := tci.PlnH.DisableTrade(sdk.WrapSDKContext(tci.Ctx), &msg)
				t.MustNil(err)
			case "enable_trade":
				msg := EnableTradeMsgFromRef(ref.ParamsRef, t)
				_, err := tci.PlnH.EnableTrade(sdk.WrapSDKContext(tci.Ctx), &msg)
				t.MustNil(err)
			}
		}
	}
}

// CheckExecutionMsgFromRef collect check execution message from reference string
func CheckExecutionMsgFromRef(ref string, t *testing.T) types.MsgCheckExecution {
	byteValue := ReadFile(ref, t)
	// translate sender from account name to account address
	newByteValue := UpdateSenderKeyToAddress(byteValue, t)
	// translate execRef to execID
	newByteValue = UpdateExecID(newByteValue, t)

	var execType struct {
		ExecID        string
		PayToComplete bool
		Sender        string
	}
	err := json.Unmarshal(newByteValue, &execType)
	t.WithFields(testing.Fields{
		"execType": testutils.AminoCodecFormatter(execType),
	}).MustNil(err, "error reading using json Unmarshaler")

	return types.NewMsgCheckExecution(
		execType.ExecID,
		execType.PayToComplete,
		execType.Sender,
	)
}

// RunCheckExecution is a function to execute check execution
func RunCheckExecution(step FixtureStep, t *testing.T) {

	if step.ParamsRef != "" {
		chkExecMsg := CheckExecutionMsgFromRef(step.ParamsRef, t)
		err := chkExecMsg.ValidateBasic()
		if err != nil {
			TxBroadcastErrorCheck(err, step, t)
			return
		}

		WaitForNextBlockWithErrorCheck(t)
		tci := testutils.GetTestCoinInput()
		tci.PlnH = handlers.NewMsgServerImpl(tci.PlnK)
		result, err := tci.PlnH.CheckExecution(sdk.WrapSDKContext(tci.Ctx), &chkExecMsg)

		TxErrorLogCheck(err, step.Output.TxResult.ErrorLog, t)
		if len(step.Output.TxResult.ErrorLog) > 0 {
			return
		}

		t.MustTrue(result != nil, "result should not be empty")
		TxResultStatusMessageCheck(result.Status, result.Message, step, t)
	}
}

// FiatItemMsgFromRef collect check execution message from reference string
func FiatItemMsgFromRef(ref string, t *testing.T) types.MsgFiatItem {
	byteValue := ReadFile(ref, t)
	// translate sender from account name to account address
	newByteValue := UpdateSenderKeyToAddress(byteValue, t)
	// translate cookbook name to cookbook ID
	newByteValue = UpdateCBNameToID(newByteValue, t)

	var itemType types.Item
	err := json.Unmarshal(newByteValue, &itemType)
	t.WithFields(testing.Fields{
		"itemType": testutils.AminoCodecFormatter(itemType),
	}).MustNil(err, "error reading using json Unmarshaler")

	return types.NewMsgFiatItem(
		itemType.CookbookID,
		itemType.Doubles,
		itemType.Longs,
		itemType.Strings,
		itemType.Sender,
		itemType.TransferFee,
	)
}

// RunFiatItem is a function to execute fiat item
func RunFiatItem(step FixtureStep, t *testing.T) {

	if step.ParamsRef != "" {
		itmMsg := FiatItemMsgFromRef(step.ParamsRef, t)
		err := itmMsg.ValidateBasic()
		if err != nil {
			TxBroadcastErrorCheck(err, step, t)
			return
		}

		WaitForNextBlockWithErrorCheck(t)
		tci := testutils.GetTestCoinInput()
		tci.PlnH = handlers.NewMsgServerImpl(tci.PlnK)
		result, err := tci.PlnH.FiatItem(sdk.WrapSDKContext(tci.Ctx), &itmMsg)

		TxErrorLogCheck(err, step.Output.TxResult.ErrorLog, t)
		if len(step.Output.TxResult.ErrorLog) > 0 {
			return
		}

		t.MustTrue(result != nil, "result should not be empty")
		t.MustTrue(result.ItemID != "", "item id shouldn't be empty")
	}
}

// SendItemsMsgFromRef is a function to collect SendItems from reference string
func SendItemsMsgFromRef(ref string, t *testing.T) types.MsgSendItems {
	byteValue := ReadFile(ref, t)
	// translate sender from account name to account address
	newByteValue := UpdateSenderKeyToAddress(byteValue, t)
	newByteValue = UpdateReceiverKeyToAddress(newByteValue, t)

	var siType struct {
		Sender   string
		Receiver string
		ItemIDs  []string `json:"ItemIDs"`
	}

	err := json.Unmarshal(newByteValue, &siType)
	t.WithFields(testing.Fields{
		"siType":    testutils.AminoCodecFormatter(siType),
		"new_bytes": string(newByteValue),
	}).MustNil(err, "error reading using json Unmarshal")

	sender, err := sdk.AccAddressFromBech32(siType.Sender)
	t.MustNil(err, "error parsing sender address")

	// translate itemNames to itemIDs
	ItemIDs := GetItemIDsFromNames(newByteValue, sender, false, false, t)

	return types.NewMsgSendItems(ItemIDs, siType.Sender, siType.Receiver)
}

// RunSendItems is a function to send items to another user
func RunSendItems(step FixtureStep, t *testing.T) {

	if step.ParamsRef != "" {
		siMsg := SendItemsMsgFromRef(step.ParamsRef, t)
		err := siMsg.ValidateBasic()
		if err != nil {
			TxBroadcastErrorCheck(err, step, t)
			return
		}

		WaitForNextBlockWithErrorCheck(t)
		tci := testutils.GetTestCoinInput()
		tci.PlnH = handlers.NewMsgServerImpl(tci.PlnK)
		result, err := tci.PlnH.SendItems(sdk.WrapSDKContext(tci.Ctx), &siMsg)

		TxErrorLogCheck(err, step.Output.TxResult.ErrorLog, t)
		if len(step.Output.TxResult.ErrorLog) > 0 {
			return
		}

		t.MustTrue(result != nil, "result should not be empty")
		TxResultStatusMessageCheck(result.Status, result.Message, step, t)
	}
}

// UpdateItemStringMsgFromRef is a function to collect UpdateItemStringMsg from reference string
func UpdateItemStringMsgFromRef(ref string, t *testing.T) types.MsgUpdateItemString {
	byteValue := ReadFile(ref, t)
	// translate sender from account name to account address
	newByteValue := UpdateSenderKeyToAddress(byteValue, t)
	// translate item name to item ID
	newByteValue = UpdateItemIDFromName(newByteValue, false, false, t)

	var sTypeMsg types.MsgUpdateItemString
	err := json.Unmarshal(newByteValue, &sTypeMsg)
	t.WithFields(testing.Fields{
		"sTypeMsg":  testutils.AminoCodecFormatter(sTypeMsg),
		"new_bytes": string(newByteValue),
	}).MustNil(err, "error reading using json Unmarshal")
	return sTypeMsg
}

// RunUpdateItemString is a function to update item's string value
func RunUpdateItemString(step FixtureStep, t *testing.T) {

	if step.ParamsRef != "" {
		sTypeMsg := UpdateItemStringMsgFromRef(step.ParamsRef, t)
		err := sTypeMsg.ValidateBasic()
		if err != nil {
			TxBroadcastErrorCheck(err, step, t)
			return
		}
		WaitForNextBlockWithErrorCheck(t)
		tci := testutils.GetTestCoinInput()
		tci.PlnH = handlers.NewMsgServerImpl(tci.PlnK)
		result, err := tci.PlnH.UpdateItemString(sdk.WrapSDKContext(tci.Ctx), &sTypeMsg)

		TxErrorLogCheck(err, step.Output.TxResult.ErrorLog, t)
		if len(step.Output.TxResult.ErrorLog) > 0 {
			return
		}

		t.MustTrue(result != nil, "result should not be empty")
	}
}

// CreateCookbookMsgFromRef is a function to get create cookbook message from reference
func CreateCookbookMsgFromRef(ref string, t *testing.T) types.MsgCreateCookbook {
	byteValue := ReadFile(ref, t)
	// translate sender from account name to account address
	newByteValue := UpdateSenderKeyToAddress(byteValue, t)

	var cbType types.Cookbook
	err := testutils.GetJSONMarshaler().UnmarshalJSON(newByteValue, &cbType)
	t.WithFields(testing.Fields{
		"cbType":    testutils.AminoCodecFormatter(cbType),
		"new_bytes": string(newByteValue),
	}).MustNil(err, "error reading using json Unmarshal")

	return types.NewMsgCreateCookbook(
		cbType.Name,
		cbType.ID,
		cbType.Description,
		cbType.Developer,
		cbType.Version,
		cbType.SupportEmail,
		cbType.Level,
		int64(cbType.CostPerBlock),
		cbType.Sender,
	)
}

// RunCreateCookbook is a function to create cookbook
func RunCreateCookbook(step FixtureStep, t *testing.T) {

	if step.ParamsRef != "" {
		cbMsg := CreateCookbookMsgFromRef(step.ParamsRef, t)
		err := cbMsg.ValidateBasic()
		if err != nil {
			TxBroadcastErrorCheck(err, step, t)
			return
		}

		WaitForNextBlockWithErrorCheck(t)
		tci := testutils.GetTestCoinInput()
		tci.PlnH = handlers.NewMsgServerImpl(tci.PlnK)
		result, err := tci.PlnH.CreateCookbook(sdk.WrapSDKContext(tci.Ctx), &cbMsg)

		TxErrorLogCheck(err, step.Output.TxResult.ErrorLog, t)
		if len(step.Output.TxResult.ErrorLog) > 0 {
			return
		}

		t.MustTrue(result != nil, "result should not be empty")
		t.MustTrue(result.CookbookID != "", "coookbook id shouldn't be empty")
	}
}

// UpdateCookbookMsgFromRef is a function to get update cookbook message from reference
func UpdateCookbookMsgFromRef(ref string, t *testing.T) types.MsgUpdateCookbook {
	byteValue := ReadFile(ref, t)
	// translate sender from account name to account address
	newByteValue := UpdateSenderKeyToAddress(byteValue, t)

	var cbType types.Cookbook
	err := json.Unmarshal(newByteValue, &cbType)
	t.WithFields(testing.Fields{
		"cbType":    testutils.AminoCodecFormatter(cbType),
		"new_bytes": string(newByteValue),
	}).MustNil(err, "error reading using json.Unmarshal")

	return types.NewMsgUpdateCookbook(
		cbType.ID,
		cbType.Description,
		cbType.Developer,
		cbType.Version,
		cbType.SupportEmail,
		cbType.Sender,
	)
}

// RunUpdateCookbook is a function to update cookbook
func RunUpdateCookbook(step FixtureStep, t *testing.T) {
	if step.ParamsRef != "" {
		cbMsg := UpdateCookbookMsgFromRef(step.ParamsRef, t)

		err := cbMsg.ValidateBasic()
		if err != nil {
			TxBroadcastErrorCheck(err, step, t)
			return
		}

		WaitForNextBlockWithErrorCheck(t)
		tci := testutils.GetTestCoinInput()
		tci.PlnH = handlers.NewMsgServerImpl(tci.PlnK)
		result, err := tci.PlnH.HandlerMsgUpdateCookbook(sdk.WrapSDKContext(tci.Ctx), &cbMsg)

		TxErrorLogCheck(err, step.Output.TxResult.ErrorLog, t)
		if len(step.Output.TxResult.ErrorLog) > 0 {
			return
		}

		t.MustTrue(result != nil, "result should not be empty")
		t.MustTrue(result.CookbookID != "", "coookbook id shouldn't be empty")
	}
}

// RunMockCookbook = RunMockAccount + RunCreateCookbook
func RunMockCookbook(step FixtureStep, t *testing.T) {
	if step.ParamsRef != "" {
		sender := GetSenderKeyFromRef(step.ParamsRef, t)
		RunMockAccount(FixtureStep{ParamsRef: sender}, t)
		RunCreateCookbook(step, t)
	}
}

// CreateRecipeMsgFromRef is a function to get create cookbook message from reference
func CreateRecipeMsgFromRef(ref string, t *testing.T) types.MsgCreateRecipe {
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
	err := json.Unmarshal(newByteValue, &rcpTempl)
	t.WithFields(testing.Fields{
		"rcpTempl":  testutils.AminoCodecFormatter(rcpTempl),
		"new_bytes": string(newByteValue),
	}).MustNil(err, "error reading using json.Unmarshal")

	return types.NewMsgCreateRecipe(
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
		rcpTempl.ExtraInfo,
	)
}

// RunCreateRecipe is a function to create recipe
func RunCreateRecipe(step FixtureStep, t *testing.T) {

	if step.ParamsRef != "" {
		rcpMsg := CreateRecipeMsgFromRef(step.ParamsRef, t)
		t.WithFields(testing.Fields{
			"parsed_recipe": string(testutils.GetAminoCdc().MustMarshalJSON(rcpMsg)),
		}).Info("recipe info")

		err := rcpMsg.ValidateBasic()
		if err != nil {
			TxBroadcastErrorCheck(err, step, t)
			return
		}

		WaitForNextBlockWithErrorCheck(t)
		tci := testutils.GetTestCoinInput()
		tci.PlnH = handlers.NewMsgServerImpl(tci.PlnK)
		result, err := tci.PlnH.CreateRecipe(sdk.WrapSDKContext(tci.Ctx), &rcpMsg)

		TxErrorLogCheck(err, step.Output.TxResult.ErrorLog, t)
		if len(step.Output.TxResult.ErrorLog) > 0 {
			return
		}

		t.MustTrue(result != nil, "result should not be empty")
		t.MustTrue(result.RecipeID != "", "recipe id shouldn't be empty")
	}
}

// UpdateRecipeMsgFromRef is a function to get update recipe message from reference
func UpdateRecipeMsgFromRef(ref string, t *testing.T) types.MsgUpdateRecipe {
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
	err := json.Unmarshal(newByteValue, &rcpTempl)
	t.WithFields(testing.Fields{
		"rcpTempl":  testutils.AminoCodecFormatter(rcpTempl),
		"new_bytes": string(newByteValue),
	}).MustNil(err, "error reading using json.Unmarshal")

	addr, err := sdk.AccAddressFromBech32(rcpTempl.Sender)
	TxResultDecodingErrorCheck(err, t)

	return types.NewMsgUpdateRecipe(
		rcpTempl.ID,
		rcpTempl.Name,
		rcpTempl.CookbookID,
		rcpTempl.Description,
		rcpTempl.CoinInputs,
		itemInputs,
		entries,
		rcpTempl.Outputs,
		rcpTempl.BlockInterval,
		addr.String(),
	)
}

// RunUpdateRecipe is a function to update recipe
func RunUpdateRecipe(step FixtureStep, t *testing.T) {
	if step.ParamsRef != "" {
		rcpMsg := UpdateRecipeMsgFromRef(step.ParamsRef, t)

		err := rcpMsg.ValidateBasic()
		if err != nil {
			TxBroadcastErrorCheck(err, step, t)
			return
		}

		WaitForNextBlockWithErrorCheck(t)

		tci := testutils.GetTestCoinInput()
		tci.PlnH = handlers.NewMsgServerImpl(tci.PlnK)
		result, err := tci.PlnH.HandlerMsgUpdateRecipe(sdk.WrapSDKContext(tci.Ctx), &rcpMsg)
		TxErrorLogCheck(err, step.Output.TxResult.ErrorLog, t)
		if len(step.Output.TxResult.ErrorLog) > 0 {
			return
		}

		t.MustTrue(result != nil, "result should not be empty")
		t.MustTrue(result.RecipeID != "", "recipe id shouldn't be empty")
	}
}

// EnableRecipeMsgFromRef is a function to get enable recipe message from reference
func EnableRecipeMsgFromRef(ref string, t *testing.T) types.MsgEnableRecipe {
	byteValue := ReadFile(ref, t)
	// translate sender from account name to account address
	newByteValue := UpdateSenderKeyToAddress(byteValue, t)
	// translate recipe name to recipe id
	newByteValue = UpdateRecipeName(newByteValue, t)

	var recipeType struct {
		RecipeID string
		Sender   string
	}

	err := json.Unmarshal(newByteValue, &recipeType)
	t.WithFields(testing.Fields{
		"rcpTempl":  testutils.AminoCodecFormatter(recipeType),
		"new_bytes": string(newByteValue),
	}).MustNil(err, "error reading using json.Unmarshal")

	return types.NewMsgEnableRecipe(recipeType.RecipeID, recipeType.Sender)
}

// RunEnableRecipe is a function to enable recipe
func RunEnableRecipe(step FixtureStep, t *testing.T) {
	if step.ParamsRef != "" {
		rcpMsg := EnableRecipeMsgFromRef(step.ParamsRef, t)

		err := rcpMsg.ValidateBasic()
		if err != nil {
			TxBroadcastErrorCheck(err, step, t)
			return
		}

		WaitForNextBlockWithErrorCheck(t)

		tci := testutils.GetTestCoinInput()
		tci.PlnH = handlers.NewMsgServerImpl(tci.PlnK)
		result, err := tci.PlnH.EnableRecipe(sdk.WrapSDKContext(tci.Ctx), &rcpMsg)
		TxErrorLogCheck(err, step.Output.TxResult.ErrorLog, t)
		if len(step.Output.TxResult.ErrorLog) > 0 {
			return
		}

		t.MustTrue(result != nil, "result should not be empty")
		TxResultStatusMessageCheck(result.Status, result.Message, step, t)
	}
}

// DisableRecipeMsgFromRef is a function to get disable recipe message from reference
func DisableRecipeMsgFromRef(ref string, t *testing.T) types.MsgDisableRecipe {
	byteValue := ReadFile(ref, t)
	// translate sender from account name to account address
	newByteValue := UpdateSenderKeyToAddress(byteValue, t)
	// translate recipe name to recipe id
	newByteValue = UpdateRecipeName(newByteValue, t)

	var recipeType struct {
		RecipeID string
		Sender   string
	}

	err := json.Unmarshal(newByteValue, &recipeType)
	t.WithFields(testing.Fields{
		"rcpTempl":  testutils.AminoCodecFormatter(recipeType),
		"new_bytes": string(newByteValue),
	}).MustNil(err, "error reading using json.Unmarshal")

	return types.NewMsgDisableRecipe(recipeType.RecipeID, recipeType.Sender)
}

// RunDisableRecipe is a function to disable recipe
func RunDisableRecipe(step FixtureStep, t *testing.T) {
	if step.ParamsRef != "" {
		rcpMsg := DisableRecipeMsgFromRef(step.ParamsRef, t)

		err := rcpMsg.ValidateBasic()
		if err != nil {
			TxBroadcastErrorCheck(err, step, t)
			return
		}

		WaitForNextBlockWithErrorCheck(t)

		tci := testutils.GetTestCoinInput()
		tci.PlnH = handlers.NewMsgServerImpl(tci.PlnK)
		result, err := tci.PlnH.DisableRecipe(sdk.WrapSDKContext(tci.Ctx), &rcpMsg)
		TxErrorLogCheck(err, step.Output.TxResult.ErrorLog, t)
		if len(step.Output.TxResult.ErrorLog) > 0 {
			return
		}

		t.MustTrue(result != nil, "result should not be empty")
		TxResultStatusMessageCheck(result.Status, result.Message, step, t)
	}
}

// ExecuteRecipeMsgFromRef collect execute recipe msg from reference string
func ExecuteRecipeMsgFromRef(ref string, t *testing.T) types.MsgExecuteRecipe {
	byteValue := ReadFile(ref, t)
	// translate sender from account name to account address
	newByteValue := UpdateSenderKeyToAddress(byteValue, t)
	// translate recipe name to recipe id
	newByteValue = UpdateRecipeName(newByteValue, t)

	var execType struct {
		RecipeID      string
		Sender        string
		PaymentId     string
		PaymentMethod string
		ItemIDs       []string `json:"ItemIDs"`
	}

	err := json.Unmarshal(newByteValue, &execType)
	t.WithFields(testing.Fields{
		"execType":  testutils.AminoCodecFormatter(execType),
		"new_bytes": string(newByteValue),
	}).MustNil(err, "error reading using json.Unmarshal")

	// translate itemNames to itemIDs
	sender, err := sdk.AccAddressFromBech32(execType.Sender)
	t.MustNil(err, "error parsing sender address")
	ItemIDs := GetItemIDsFromNames(newByteValue, sender, false, false, t)
	return types.NewMsgExecuteRecipe(execType.RecipeID, execType.Sender, execType.PaymentId, execType.PaymentMethod, ItemIDs)
}

// StripeCheckoutMsgFromRef collect checkout stripe msg from reference string
func StripeCheckoutMsgFromRef(ref string, t *testing.T) types.MsgStripeCheckout {
	byteValue := ReadFile(ref, t)
	// translate sender from account name to account address
	newByteValue := UpdateSenderKeyToAddress(byteValue, t)
	// translate recipe name to recipe id
	newByteValue = UpdateRecipeName(newByteValue, t) //???

	var execType struct {
		StripeKey     string
		PaymentMethod string
		Price         *types.StripePrice
		Sender        string
	}
	err := json.Unmarshal(newByteValue, &execType)
	t.WithFields(testing.Fields{
		"execType":  testutils.AminoCodecFormatter(execType),
		"new_bytes": string(newByteValue),
	}).MustNil(err, "error reading using json.Unmarshal")

	return types.NewMsgStripeCheckout(execType.StripeKey, execType.PaymentMethod, execType.Price, execType.Sender)
}

// StripeCreateProductMsgFromRef collect create product msg from reference string
func StripeCreateProductMsgFromRef(ref string, t *testing.T) types.MsgStripeCreateProduct {
	byteValue := ReadFile(ref, t)
	// translate sender from account name to account address
	newByteValue := UpdateSenderKeyToAddress(byteValue, t)
	// translate recipe name to recipe id
	newByteValue = UpdateRecipeName(newByteValue, t) //???

	var execType types.MsgStripeCreateProduct

	err := json.Unmarshal(newByteValue, &execType)
	t.WithFields(testing.Fields{
		"execType":  testutils.AminoCodecFormatter(execType),
		"new_bytes": string(newByteValue),
	}).MustNil(err, "error reading using json.Unmarshal")

	return types.NewMsgStripeCreateProduct(execType.StripeKey, execType.Name, execType.Description, execType.Images, execType.StatementDescriptor, execType.UnitLabel, execType.Sender)
}

// StripeCreatePriceMsgFromRef collect create price msg from reference string
func StripeCreatePriceMsgFromRef(ref string, t *testing.T) types.MsgStripeCreatePrice {
	byteValue := ReadFile(ref, t)
	// translate sender from account name to account address
	newByteValue := UpdateSenderKeyToAddress(byteValue, t)
	// translate recipe name to recipe id
	newByteValue = UpdateRecipeName(newByteValue, t) //???

	var execType types.MsgStripeCreatePrice

	err := json.Unmarshal(newByteValue, &execType)
	t.WithFields(testing.Fields{
		"execType":  testutils.AminoCodecFormatter(execType),
		"new_bytes": string(newByteValue),
	}).MustNil(err, "error reading using json.Unmarshal")
	return types.NewMsgStripeCreatePrice(execType.StripeKey, execType.Product, execType.Amount, execType.Currency, execType.Description, execType.Sender)
}

// StripeCreateSkuMsgFromRef collect create sku msg from reference string
func StripeCreateSkuMsgFromRef(ref string, t *testing.T) types.MsgStripeCreateSku {
	byteValue := ReadFile(ref, t)
	// translate sender from account name to account address
	newByteValue := UpdateSenderKeyToAddress(byteValue, t)
	// translate recipe name to recipe id
	newByteValue = UpdateRecipeName(newByteValue, t) //???

	var execType types.MsgStripeCreateSku

	err := json.Unmarshal(newByteValue, &execType)
	t.WithFields(testing.Fields{
		"execType":  testutils.AminoCodecFormatter(execType),
		"new_bytes": string(newByteValue),
	}).MustNil(err, "error reading using json.Unmarshal")
	return types.NewMsgStripeCreateSku(execType.StripeKey, execType.Product, execType.Attributes, execType.Price, execType.Currency, execType.Inventory, execType.Sender)
}

// StripeCreatePaymentIntentMsgFromRef collect create sku msg from reference string
func StripeCreatePaymentIntentMsgFromRef(ref string, t *testing.T) types.MsgStripeCreatePaymentIntent {
	byteValue := ReadFile(ref, t)
	// translate sender from account name to account address
	newByteValue := UpdateSenderKeyToAddress(byteValue, t)
	// translate recipe name to recipe id
	newByteValue = UpdateRecipeName(newByteValue, t) //???

	var execType types.MsgStripeCreatePaymentIntent

	err := json.Unmarshal(newByteValue, &execType)
	t.WithFields(testing.Fields{
		"execType":  testutils.AminoCodecFormatter(execType),
		"new_bytes": string(newByteValue),
	}).MustNil(err, "error reading using json.Unmarshal")
	return types.NewMsgStripeCreatePaymentIntent(execType.StripeKey, execType.Amount, execType.Currency, execType.PaymentMethod, execType.Sender)
}

// RunExecuteRecipe is executed when an action "execute_recipe" is called
func RunExecuteRecipe(step FixtureStep, t *testing.T) {
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
		tci.PlnH = handlers.NewMsgServerImpl(tci.PlnK)
		result, err := tci.PlnH.ExecuteRecipe(sdk.WrapSDKContext(tci.Ctx), &execMsg)

		TxErrorLogCheck(err, step.Output.TxResult.ErrorLog, t)
		if len(step.Output.TxResult.ErrorLog) > 0 {
			return
		}

		t.MustTrue(result != nil, "result should not be empty", err)
		TxResultStatusMessageCheck(result.Status, result.Message, step, t)

		if result.Message == "scheduled the recipe" { // delayed execution
			var scheduleRes types.ExecuteRecipeScheduleOutput

			err := json.Unmarshal(result.Output, &scheduleRes)
			t.WithFields(testing.Fields{
				"response_output": string(result.Output),
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
				"output": string(result.Output),
			}).Debug("straight execution result")
		}
	}
}

func RunStripeCheckout(step FixtureStep, t *testing.T) {
	// TODO should check item ID is returned
	// TODO when items are generated, rather than returning whole should return only ID [if multiple, array of item IDs]

	if step.ParamsRef != "" {
		execMsg := StripeCheckoutMsgFromRef(step.ParamsRef, t)
		err := execMsg.ValidateBasic()
		if err != nil {
			TxBroadcastErrorCheck(err, step, t)
			return
		}

		WaitForNextBlockWithErrorCheck(t)
		tci := testutils.GetTestCoinInput()
		tci.PlnH = handlers.NewMsgServerImpl(tci.PlnK)
		result, err := tci.PlnH.StripeCheckout(sdk.WrapSDKContext(tci.Ctx), &execMsg)

		TxErrorLogCheck(err, step.Output.TxResult.ErrorLog, t)
		if len(step.Output.TxResult.ErrorLog) > 0 {
			return
		}

		t.MustTrue(result != nil, "result should not be empty", err)
		TxResultStatusMessageCheck(result.Status, result.Message, step, t)

		if result.Message == "scheduled the stripe_checkout" { // delayed execution
			var scheduleRes types.StripeCheckoutScheduleOutput

			err := json.Unmarshal([]byte(result.SessionID), &scheduleRes)
			t.WithFields(testing.Fields{
				"response_output": string(result.SessionID),
			}).MustNil(err, "error decoding raw json")
			execIDRWMutex.Lock()
			execIDs[step.ID] = scheduleRes.SessionID
			execIDRWMutex.Unlock()

			t.WithFields(testing.Fields{
				"session_id": scheduleRes.SessionID,
			}).Debug("scheduled stripe_checkout")
		} else { // straight execution
			t.WithFields(testing.Fields{
				"Status": string(result.Status),
			}).Debug("straight stripe_checkout result")
		}
	}
}

func RunStripeCreateProduct(step FixtureStep, t *testing.T) {
	// TODO should check item ID is returned
	// TODO when items are generated, rather than returning whole should return only ID [if multiple, array of item IDs]

	if step.ParamsRef != "" {
		execMsg := StripeCreateProductMsgFromRef(step.ParamsRef, t)
		err := execMsg.ValidateBasic()
		if err != nil {
			TxBroadcastErrorCheck(err, step, t)
			return
		}

		WaitForNextBlockWithErrorCheck(t)
		tci := testutils.GetTestCoinInput()
		tci.PlnH = handlers.NewMsgServerImpl(tci.PlnK)
		result, err := tci.PlnH.StripeCreateProduct(sdk.WrapSDKContext(tci.Ctx), &execMsg)

		TxErrorLogCheck(err, step.Output.TxResult.ErrorLog, t)
		if len(step.Output.TxResult.ErrorLog) > 0 {
			return
		}

		t.MustTrue(result != nil, "result should not be empty", err)
		TxResultStatusMessageCheck(result.Status, result.Message, step, t)

		if result.Message == "scheduled the stripe_create_product" { // delayed execution
			var scheduleRes types.StripeCreateProductScheduleOutput

			err := json.Unmarshal([]byte(result.ProductID), &scheduleRes)
			t.WithFields(testing.Fields{
				"response_output": string(result.ProductID),
			}).MustNil(err, "error decoding raw json")
			execIDRWMutex.Lock()
			execIDs[step.ID] = scheduleRes.ProductID
			execIDRWMutex.Unlock()

			t.WithFields(testing.Fields{
				"session_id": scheduleRes.ProductID,
			}).Debug("scheduled stripe_create_product")
		} else { // straight execution
			t.WithFields(testing.Fields{
				"Status": string(result.Status),
			}).Debug("straight stripe_create_product result")
		}
	}
}

func RunStripeCreatePrice(step FixtureStep, t *testing.T) {
	// TODO should check item ID is returned
	// TODO when items are generated, rather than returning whole should return only ID [if multiple, array of item IDs]

	if step.ParamsRef != "" {
		execMsg := StripeCreatePriceMsgFromRef(step.ParamsRef, t)
		err := execMsg.ValidateBasic()
		if err != nil {
			TxBroadcastErrorCheck(err, step, t)
			return
		}

		WaitForNextBlockWithErrorCheck(t)
		tci := testutils.GetTestCoinInput()
		tci.PlnH = handlers.NewMsgServerImpl(tci.PlnK)
		result, err := tci.PlnH.StripeCreatePrice(sdk.WrapSDKContext(tci.Ctx), &execMsg)

		TxErrorLogCheck(err, step.Output.TxResult.ErrorLog, t)
		if len(step.Output.TxResult.ErrorLog) > 0 {
			return
		}

		t.MustTrue(result != nil, "result should not be empty", err)
		TxResultStatusMessageCheck(result.Status, result.Message, step, t)

		if result.Message == "scheduled the stripe_create_price" { // delayed execution
			var scheduleRes types.StripeCreatePriceScheduleOutput

			err := json.Unmarshal([]byte(result.PriceID), &scheduleRes)
			t.WithFields(testing.Fields{
				"response_output": string(result.PriceID),
			}).MustNil(err, "error decoding raw json")
			execIDRWMutex.Lock()
			execIDs[step.ID] = scheduleRes.PriceID
			execIDRWMutex.Unlock()

			t.WithFields(testing.Fields{
				"session_id": scheduleRes.PriceID,
			}).Debug("scheduled stripe_create_price")
		} else { // straight execution
			t.WithFields(testing.Fields{
				"Status": string(result.Status),
			}).Debug("straight stripe_create_price result")
		}
	}
}

func RunStripeCreateSku(step FixtureStep, t *testing.T) {
	// TODO should check item ID is returned
	// TODO when items are generated, rather than returning whole should return only ID [if multiple, array of item IDs]

	if step.ParamsRef != "" {
		execMsg := StripeCreateSkuMsgFromRef(step.ParamsRef, t)
		err := execMsg.ValidateBasic()
		if err != nil {
			TxBroadcastErrorCheck(err, step, t)
			return
		}

		WaitForNextBlockWithErrorCheck(t)
		tci := testutils.GetTestCoinInput()
		tci.PlnH = handlers.NewMsgServerImpl(tci.PlnK)
		result, err := tci.PlnH.StripeCreateSku(sdk.WrapSDKContext(tci.Ctx), &execMsg)

		TxErrorLogCheck(err, step.Output.TxResult.ErrorLog, t)
		if len(step.Output.TxResult.ErrorLog) > 0 {
			return
		}

		t.MustTrue(result != nil, "result should not be empty", err)
		TxResultStatusMessageCheck(result.Status, result.Message, step, t)

		if result.Message == "scheduled the stripe_create_sku" { // delayed execution
			var scheduleRes types.StripeCreateSkuScheduleOutput

			err := json.Unmarshal([]byte(result.SKUID), &scheduleRes)
			t.WithFields(testing.Fields{
				"response_output": string(result.SKUID),
			}).MustNil(err, "error decoding raw json")
			execIDRWMutex.Lock()
			execIDs[step.ID] = scheduleRes.SKUID
			execIDRWMutex.Unlock()

			t.WithFields(testing.Fields{
				"session_id": scheduleRes.SKUID,
			}).Debug("scheduled stripe_create_sku")
		} else { // straight execution
			t.WithFields(testing.Fields{
				"Status": string(result.Status),
			}).Debug("straight stripe_create_sku result")
		}
	}
}

// CreateTradeMsgFromRef collect create trade msg from reference
func CreateTradeMsgFromRef(ref string, t *testing.T) types.MsgCreateTrade {
	byteValue := ReadFile(ref, t)
	// translate sender from account name to account address
	newByteValue := UpdateSenderKeyToAddress(byteValue, t)
	// get item inputs from fileNames
	tradeItemInputs := GetTradeItemInputsFromBytes(newByteValue, t)
	var trdType types.Trade
	err := json.Unmarshal(newByteValue, &trdType)
	t.WithFields(testing.Fields{
		"trdType":   testutils.AminoCodecFormatter(trdType),
		"new_bytes": string(newByteValue),
	}).MustNil(err, "error reading using json.Unmarshal")

	addr, err := sdk.AccAddressFromBech32(trdType.Sender)
	TxResultDecodingErrorCheck(err, t)

	// get ItemOutputs from ItemOutputNames
	itemOutputs := GetItemOutputsFromBytes(newByteValue, addr, t)

	return types.NewMsgCreateTrade(
		trdType.CoinInputs,
		tradeItemInputs,
		trdType.CoinOutputs,
		itemOutputs,
		trdType.ExtraInfo,
		trdType.Sender,
	)
}

// RunCreateTrade is a function to create trade
func RunCreateTrade(step FixtureStep, t *testing.T) {

	if step.ParamsRef != "" {
		createTrd := CreateTradeMsgFromRef(step.ParamsRef, t)
		t.WithFields(testing.Fields{
			"tx_msgs": testutils.AminoCodecFormatter(createTrd),
		}).AddFields(testutils.GetLogFieldsFromMsgs([]sdk.Msg{&createTrd})).Debug("createTrd")
		err := createTrd.ValidateBasic()
		if err != nil {
			TxBroadcastErrorCheck(err, step, t)
			return
		}

		WaitForNextBlockWithErrorCheck(t)
		tci := testutils.GetTestCoinInput()
		tci.PlnH = handlers.NewMsgServerImpl(tci.PlnK)
		result, err := tci.PlnH.CreateTrade(sdk.WrapSDKContext(tci.Ctx), &createTrd)

		TxErrorLogCheck(err, step.Output.TxResult.ErrorLog, t)
		if len(step.Output.TxResult.ErrorLog) > 0 {
			return
		}

		t.MustTrue(result != nil, "result should not be empty")
		t.MustTrue(result.TradeID != "", "trade id shouldn't be empty")
	}
}

// FulfillTradeMsgFromRef collect fulfill trade message from reference string
func FulfillTradeMsgFromRef(ref string, t *testing.T) types.MsgFulfillTrade {
	byteValue := ReadFile(ref, t)
	// translate sender from account name to account address
	newByteValue := UpdateSenderKeyToAddress(byteValue, t)
	// translate extra info to trade id
	newByteValue = UpdateTradeExtraInfoToID(newByteValue, t)

	var trdType struct {
		TradeID string
		Sender  string
		ItemIDs []string `json:"ItemIDs"`
	}

	err := json.Unmarshal(newByteValue, &trdType)
	t.WithFields(testing.Fields{
		"trdType":   testutils.AminoCodecFormatter(trdType),
		"new_bytes": string(newByteValue),
	}).MustNil(err, "error reading using json.Unmarshal")
	// translate itemNames to itemIDs
	sender, err := sdk.AccAddressFromBech32(trdType.Sender)
	t.MustNil(err, "error parsing sender address")
	ItemIDs := GetItemIDsFromNames(newByteValue, sender, false, false, t)

	return types.NewMsgFulfillTrade(trdType.TradeID, trdType.Sender, ItemIDs)
}

// RunFulfillTrade is a function to fulfill trade
func RunFulfillTrade(step FixtureStep, t *testing.T) {

	if step.ParamsRef != "" {
		ffTrdMsg := FulfillTradeMsgFromRef(step.ParamsRef, t)
		err := ffTrdMsg.ValidateBasic()
		if err != nil {
			TxBroadcastErrorCheck(err, step, t)
			return
		}

		WaitForNextBlockWithErrorCheck(t)
		tci := testutils.GetTestCoinInput()
		tci.PlnH = handlers.NewMsgServerImpl(tci.PlnK)
		result, err := tci.PlnH.FulfillTrade(sdk.WrapSDKContext(tci.Ctx), &ffTrdMsg)

		TxErrorLogCheck(err, step.Output.TxResult.ErrorLog, t)
		if len(step.Output.TxResult.ErrorLog) > 0 {
			return
		}

		t.MustTrue(result != nil, "result should not be empty")
		TxResultStatusMessageCheck(result.Status, result.Message, step, t)
	}
}

// DisableTradeMsgFromRef collect disable trade msg from reference string
func DisableTradeMsgFromRef(ref string, t *testing.T) types.MsgDisableTrade {
	byteValue := ReadFile(ref, t)
	// translate sender from account name to account address
	newByteValue := UpdateSenderKeyToAddress(byteValue, t)
	// translate extra info to trade id
	newByteValue = UpdateTradeExtraInfoToID(newByteValue, t)

	var trdType struct {
		TradeID string
		Sender  string
	}

	err := json.Unmarshal(newByteValue, &trdType)
	t.WithFields(testing.Fields{
		"trdType":   testutils.AminoCodecFormatter(trdType),
		"new_bytes": string(newByteValue),
	}).MustNil(err, "error reading using json.Unmarshal")

	return types.NewMsgDisableTrade(trdType.TradeID, trdType.Sender)
}

// RunDisableTrade is a function to disable trade
func RunDisableTrade(step FixtureStep, t *testing.T) {

	if step.ParamsRef != "" {
		dsTrdMsg := DisableTradeMsgFromRef(step.ParamsRef, t)
		err := dsTrdMsg.ValidateBasic()
		if err != nil {
			TxBroadcastErrorCheck(err, step, t)
			return
		}

		WaitForNextBlockWithErrorCheck(t)
		tci := testutils.GetTestCoinInput()
		tci.PlnH = handlers.NewMsgServerImpl(tci.PlnK)
		result, err := tci.PlnH.DisableTrade(sdk.WrapSDKContext(tci.Ctx), &dsTrdMsg)

		TxErrorLogCheck(err, step.Output.TxResult.ErrorLog, t)
		if len(step.Output.TxResult.ErrorLog) > 0 {
			return
		}

		t.MustTrue(result != nil, "result should not be empty")
		TxResultStatusMessageCheck(result.Status, result.Message, step, t)
	}
}

// EnableTradeMsgFromRef collect enable trade msg from reference string
func EnableTradeMsgFromRef(ref string, t *testing.T) types.MsgEnableTrade {
	byteValue := ReadFile(ref, t)
	// translate sender from account name to account address
	newByteValue := UpdateSenderKeyToAddress(byteValue, t)
	// translate extra info to trade id
	newByteValue = UpdateTradeExtraInfoToID(newByteValue, t)

	var trdType struct {
		TradeID string
		Sender  string
	}

	err := json.Unmarshal(newByteValue, &trdType)
	t.WithFields(testing.Fields{
		"trdType":   testutils.AminoCodecFormatter(trdType),
		"new_bytes": string(newByteValue),
	}).MustNil(err, "error reading using json.Unmarshal")

	return types.NewMsgEnableTrade(trdType.TradeID, trdType.Sender)
}

// RunEnableTrade is a function to enable trade
func RunEnableTrade(step FixtureStep, t *testing.T) {

	if step.ParamsRef != "" {
		dsTrdMsg := EnableTradeMsgFromRef(step.ParamsRef, t)
		err := dsTrdMsg.ValidateBasic()
		if err != nil {
			TxBroadcastErrorCheck(err, step, t)
			return
		}

		WaitForNextBlockWithErrorCheck(t)

		tci := testutils.GetTestCoinInput()
		tci.PlnH = handlers.NewMsgServerImpl(tci.PlnK)
		result, err := tci.PlnH.EnableTrade(sdk.WrapSDKContext(tci.Ctx), &dsTrdMsg)
		TxErrorLogCheck(err, step.Output.TxResult.ErrorLog, t)
		if len(step.Output.TxResult.ErrorLog) > 0 {
			return
		}

		t.MustTrue(result != nil, "result should not be empty")
		TxResultStatusMessageCheck(result.Status, result.Message, step, t)
	}
}
