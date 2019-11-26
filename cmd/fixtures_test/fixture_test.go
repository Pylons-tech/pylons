package fixtureTest

import (
	"encoding/json"
	"os"
	"path/filepath"
	"strings"
	"testing"

	intTest "github.com/MikeSofaer/pylons/cmd/test"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"

	"github.com/MikeSofaer/pylons/x/pylons/handlers"
	"github.com/MikeSofaer/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/stretchr/testify/require"
)

func PropertyExistCheck(step FixtureStep, t *testing.T) {

	pCheck := step.Output.Property
	var pOwnerAddr string
	if len(pCheck.Owner) == 0 {
		pOwnerAddr = ""
	} else {
		pOwnerAddr = intTest.GetAccountAddr(pCheck.Owner, t)
	}
	if len(pCheck.Cookbooks) > 0 {
		for _, cbName := range pCheck.Cookbooks {
			// t.Log("Checking cookbook exist with name=", cbName, "owner=", pOwnerAddr)
			_, exist, err := intTest.GetCookbookIDFromName(cbName, pOwnerAddr)
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
		for _, rcpName := range pCheck.Recipes {
			// t.Log("Checking recipe exist with name=", rcpName, "id=", idx)
			guid, err := intTest.GetRecipeGUIDFromName(rcpName, pOwnerAddr)
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
		for _, itemCheck := range pCheck.Items {
			fitItemExist := false
			// t.Log("Checking item with spec=", itemCheck, "id=", idx)
			items, err := intTest.ListItemsViaCLI(pOwnerAddr)
			intTest.ErrValidation(t, "error listing items %+v", err)
			for _, item := range items {
				if !CheckItemWithStringKeys(item, itemCheck.StringKeys) {
					continue
				}
				if !CheckItemWithStringValues(item, itemCheck.StringValues) {
					continue
				}
				if !CheckItemWithDblKeys(item, itemCheck.DblKeys) {
					continue
				}
				if !CheckItemWithDblValues(item, itemCheck.DblValues) {
					continue
				}
				if !CheckItemWithLongKeys(item, itemCheck.LongKeys) {
					continue
				}
				if !CheckItemWithLongValues(item, itemCheck.LongValues) {
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
		for _, coinCheck := range pCheck.Coins {
			accInfo := intTest.GetAccountInfoFromName(pCheck.Owner, t)
			require.True(t, accInfo.Coins.AmountOf(coinCheck.Coin).GTE(sdk.NewInt(coinCheck.Amount)))
		}
	}
}
func RunBlockWait(step FixtureStep, t *testing.T) {
	intTest.WaitForBlockInterval(step.BlockInterval)
}

func RunCheckExecution(step FixtureStep, t *testing.T) {

	if step.ParamsRef != "" {
		byteValue := ReadFile(step.ParamsRef, t)
		// translate sender from account name to account address
		newByteValue := UpdateSenderName(byteValue, t)
		// translate execRef to execID
		newByteValue = UpdateExecID(newByteValue, t)

		var execType CheckExecutionReader
		err := intTest.GetAminoCdc().UnmarshalJSON(newByteValue, &execType)
		if err != nil {
			t.Error("error reading using GetAminoCdc ", execType, err)
			t.Fatal(err)
		}
		require.True(t, err == nil)

		chkExecMsg := msgs.NewMsgCheckExecution(
			execType.ExecID,
			execType.PayToComplete,
			execType.Sender,
		)
		txhash := intTest.TestTxWithMsgWithNonce(t, chkExecMsg, execType.Sender.String(), &nonceMux)

		err = intTest.WaitForNextBlock()
		intTest.ErrValidation(t, "error waiting for creating recipe %+v", err)

		txHandleResBytes, err := intTest.WaitAndGetTxData(txhash, 10, t)
		require.True(t, err == nil)
		resp := handlers.CheckExecutionResp{}
		err = intTest.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)

		require.True(t, err == nil)
		require.True(t, resp.Status == step.Output.TxResult.Status)
		require.True(t, resp.Message == step.Output.TxResult.Message)
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
			t.Error("error reading using GetAminoCdc ", itemType, err)
			t.Fatal(err)
		}
		require.True(t, err == nil)

		itmMsg := msgs.NewMsgFiatItem(
			itemType.CookbookID,
			itemType.Doubles,
			itemType.Longs,
			itemType.Strings,
			itemType.Sender,
		)
		txhash := intTest.TestTxWithMsgWithNonce(t, itmMsg, itemType.Sender.String(), &nonceMux)

		err = intTest.WaitForNextBlock()
		intTest.ErrValidation(t, "error waiting for creating recipe %+v", err)

		txHandleResBytes, err := intTest.WaitAndGetTxData(txhash, 10, t)
		require.True(t, err == nil)
		resp := handlers.FiatItemResponse{}
		err = intTest.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)

		require.True(t, err == nil)
		require.True(t, resp.ItemID != "")
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
			t.Error("error reading using GetAminoCdc ", cbType, string(newByteValue), err)
			t.Fatal(err)
		}
		require.True(t, err == nil)

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

		txhash := intTest.TestTxWithMsgWithNonce(t, cbMsg, cbType.Sender.String(), &nonceMux)

		err = intTest.WaitForNextBlock()
		intTest.ErrValidation(t, "error waiting for creating cookbook %+v", err)

		txHandleResBytes, err := intTest.WaitAndGetTxData(txhash, 10, t)

		intTest.ErrValidationWithOutputLog(t, "error getting transaction data for creating cookbook %+v", txHandleResBytes, err)
		resp := handlers.CreateCBResponse{}
		err = intTest.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
		require.True(t, err == nil)
		require.True(t, resp.CookbookID != "")
	}
}

func RunCreateRecipe(step FixtureStep, t *testing.T) {
	if step.ParamsRef != "" {
		byteValue := ReadFile(step.ParamsRef, t)
		// translate sender from account name to account address
		newByteValue := UpdateSenderName(byteValue, t)
		// translate cookbook name to cookbook id
		newByteValue = UpdateCookbookName(newByteValue, t)
		// get ItemInputs from ItemInputRefs
		itemInputs := GetItemInputsFromBytes(newByteValue, t)
		entries := GetEntriesFromBytes(newByteValue, t)

		var rcpType types.Recipe
		err := intTest.GetAminoCdc().UnmarshalJSON(newByteValue, &rcpType)
		if err != nil {
			t.Error("error reading using GetAminoCdc ", rcpType, err)
			t.Fatal(err)
		}
		require.True(t, err == nil)

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

		txhash := intTest.TestTxWithMsgWithNonce(t, rcpMsg, rcpType.Sender.String(), &nonceMux)

		err = intTest.WaitForNextBlock()
		intTest.ErrValidation(t, "error waiting for creating recipe %+v", err)

		txHandleResBytes, err := intTest.WaitAndGetTxData(txhash, 10, t)
		require.True(t, err == nil)
		resp := handlers.CreateRecipeResponse{}
		err = intTest.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
		require.True(t, err == nil)
		require.True(t, resp.RecipeID != "")
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
		ItemIDs := GetItemIDsFromNames(newByteValue, t)

		var execType ExecuteRecipeReader
		err := intTest.GetAminoCdc().UnmarshalJSON(newByteValue, &execType)
		if err != nil {
			t.Error("error reading using GetAminoCdc ", execType, err)
			t.Fatal(err)
		}
		require.True(t, err == nil)

		// t.Log("Executed recipe with below params", execType.RecipeID, execType.Sender, ItemIDs)
		execMsg := msgs.NewMsgExecuteRecipe(execType.RecipeID, execType.Sender, ItemIDs)
		txhash := intTest.TestTxWithMsgWithNonce(t, execMsg, execType.Sender.String(), &nonceMux)

		err = intTest.WaitForNextBlock()
		intTest.ErrValidation(t, "error waiting for executing recipe %+v", err)

		txErrorBytes, err := intTest.GetTxError(txhash, t)
		if len(step.Output.TxResult.ErrorLog) > 0 {
			hmrErr := HumanReadableError{}
			err = json.Unmarshal(txErrorBytes, &hmrErr)
			require.True(t, err == nil)
			require.True(t, hmrErr.Message == step.Output.TxResult.ErrorLog)
		} else {
			txHandleResBytes, err := intTest.WaitAndGetTxData(txhash, 10, t)
			require.True(t, err == nil)
			resp := handlers.ExecuteRecipeResp{}
			err = intTest.GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
			if err != nil {
				t.Fatal("failed to parse transaction result txhash=", txhash)
			}
			require.True(t, resp.Status == step.Output.TxResult.Status)
			require.True(t, resp.Message == step.Output.TxResult.Message)

			if resp.Message == "scheduled the recipe" { // delayed execution
				var scheduleRes handlers.ExecuteRecipeScheduleOutput

				err := json.Unmarshal(resp.Output, &scheduleRes)
				require.True(t, err == nil)
				execIDs = append(execIDs, scheduleRes.ExecID)
				t.Log("scheduled execution", scheduleRes.ExecID)
			} else { // straight execution
				t.Log("straight execution result output", string(resp.Output))
			}
		}
	}
}

func RunSingleFixtureTest(file string, t *testing.T) {
	var fixtureSteps []FixtureStep
	byteValue := ReadFile(file, t)
	json.Unmarshal([]byte(byteValue), &fixtureSteps)

	for idx, step := range fixtureSteps {
		t.Log("Running file=", file, "step_id=", idx)
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

func TestFixturesViaCLI(t *testing.T) {
	var files []string

	scenario_directory := "scenarios"
	err := filepath.Walk(scenario_directory, func(path string, info os.FileInfo, err error) error {
		files = append(files, path)
		return nil
	})
	if err != nil {
		t.Error(err)
		t.Fatal(err)
	}
	for _, file := range files {
		if filepath.Ext(file) != ".json" {
			continue
		}
		t.Run(file, func(t *testing.T) {
			t.Parallel()
			testFile := strings.Replace(t.Name(), "TestFixturesViaCLI/", "", -1)
			t.Log("Running scenario path=", testFile)
			RunSingleFixtureTest(testFile, t)
		})
	}
}
