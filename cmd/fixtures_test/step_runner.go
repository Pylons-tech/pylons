package fixtureTest

import (
	"encoding/json"
	"strings"

	testing "github.com/Pylons-tech/pylons/cmd/fixtures_test/evtesting"

	intTest "github.com/Pylons-tech/pylons/cmd/test"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"

	"github.com/Pylons-tech/pylons/x/pylons/handlers"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

func RunCheckExecution(step FixtureStep, t *testing.T) {

	if step.ParamsRef != "" {
		byteValue := ReadFile(step.ParamsRef, t)
		// translate sender from account name to account address
		newByteValue := UpdateSenderName(byteValue, t)
		// translate execRef to execID
		newByteValue = UpdateExecID(newByteValue, t)

		var execType struct {
			ExecID        string
			PayToComplete bool
			Sender        sdk.AccAddress
		}
		err := intTest.GetAminoCdc().UnmarshalJSON(newByteValue, &execType)
		if err != nil {
			t.Fatal("error reading using GetAminoCdc ", execType, err)
		}
		t.MustNil(err)

		chkExecMsg := msgs.NewMsgCheckExecution(
			execType.ExecID,
			execType.PayToComplete,
			execType.Sender,
		)
		txhash := intTest.TestTxWithMsgWithNonce(t, chkExecMsg, execType.Sender.String(), true)

		err = intTest.WaitForNextBlock()
		intTest.ErrValidation(t, "error waiting for check execution %+v", err)

		txHandleResBytes, err := intTest.WaitAndGetTxData(txhash, 3, t)
		intTest.ErrValidation(t, "error getting tx result bytes %+v", err)

		CheckErrorOnTx(txhash, t)
		resp := handlers.CheckExecutionResp{}
		err = intTest.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
		t.Log("txhash=", txhash)
		intTest.ErrValidation(t, "error unmarshaling tx response %+v", err)
		t.MustTrue(resp.Status == step.Output.TxResult.Status)
		if len(step.Output.TxResult.Message) > 0 {
			t.MustTrue(resp.Message == step.Output.TxResult.Message)
		}
	}
}

func RunFiatItem(step FixtureStep, t *testing.T) {

	if step.ParamsRef != "" {
		byteValue := ReadFile(step.ParamsRef, t)
		// translate sender from account name to account address
		newByteValue := UpdateSenderName(byteValue, t)
		// translate cookbook name to cookbook ID
		newByteValue = UpdateCookbookName(newByteValue, t)

		var itemType types.Item
		err := intTest.GetAminoCdc().UnmarshalJSON(newByteValue, &itemType)
		if err != nil {
			t.Fatal("error reading using GetAminoCdc ", itemType, err)
		}
		t.MustNil(err)

		itmMsg := msgs.NewMsgFiatItem(
			itemType.CookbookID,
			itemType.Doubles,
			itemType.Longs,
			itemType.Strings,
			itemType.Sender,
		)
		txhash := intTest.TestTxWithMsgWithNonce(t, itmMsg, itemType.Sender.String(), true)

		err = intTest.WaitForNextBlock()
		intTest.ErrValidation(t, "error waiting for fiat item %+v", err)

		txHandleResBytes, err := intTest.WaitAndGetTxData(txhash, 3, t)
		intTest.ErrValidation(t, "error getting tx result bytes %+v", err)

		CheckErrorOnTx(txhash, t)
		resp := handlers.FiatItemResponse{}
		err = intTest.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)

		t.Log("txhash=", txhash)
		intTest.ErrValidation(t, "error unmarshaling tx response %+v", err)
		t.MustTrue(resp.ItemID != "")
	}
}

func RunSetItemFieldString(step FixtureStep, t *testing.T) {

	if step.ParamsRef != "" {
		byteValue := ReadFile(step.ParamsRef, t)
		// translate sender from account name to account address
		newByteValue := UpdateSenderName(byteValue, t)
		// translate item name to item ID
		newByteValue = UpdateItemIDFromName(newByteValue, false, t)

		var sTypeMsg msgs.MsgSetItemFieldString
		err := json.Unmarshal(newByteValue, &sTypeMsg)
		if err != nil {
			t.Fatal("error reading using GetAminoCdc ", sTypeMsg, string(newByteValue), err)
		}
		t.MustNil(err)

		txhash := intTest.TestTxWithMsgWithNonce(t, sTypeMsg, sTypeMsg.Sender.String(), true)

		err = intTest.WaitForNextBlock()
		intTest.ErrValidation(t, "error waiting for set item field string %+v", err)

		txHandleResBytes, err := intTest.WaitAndGetTxData(txhash, 3, t)
		intTest.ErrValidation(t, "error getting tx result bytes %+v", err)

		CheckErrorOnTx(txhash, t)
		resp := handlers.SetItemFieldStringResp{}
		err = intTest.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)

		t.Log("txhash=", txhash)
		intTest.ErrValidation(t, "error unmarshaling tx response %+v", err)
	}
}

func RunCreateCookbook(step FixtureStep, t *testing.T) {
	if step.ParamsRef != "" {
		byteValue := ReadFile(step.ParamsRef, t)
		// translate sender from account name to account address
		newByteValue := UpdateSenderName(byteValue, t)

		var cbType types.Cookbook
		err := intTest.GetAminoCdc().UnmarshalJSON(newByteValue, &cbType)
		if err != nil {
			t.Fatal("error reading using GetAminoCdc ", cbType, string(newByteValue), err)
		}
		t.MustNil(err)

		cbMsg := msgs.NewMsgCreateCookbook(
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

		txhash := intTest.TestTxWithMsgWithNonce(t, cbMsg, cbType.Sender.String(), true)

		err = intTest.WaitForNextBlock()
		intTest.ErrValidation(t, "error waiting for creating cookbook %+v", err)

		txHandleResBytes, err := intTest.WaitAndGetTxData(txhash, 3, t)
		intTest.ErrValidationWithOutputLog(t, "error getting transaction data for creating cookbook %+v", txHandleResBytes, err)

		CheckErrorOnTx(txhash, t)
		resp := handlers.CreateCBResponse{}
		err = intTest.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
		t.Log("txhash=", txhash)
		intTest.ErrValidation(t, "error unmarshaling tx response %+v", err)
		t.MustTrue(resp.CookbookID != "")
	}
}

func RunCreateRecipe(step FixtureStep, t *testing.T) {
	if step.ParamsRef != "" {
		byteValue := ReadFile(step.ParamsRef, t)
		// translate sender from account name to account address
		newByteValue := UpdateSenderName(byteValue, t)
		// translate cookbook name to cookbook id
		newByteValue = UpdateCookbookName(newByteValue, t)
		// get item inputs from fileNames
		itemInputs := GetItemInputsFromBytes(newByteValue, t)
		// get entries from fileNames
		entries := GetEntriesFromBytes(newByteValue, t)

		var rcpTempl types.Recipe
		err := intTest.GetAminoCdc().UnmarshalJSON(newByteValue, &rcpTempl)
		if err != nil {
			t.Fatal("error reading using GetAminoCdc ", rcpTempl, err)
		}
		t.MustNil(err)

		rcpMsg := msgs.NewMsgCreateRecipe(
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

		txhash := intTest.TestTxWithMsgWithNonce(t, rcpMsg, rcpTempl.Sender.String(), true)

		err = intTest.WaitForNextBlock()
		intTest.ErrValidation(t, "error waiting for creating recipe %+v", err)

		txHandleResBytes, err := intTest.WaitAndGetTxData(txhash, 3, t)
		t.MustNil(err)

		CheckErrorOnTx(txhash, t)
		resp := handlers.CreateRecipeResponse{}
		err = intTest.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
		t.Log("txhash=", txhash)
		intTest.ErrValidation(t, "error unmarshaling tx response %+v", err)
		t.MustTrue(resp.RecipeID != "")
	}
}

// RunExecuteRecipe is executed when an action "execute_recipe" is called
func RunExecuteRecipe(step FixtureStep, t *testing.T) {
	// TODO should check item ID is returned
	// TODO when items are generated, rather than returning whole should return only ID [if multiple, array of item IDs]

	if step.ParamsRef != "" {
		byteValue := ReadFile(step.ParamsRef, t)
		// translate sender from account name to account address
		newByteValue := UpdateSenderName(byteValue, t)
		// translate recipe name to recipe id
		newByteValue = UpdateRecipeName(newByteValue, t)
		// translate itemNames to itemIDs
		ItemIDs := GetItemIDsFromNames(newByteValue, false, t)

		var execType struct {
			RecipeID string
			Sender   sdk.AccAddress
			ItemIDs  []string `json:"ItemIDs"`
		}

		err := intTest.GetAminoCdc().UnmarshalJSON(newByteValue, &execType)
		if err != nil {
			t.Fatal("error reading using GetAminoCdc ", execType, err)
		}
		t.MustNil(err)

		// t.Log("Executed recipe with below params", execType.RecipeID, execType.Sender, ItemIDs)
		execMsg := msgs.NewMsgExecuteRecipe(execType.RecipeID, execType.Sender, ItemIDs)
		txhash := intTest.TestTxWithMsgWithNonce(t, execMsg, execType.Sender.String(), true)

		err = intTest.WaitForNextBlock()
		intTest.ErrValidation(t, "error waiting for executing recipe %+v", err)

		if len(step.Output.TxResult.ErrorLog) > 0 {
			hmrErrMsg := intTest.GetHumanReadableErrorFromTxHash(txhash, t)
			t.Log("hmrErrMsg=", hmrErrMsg)
			t.MustTrue(strings.Contains(hmrErrMsg, step.Output.TxResult.ErrorLog))
		} else {
			txHandleResBytes, err := intTest.WaitAndGetTxData(txhash, 3, t)
			t.MustNil(err)
			CheckErrorOnTx(txhash, t)
			resp := handlers.ExecuteRecipeResp{}
			err = intTest.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
			if err != nil {
				t.Fatal("failed to parse transaction result txhash=", txhash)
			}
			t.MustTrue(resp.Status == step.Output.TxResult.Status)
			if len(step.Output.TxResult.Message) > 0 {
				t.MustTrue(resp.Message == step.Output.TxResult.Message)
			}

			if resp.Message == "scheduled the recipe" { // delayed execution
				var scheduleRes handlers.ExecuteRecipeScheduleOutput

				err := json.Unmarshal(resp.Output, &scheduleRes)
				t.MustNil(err)
				execIDs[step.ID] = scheduleRes.ExecID
				for _, itemID := range ItemIDs {
					item, err := intTest.GetItemByGUID(itemID)
					t.MustNil(err)
					t.MustTrue(len(item.OwnerRecipeID) != 0)
				}
				t.Log("scheduled execution", scheduleRes.ExecID)
			} else { // straight execution
				t.Log("straight execution result output", string(resp.Output))
			}
		}
	}
}

func RunCreateTrade(step FixtureStep, t *testing.T) {

	if step.ParamsRef != "" {
		byteValue := ReadFile(step.ParamsRef, t)
		// translate sender from account name to account address
		newByteValue := UpdateSenderName(byteValue, t)
		// get item inputs from fileNames
		itemInputs := GetItemInputsFromBytes(newByteValue, t)
		var trdType types.Trade
		err := intTest.GetAminoCdc().UnmarshalJSON(newByteValue, &trdType)
		if err != nil {
			t.Fatal("error reading using GetAminoCdc ", trdType, string(newByteValue), err)
		}
		t.MustTrue(err == nil)

		// get ItemOutputs from ItemOutputNames
		itemOutputs := GetItemOutputsFromBytes(newByteValue, trdType.Sender.String(), t)

		createTrd := msgs.NewMsgCreateTrade(
			trdType.CoinInputs,
			itemInputs,
			trdType.CoinOutputs,
			itemOutputs,
			trdType.ExtraInfo,
			trdType.Sender,
		)
		t.Log("createTrd Msg=", createTrd)
		txhash := intTest.TestTxWithMsgWithNonce(t, createTrd, createTrd.Sender.String(), true)
		err = intTest.WaitForNextBlock()
		intTest.ErrValidation(t, "error while creating trade %+v", err)

		txHandleResBytes, err := intTest.WaitAndGetTxData(txhash, 3, t)

		CheckErrorOnTx(txhash, t)
		resp := handlers.CreateTradeResponse{}
		err = intTest.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
		t.Log("txhash=", txhash)
		intTest.ErrValidation(t, "error unmarshaling tx response %+v", err)
		t.MustTrue(resp.TradeID != "")
	}
}

func RunFulfillTrade(step FixtureStep, t *testing.T) {

	if step.ParamsRef != "" {
		byteValue := ReadFile(step.ParamsRef, t)
		// translate sender from account name to account address
		newByteValue := UpdateSenderName(byteValue, t)
		// translate extra info to trade id
		newByteValue = UpdateTradeExtraInfoToID(newByteValue, t)
		// translate itemNames to itemIDs
		ItemIDs := GetItemIDsFromNames(newByteValue, false, t)

		var trdType struct {
			TradeID string
			Sender  sdk.AccAddress
			ItemIDs []string `json:"ItemIDs"`
		}

		err := intTest.GetAminoCdc().UnmarshalJSON(newByteValue, &trdType)
		if err != nil {
			t.Fatal("error reading using GetAminoCdc ", trdType, err)
		}
		t.MustNil(err)

		ffTrdMsg := msgs.NewMsgFulfillTrade(trdType.TradeID, trdType.Sender, ItemIDs)
		txhash := intTest.TestTxWithMsgWithNonce(t, ffTrdMsg, trdType.Sender.String(), true)

		err = intTest.WaitForNextBlock()
		intTest.ErrValidation(t, "error waiting for fulfilling trade %+v", err)

		if len(step.Output.TxResult.ErrorLog) > 0 {
		} else {
			txHandleResBytes, err := intTest.WaitAndGetTxData(txhash, 3, t)
			t.MustNil(err)
			CheckErrorOnTx(txhash, t)
			resp := handlers.FulfillTradeResp{}
			err = intTest.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
			if err != nil {
				t.Fatal("failed to parse transaction result txhash=", txhash)
			}
			t.MustTrue(resp.Status == step.Output.TxResult.Status)
			if len(step.Output.TxResult.Message) > 0 {
				t.MustTrue(resp.Message == step.Output.TxResult.Message)
			}
		}
	}
}

func RunDisableTrade(step FixtureStep, t *testing.T) {

	if step.ParamsRef != "" {
		byteValue := ReadFile(step.ParamsRef, t)
		// translate sender from account name to account address
		newByteValue := UpdateSenderName(byteValue, t)
		// translate extra info to trade id
		newByteValue = UpdateTradeExtraInfoToID(newByteValue, t)

		var trdType struct {
			TradeID string
			Sender  sdk.AccAddress
		}

		err := intTest.GetAminoCdc().UnmarshalJSON(newByteValue, &trdType)
		if err != nil {
			t.Fatal("error reading using GetAminoCdc ", trdType, err)
		}
		t.MustNil(err)

		dsTrdMsg := msgs.NewMsgDisableTrade(trdType.TradeID, trdType.Sender)
		txhash := intTest.TestTxWithMsgWithNonce(t, dsTrdMsg, trdType.Sender.String(), true)

		err = intTest.WaitForNextBlock()
		intTest.ErrValidation(t, "error waiting for disabling trade %+v", err)

		if len(step.Output.TxResult.ErrorLog) > 0 {
		} else {
			txHandleResBytes, err := intTest.WaitAndGetTxData(txhash, 3, t)
			t.MustNil(err)
			CheckErrorOnTx(txhash, t)
			resp := handlers.DisableTradeResp{}
			err = intTest.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
			if err != nil {
				t.Fatal("failed to parse transaction result txhash=", txhash)
			}
			t.MustTrue(resp.Status == step.Output.TxResult.Status)
			if len(step.Output.TxResult.Message) > 0 {
				t.MustTrue(resp.Message == step.Output.TxResult.Message)
			}
		}
	}
}
