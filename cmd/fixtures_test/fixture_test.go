package fixtureTest

import (
	"encoding/json"
	"testing"

	intTest "github.com/MikeSofaer/pylons/cmd/test"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"

	"github.com/MikeSofaer/pylons/x/pylons/handlers"
	"github.com/MikeSofaer/pylons/x/pylons/types"

	"github.com/stretchr/testify/require"
)

func CheckItemWithStringKeys(item types.Item, stringKeys []string) bool {
	for _, sK := range stringKeys {
		keyExist := false
		for _, sKV := range item.Strings {
			if sK == sKV.Key {
				keyExist = true
			}
		}
		if !keyExist {
			return false
		}
	}
	return true
}

func CheckItemWithStringValues(item types.Item, stringValues map[string]string) bool {
	for sK, sV := range stringValues {
		keyExist := false
		for _, sKV := range item.Strings {
			if sK == sKV.Key && sV == sKV.Value {
				keyExist = true
			}
		}
		if !keyExist {
			return false
		}
	}
	return true
}

func CheckItemWithDblKeys(item types.Item, dblKeys []string) bool {
	for _, sK := range dblKeys {
		keyExist := false
		for _, sKV := range item.Doubles {
			if sK == sKV.Key {
				keyExist = true
			}
		}
		if !keyExist {
			return false
		}
	}
	return true
}

func CheckItemWithDblValues(item types.Item, dblValues map[string]types.FloatString) bool {
	for sK, sV := range dblValues {
		keyExist := false
		for _, sKV := range item.Doubles {
			if sK == sKV.Key && sV == sKV.Value {
				keyExist = true
			}
		}
		if !keyExist {
			return false
		}
	}
	return true
}

func CheckItemWithLongKeys(item types.Item, longKeys []string) bool {
	for _, sK := range longKeys {
		keyExist := false
		for _, sKV := range item.Longs {
			if sK == sKV.Key {
				keyExist = true
			}
		}
		if !keyExist {
			return false
		}
	}
	return true
}

func CheckItemWithLongValues(item types.Item, longValues map[string]int) bool {
	for sK, sV := range longValues {
		keyExist := false
		for _, sKV := range item.Longs {
			if sK == sKV.Key && sV == sKV.Value {
				keyExist = true
			}
		}
		if !keyExist {
			return false
		}
	}
	return true
}

func PropertyExistCheck(step FixtureStep, t *testing.T) {

	pCheck := step.Output.Property
	if len(pCheck.Cookbooks) > 0 {
		for idx, cbName := range pCheck.Cookbooks {
			t.Log("Checking cookbook exist with name=", cbName, "id=", idx)
			_, exist, err := intTest.CheckCookbookExist() // TODO should check by name
			if err != nil {
				t.Error("error checking cookbook exist", err)
				t.Fatal(err)
			}
			if exist {
				t.Log("checked existance")
			} else {
				t.Error("cookbook with name=", cbName, "does not exist")
				t.Fatal("cookbook does not exist")
			}
		}
	}
	if len(pCheck.Recipes) > 0 {
		for idx, rcpName := range pCheck.Recipes {
			t.Log("Checking cookbook exist with name=", rcpName, "id=", idx)
			guid, err := intTest.GetRecipeGUIDFromName(rcpName)
			intTest.ErrValidation(t, "error checking if recipe already exist %+v", err)

			if len(guid) > 0 {
				t.Log("checked existance")
			} else {
				t.Error("recipe with name=", rcpName, "does not exist")
				t.Fatal("recipe does not exist")
			}
		}
	}
	if len(pCheck.Items) > 0 {
		for idx, itemCheck := range pCheck.Items {
			fitItemExist := false
			t.Log("Checking item with spec=", itemCheck, "id=", idx)
			items, err := intTest.ListItemsViaCLI()
			intTest.ErrValidation(t, "error listing items %+v", err)
			for _, item := range items {
				ok := CheckItemWithStringKeys(item, itemCheck.StringKeys)
				t.Log("CheckItemWithStringKeys check", ok)
				if !ok {
					continue
				}
				ok = CheckItemWithStringValues(item, itemCheck.StringValues)
				t.Log("CheckItemWithStringValues check", ok)
				if !ok {
					continue
				}
				ok = CheckItemWithDblKeys(item, itemCheck.DblKeys)
				t.Log("CheckItemWithDblKeys check", ok)
				if !ok {
					continue
				}
				ok = CheckItemWithDblValues(item, itemCheck.DblValues)
				t.Log("CheckItemWithDblValues check", ok)
				if !ok {
					continue
				}
				ok = CheckItemWithLongKeys(item, itemCheck.LongKeys)
				t.Log("CheckItemWithLongKeys check", ok)
				if !ok {
					continue
				}
				ok = CheckItemWithLongValues(item, itemCheck.LongValues)
				t.Log("CheckItemWithLongValues check", ok)
				if !ok {
					continue
				}
				fitItemExist = true
			}
			intTest.ErrValidation(t, "error checking items with string keys %+v", err)

			if fitItemExist {
				t.Log("checked item existence")
			} else {
				t.Error("no item exist which fit item spec")
				t.Fatal("no item exist which fit item spec")
			}
		}
	}
	if len(pCheck.Coins) > 0 {

	}
}
func RunBlockWait(step FixtureStep, t *testing.T) {
	intTest.WaitForBlockInterval(step.BlockInterval)
}

func RunCheckExecution(step FixtureStep, t *testing.T) {

	if step.ParamsRef != "" {
		// translate sender from account name to account address
		byteValue := ReadFile(step.ParamsRef, t)
		newByteValue := UpdateSenderName(byteValue, t)
		newByteValue = UpdateExecID(newByteValue, t)

		// read correct version using amino codec
		var execType CheckExecutionReader
		err := intTest.GetAminoCdc().UnmarshalJSON(newByteValue, &execType)
		if err != nil {
			t.Error("error reading using GetAminoCdc ", execType, err)
			t.Fatal(err)
		}
		require.True(t, err == nil)
		// t.Log("read item file:", itemType, err)

		// convert to msg from type
		// This is needed b/c this msg is registered as "type":"pylons/MsgCheckExecution"
		chkExecMsg := msgs.NewMsgCheckExecution(
			execType.ExecID,
			execType.PayToComplete,
			execType.Sender,
		)
		// msgFITEM, err := intTest.GetAminoCdc().MarshalJSON(chkExecMsg)
		// t.Log("msgFITEM, err:", string(msgFITEM), err)
		txhash := intTest.TestTxWithMsg(t, chkExecMsg)

		err = intTest.WaitForNextBlock()
		intTest.ErrValidation(t, "error waiting for creating recipe %+v", err)

		txHandleResBytes, err := intTest.GetTxData(txhash, t)
		require.True(t, err == nil)
		resp := handlers.CheckExecutionResp{}
		err = intTest.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
		// t.Log("MsgCheckExecution, response and err", resp, err)
		require.True(t, err == nil)
		require.True(t, resp.Status == step.Output.TxResult.Status)
		require.True(t, resp.Message == step.Output.TxResult.Message)
	}
}

func RunFiatItem(step FixtureStep, t *testing.T) {
	// TODO should check item ID is returned
	// TODO when items are generated, rather than returning whole should return only ID [if multiple, array of item IDs]
	// TODO should check error is not happened by using txhash on all steps

	if step.ParamsRef != "" {
		// translate sender from account name to account address
		byteValue := ReadFile(step.ParamsRef, t)
		newByteValue := UpdateSenderName(byteValue, t)
		newByteValue = UpdateCookbookName(newByteValue, t)

		// read correct version using amino codec
		var itemType types.Item
		err := intTest.GetAminoCdc().UnmarshalJSON(newByteValue, &itemType)
		if err != nil {
			t.Error("error reading using GetAminoCdc ", itemType, err)
			t.Fatal(err)
		}
		require.True(t, err == nil)
		// t.Log("read item file:", itemType, err)

		// convert to msg from type
		// This is needed b/c this msg is registered as "type":"pylons/FiatItem"
		itmMsg := msgs.NewMsgFiatItem(
			itemType.CookbookID,
			itemType.Doubles,
			itemType.Longs,
			itemType.Strings,
			itemType.Sender,
		)
		// msgFITEM, err := intTest.GetAminoCdc().MarshalJSON(itmMsg)
		// t.Log("msgFITEM, err:", string(msgFITEM), err)
		txhash := intTest.TestTxWithMsg(t, itmMsg)

		err = intTest.WaitForNextBlock()
		intTest.ErrValidation(t, "error waiting for creating recipe %+v", err)

		txHandleResBytes, err := intTest.GetTxData(txhash, t)
		require.True(t, err == nil)
		resp := handlers.FiatItemResponse{}
		err = intTest.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
		// t.Log("FiatITEM, response and err", resp, err)
		require.True(t, err == nil)
		require.True(t, resp.ItemID != "")
	}
}

func RunCreateCookbook(step FixtureStep, t *testing.T) {
	if step.ParamsRef != "" {
		// translate sender from account name to account address
		byteValue := ReadFile(step.ParamsRef, t)
		newByteValue := UpdateSenderName(byteValue, t)

		// read correct version using amino codec
		var cbType types.Cookbook
		err := intTest.GetAminoCdc().UnmarshalJSON(newByteValue, &cbType)
		if err != nil {
			t.Error("error reading using GetAminoCdc ", cbType, err)
			t.Fatal(err)
		}
		require.True(t, err == nil)
		// t.Log("read cookbook file:", cbType, err)

		// convert to msg from type
		// This is needed b/c this msg is registered as "type":"pylons/CreateCookbook"
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

		// msgCCB, err := intTest.GetAminoCdc().MarshalJSON(cbMsg)
		// t.Log("msgCCB, err:", string(msgCCB), err)
		txhash := intTest.TestTxWithMsg(t, cbMsg)

		err = intTest.WaitForNextBlock()
		intTest.ErrValidation(t, "error waiting for creating cookbook %+v", err)

		txHandleResBytes, err := intTest.GetTxData(txhash, t)
		// t.Log("error getting response from txhash", txhash, string(txHandleResBytes), err)
		require.True(t, err == nil)
		resp := handlers.CreateCBResponse{}
		err = intTest.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
		require.True(t, err == nil)
		require.True(t, resp.CookbookID != "")
	}
}

func RunCreateRecipe(step FixtureStep, t *testing.T) {
	if step.ParamsRef != "" {
		// translate sender from account name to account address
		byteValue := ReadFile(step.ParamsRef, t)
		newByteValue := UpdateSenderName(byteValue, t)
		newByteValue = UpdateCookbookName(newByteValue, t)

		// read correct version using amino codec
		var rcpType types.Recipe
		err := intTest.GetAminoCdc().UnmarshalJSON(newByteValue, &rcpType)
		if err != nil {
			t.Error("error reading using GetAminoCdc ", rcpType, err)
			t.Fatal(err)
		}
		require.True(t, err == nil)
		// t.Log("read recipe file:", rcpType, err)

		// convert to msg from type
		// This is needed b/c this msg is registered as "type":"pylons/CreateRecipe"
		rcpMsg := msgs.NewMsgCreateRecipe(
			rcpType.Name,
			rcpType.CookbookID,
			rcpType.Description,
			rcpType.CoinInputs,
			rcpType.ItemInputs,
			rcpType.Entries,
			rcpType.BlockInterval,
			rcpType.Sender,
		)
		// msgCRCP, err := intTest.GetAminoCdc().MarshalJSON(rcpMsg)
		// t.Log("msgCRCP, err:", string(msgCRCP), err)
		txhash := intTest.TestTxWithMsg(t, rcpMsg)

		err = intTest.WaitForNextBlock()
		intTest.ErrValidation(t, "error waiting for creating recipe %+v", err)

		txHandleResBytes, err := intTest.GetTxData(txhash, t)
		require.True(t, err == nil)
		resp := handlers.CreateRecipeResponse{}
		err = intTest.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
		// t.Log("CreateRCP, response and err", resp, err)
		require.True(t, err == nil)
		require.True(t, resp.RecipeID != "")
		// t.Log("created recipe", resp.RecipeID, rcpType.Name)
	}
}

func RunExecuteRecipe(step FixtureStep, t *testing.T) {
	if step.ParamsRef != "" {
		// t.Log("Running RunExecuteRecipe ...")
		// translate sender from account name to account address
		byteValue := ReadFile(step.ParamsRef, t)
		newByteValue := UpdateSenderName(byteValue, t)
		newByteValue = UpdateRecipeName(newByteValue, t)
		ItemIDs := GetItemIDsFromNames(newByteValue, t)

		// t.Log("RunExecuteRecipe.UpdateItemNames:", string(newByteValue))

		var execType ExecuteRecipeReader
		err := intTest.GetAminoCdc().UnmarshalJSON(newByteValue, &execType)
		if err != nil {
			t.Error("error reading using GetAminoCdc ", execType, err)
			t.Fatal(err)
		}
		require.True(t, err == nil)
		// t.Log("read execute_recipe file:", execType, err)

		// convert to msg from type
		// This is needed b/c this msg is registered as "type":"pylons/CreateRecipe"
		execMsg := msgs.NewMsgExecuteRecipe(execType.RecipeID, execType.Sender, ItemIDs)
		// msgERCP, err := intTest.GetAminoCdc().MarshalJSON(execMsg)
		// t.Log("msgERCP, err:", string(msgERCP), err)
		txhash := intTest.TestTxWithMsg(t, execMsg)

		err = intTest.WaitForNextBlock()
		intTest.ErrValidation(t, "error waiting for executing recipe %+v", err)

		txErrorBytes, err := intTest.GetTxError(txhash, t)
		if len(step.Output.TxResult.ErrorLog) > 0 {
			hmrErr := HumanReadableError{}
			err = json.Unmarshal(txErrorBytes, &hmrErr)
			// t.Log("hmrErr.Message", hmrErr.Message, "step.Output.TxResult.ErrorLog", step.Output.TxResult.ErrorLog)
			require.True(t, err == nil)
			require.True(t, hmrErr.Message == step.Output.TxResult.ErrorLog)
		} else {
			txHandleResBytes, err := intTest.GetTxData(txhash, t)
			// t.Log("getting response from txhash", txhash, string(txHandleResBytes), err)
			require.True(t, err == nil)
			resp := handlers.ExecuteRecipeResp{}
			err = intTest.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
			// t.Log("ExecuteRCP, response and err", string(txHandleResBytes), resp, err)
			require.True(t, err == nil)
			require.True(t, resp.Status == step.Output.TxResult.Status)
			require.True(t, resp.Message == step.Output.TxResult.Message)

			// t.Log("ExecuteRCP, response and err", string(txHandleResBytes), resp, err)

			if resp.Message == "scheduled the recipe" { // delayed execution
				var scheduleRes handlers.ExecuteRecipeScheduleOutput

				err := json.Unmarshal(resp.Output, &scheduleRes)
				require.True(t, err == nil)
				execIDs = append(execIDs, scheduleRes.ExecID)
				// t.Log("scheduled execution", scheduleRes.ExecID)
			} else { // straight execution
				// TODO: should add checker to check items/coins are really generated
			}
		}
		// t.Log("Finished RunExecuteRecipe ...")
	}
}
func TestFixturesViaCLI(t *testing.T) {

	var fixtureSteps []FixtureStep
	byteValue := ReadFile("scenario.json", t)
	json.Unmarshal([]byte(byteValue), &fixtureSteps)
	// t.Log("read steps:", fixtureSteps)

	for idx, step := range fixtureSteps {
		t.Log("Running step id=", idx, step)
		switch step.Action {
		case "fiat_item":
			RunFiatItem(step, t)
			PropertyExistCheck(step, t)
		case "create_cookbook":
			RunCreateCookbook(step, t)
			PropertyExistCheck(step, t)
		case "create_recipe":
			RunCreateRecipe(step, t)
			PropertyExistCheck(step, t)
		case "execute_recipe":
			RunExecuteRecipe(step, t)
			PropertyExistCheck(step, t)
		case "block_wait":
			RunBlockWait(step, t)
			PropertyExistCheck(step, t)
		case "check_execution":
			RunCheckExecution(step, t)
			PropertyExistCheck(step, t)
		default:
			t.Errorf("step with unrecognizable action found %s", step.Action)
		}
	}
}
