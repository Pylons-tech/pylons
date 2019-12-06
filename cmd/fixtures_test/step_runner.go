package fixtureTest

import (
	"encoding/json"

	testing "github.com/MikeSofaer/pylons/cmd/fixtures_test/evtesting"

	intTest "github.com/MikeSofaer/pylons/cmd/test"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"

	"github.com/MikeSofaer/pylons/x/pylons/handlers"
	"github.com/MikeSofaer/pylons/x/pylons/types"

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
		t.MustTrue(err == nil)

		chkExecMsg := msgs.NewMsgCheckExecution(
			execType.ExecID,
			execType.PayToComplete,
			execType.Sender,
		)
		txhash := intTest.TestTxWithMsgWithNonce(t, chkExecMsg, execType.Sender.String(), true)

		err = intTest.WaitForNextBlock()
		intTest.ErrValidation(t, "error waiting for creating recipe %+v", err)

		txHandleResBytes, err := intTest.WaitAndGetTxData(txhash, 10, t)
		t.MustTrue(err == nil)
		resp := handlers.CheckExecutionResp{}
		err = intTest.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)

		t.MustTrue(err == nil)
		t.MustTrue(resp.Status == step.Output.TxResult.Status)
		t.MustTrue(resp.Message == step.Output.TxResult.Message)
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
		t.MustTrue(err == nil)

		itmMsg := msgs.NewMsgFiatItem(
			itemType.CookbookID,
			itemType.Doubles,
			itemType.Longs,
			itemType.Strings,
			itemType.Sender,
		)
		txhash := intTest.TestTxWithMsgWithNonce(t, itmMsg, itemType.Sender.String(), true)

		err = intTest.WaitForNextBlock()
		intTest.ErrValidation(t, "error waiting for creating recipe %+v", err)

		txHandleResBytes, err := intTest.WaitAndGetTxData(txhash, 10, t)
		t.MustTrue(err == nil)
		resp := handlers.FiatItemResponse{}
		err = intTest.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)

		t.MustTrue(err == nil)
		t.MustTrue(resp.ItemID != "")
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
		t.MustTrue(err == nil)

		cbMsg := msgs.NewMsgCreateCookbook(
			cbType.Name,
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

		txHandleResBytes, err := intTest.WaitAndGetTxData(txhash, 10, t)

		intTest.ErrValidationWithOutputLog(t, "error getting transaction data for creating cookbook %+v", txHandleResBytes, err)
		resp := handlers.CreateCBResponse{}
		err = intTest.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
		t.MustTrue(err == nil)
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

		var rcpType types.Recipe
		err := intTest.GetAminoCdc().UnmarshalJSON(newByteValue, &rcpType)
		if err != nil {
			t.Fatal("error reading using GetAminoCdc ", rcpType, err)
		}
		t.MustTrue(err == nil)

		rcpMsg := msgs.NewMsgCreateRecipe(
			rcpType.Name,
			rcpType.CookbookID,
			rcpType.Description,
			rcpType.CoinInputs,
			itemInputs,
			entries,
			rcpType.BlockInterval,
			rcpType.Sender,
		)

		txhash := intTest.TestTxWithMsgWithNonce(t, rcpMsg, rcpType.Sender.String(), true)

		err = intTest.WaitForNextBlock()
		intTest.ErrValidation(t, "error waiting for creating recipe %+v", err)

		txHandleResBytes, err := intTest.WaitAndGetTxData(txhash, 10, t)
		t.MustTrue(err == nil)
		resp := handlers.CreateRecipeResponse{}
		err = intTest.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
		t.MustTrue(err == nil)
		t.MustTrue(resp.RecipeID != "")
	}
}

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
		t.MustTrue(err == nil)

		// t.Log("Executed recipe with below params", execType.RecipeID, execType.Sender, ItemIDs)
		execMsg := msgs.NewMsgExecuteRecipe(execType.RecipeID, execType.Sender, ItemIDs)
		txhash := intTest.TestTxWithMsgWithNonce(t, execMsg, execType.Sender.String(), true)

		err = intTest.WaitForNextBlock()
		intTest.ErrValidation(t, "error waiting for executing recipe %+v", err)

		txErrorBytes, err := intTest.GetTxError(txhash, t)
		if len(step.Output.TxResult.ErrorLog) > 0 {
			hmrErr := struct {
				Codespace string `json:"codespace"`
				Code      int    `json:"code"`
				Message   string `json:"message"`
			}{}
			err = json.Unmarshal(txErrorBytes, &hmrErr)
			t.MustTrue(err == nil)
			t.MustTrue(hmrErr.Message == step.Output.TxResult.ErrorLog)
		} else {
			txHandleResBytes, err := intTest.WaitAndGetTxData(txhash, 10, t)
			t.MustTrue(err == nil)
			resp := handlers.ExecuteRecipeResp{}
			err = intTest.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
			if err != nil {
				t.Fatal("failed to parse transaction result txhash=", txhash)
			}
			t.MustTrue(resp.Status == step.Output.TxResult.Status)
			t.MustTrue(resp.Message == step.Output.TxResult.Message)

			if resp.Message == "scheduled the recipe" { // delayed execution
				var scheduleRes handlers.ExecuteRecipeScheduleOutput

				err := json.Unmarshal(resp.Output, &scheduleRes)
				t.MustTrue(err == nil)
				execIDs[step.ID] = scheduleRes.ExecID
				for _, itemID := range ItemIDs {
					item, err := intTest.GetItemByGUID(itemID)
					t.MustTrue(err == nil)
					t.MustTrue(len(item.OwnerRecipeID) == 0)
				}
				t.Log("scheduled execution", scheduleRes.ExecID)
			} else { // straight execution
				t.Log("straight execution result output", string(resp.Output))
			}
		}
	}
}
