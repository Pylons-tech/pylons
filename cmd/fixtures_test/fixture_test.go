package fixtureTest

import (
	"encoding/json"
	"io/ioutil"
	"os"
	"testing"

	intTest "github.com/MikeSofaer/pylons/cmd/test"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"

	"github.com/MikeSofaer/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

type ItemNamesReader struct {
	ItemNames []string
}

type ExecuteRecipeReader struct {
	RecipeID string
	Sender   sdk.AccAddress
	ItemIDs  []string
}

func ReadFile(fileURL string, t *testing.T) []byte {
	jsonFile, err := os.Open(fileURL)
	if err != nil {
		t.Errorf("%+v", err)
	}
	t.Log("Successfully Opened", fileURL)

	defer jsonFile.Close()

	byteValue, _ := ioutil.ReadAll(jsonFile)
	return byteValue
}

func UpdateSenderName(bytes []byte, t *testing.T) []byte {
	var raw map[string]interface{}
	if err := json.Unmarshal(bytes, &raw); err != nil {
		t.Error("read raw file using json.Unmarshal:", err)
		t.Fatal(err)
	}
	senderName, ok := raw["Sender"].(string)
	require.True(t, ok)
	raw["Sender"] = intTest.GetAccountAddr(senderName, t)
	newBytes, err := json.Marshal(raw)
	require.True(t, err == nil)
	// t.Log("remarshaling into json:", string(newBytes), err)
	return newBytes
}

func UpdateCookbookName(bytes []byte, t *testing.T) []byte {
	var raw map[string]interface{}
	if err := json.Unmarshal(bytes, &raw); err != nil {
		t.Error("read raw file using json.Unmarshal:", err)
		t.Fatal(err)
	}
	cbName, ok := raw["CookbookName"].(string)
	t.Log("UpdateCookbookName ", raw["CookbookName"], cbName, ok)
	require.True(t, ok)
	cbID, exist, err := intTest.GetCookbookIDFromName(cbName)
	require.True(t, exist)
	require.True(t, err == nil)
	raw["CookbookID"] = cbID
	newBytes, err := json.Marshal(raw)
	require.True(t, err == nil)
	// t.Log("remarshaling into json:", string(newBytes), err)
	return newBytes
}

func UpdateRecipeName(bytes []byte, t *testing.T) []byte {
	var raw map[string]interface{}
	if err := json.Unmarshal(bytes, &raw); err != nil {
		t.Error("read raw file using json.Unmarshal:", err)
		t.Fatal(err)
	}
	rcpName, ok := raw["RecipeName"].(string)
	require.True(t, ok)
	rcpID, exist, err := intTest.GetRecipeIDFromName(rcpName)
	require.True(t, exist)
	require.True(t, err == nil)
	raw["RecipeID"] = rcpID
	newBytes, err := json.Marshal(raw)
	require.True(t, err == nil)
	// t.Log("remarshaling into json:", string(newBytes), err)
	return newBytes
}

func UpdateItemNames(bytes []byte, t *testing.T) []byte {
	var itemNamesResp ItemNamesReader
	if err := json.Unmarshal(bytes, &itemNamesResp); err != nil {
		t.Error("read item names using json.Unmarshal:", err)
		t.Fatal(err)
	}
	ItemIDs := []string{}

	for _, itemName := range itemNamesResp.ItemNames {
		itemID, exist, err := intTest.GetItemIDFromName(itemName)
		require.True(t, exist)
		require.True(t, err == nil)
		ItemIDs = append(ItemIDs, itemID)
	}
	var raw map[string]interface{}
	if err := json.Unmarshal(bytes, &raw); err != nil {
		t.Error("read raw file using json.Unmarshal:", err)
		t.Fatal(err)
	}
	raw["ItemIDs"] = ItemIDs
	newBytes, err := json.Marshal(raw)
	require.True(t, err == nil)
	// t.Log("remarshaling into json:", string(newBytes), err)
	return newBytes
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
		cbMsg := msgs.NewMsgCreateCookbook(cbType.Name, cbType.Description, cbType.Developer, cbType.Version, cbType.SupportEmail, cbType.Level, cbType.CostPerBlock, cbType.Sender)
		msgCCB, err := intTest.GetAminoCdc().MarshalJSON(cbMsg)
		t.Log("msgCCB, err:", string(msgCCB), err)
		intTest.TestTxWithMsg(t, cbMsg)
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
		rcpMsg := msgs.NewMsgCreateRecipe(rcpType.Name, rcpType.CookbookID, rcpType.Description, rcpType.CoinInputs, rcpType.ItemInputs, rcpType.Entries, rcpType.BlockInterval, rcpType.Sender)
		msgCRCP, err := intTest.GetAminoCdc().MarshalJSON(rcpMsg)
		t.Log("msgCRCP, err:", string(msgCRCP), err)
		intTest.TestTxWithMsg(t, rcpMsg)
	}
}

func RunExecuteRecipe(step FixtureStep, t *testing.T) {
	if step.ParamsRef != "" {
		// translate sender from account name to account address
		byteValue := ReadFile(step.ParamsRef, t)
		newByteValue := UpdateSenderName(byteValue, t)
		newByteValue = UpdateRecipeName(newByteValue, t)
		newByteValue = UpdateItemNames(newByteValue, t)

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
		execMsg := msgs.NewMsgExecuteRecipe(execType.RecipeID, execType.Sender, execType.ItemIDs)
		msgERCP, err := intTest.GetAminoCdc().MarshalJSON(execMsg)
		t.Log("msgCRCP, err:", string(msgERCP), err)
		intTest.TestTxWithMsg(t, execMsg)
	}
}
func TestFixturesViaCLI(t *testing.T) {

	var fixtureSteps []FixtureStep
	byteValue := ReadFile("scenario.json", t)
	json.Unmarshal([]byte(byteValue), &fixtureSteps)
	// t.Log("read steps:", fixtureSteps)

	for _, step := range fixtureSteps {
		switch step.Action {
		case "create_cookbook":
			RunCreateCookbook(step, t)
		case "create_recipe":
			RunCreateRecipe(step, t)
		case "execute_recipe":
			RunExecuteRecipe(step, t)
		default:
			t.Errorf("step with unrecognizable action found %s", step.Action)
		}
	}
}
