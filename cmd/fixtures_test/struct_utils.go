package fixtureTest

import (
	"encoding/json"
	"errors"
	"io/ioutil"
	"os"
	"sync"
	"testing"

	intTest "github.com/MikeSofaer/pylons/cmd/test"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

type ItemNamesReader struct {
	ItemNames []string
}

type ExecuteRecipeReader struct {
	RecipeID string
	Sender   sdk.AccAddress
	ItemIDs  []string `json:"ItemIDs"`
}

type ExecRefReader struct {
	ExecRef int
}
type CheckExecutionReader struct {
	ExecID        string
	PayToComplete bool
	Sender        sdk.AccAddress
}

type HumanReadableError struct {
	Codespace string `json:"codespace"`
	Code      int    `json:"code"`
	Message   string `json:"message"`
}

var execIDs = []string{}
var nonceMux sync.Mutex

func ReadFile(fileURL string, t *testing.T) []byte {
	jsonFile, err := os.Open(fileURL)
	if err != nil {
		t.Errorf("%+v", err)
	}
	// t.Log("Successfully Opened", fileURL)

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
	// t.Log("UpdateCookbookName ", raw["CookbookName"], cbName, ok)
	require.True(t, ok)
	cbID, exist, err := intTest.GetCookbookIDFromName(cbName, "")
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
	// t.Log("reading recipe with name", rcpName)
	rcpID, exist, err := intTest.GetRecipeIDFromName(rcpName)
	require.True(t, exist)
	require.True(t, err == nil)
	raw["RecipeID"] = rcpID
	newBytes, err := json.Marshal(raw)
	require.True(t, err == nil)
	// t.Log("remarshaling into json:", string(newBytes), err)
	return newBytes
}

func UpdateExecID(bytes []byte, t *testing.T) []byte {
	var execRefReader ExecRefReader
	if err := json.Unmarshal(bytes, &execRefReader); err != nil {
		t.Error("read execRef using json.Unmarshal:", err)
		t.Fatal(err)
	}

	var raw map[string]interface{}
	if err := json.Unmarshal(bytes, &raw); err != nil {
		t.Error("read raw file using json.Unmarshal:", err)
		t.Fatal(err)
	}
	// t.Log("bytes", string(bytes))
	// t.Log("raw parse", raw)
	execRef := execRefReader.ExecRef
	// t.Log("execRef", execRef, len(execIDs))
	var targetExecID string
	if execRef < 0 {
		if len(execIDs) == 0 {
			t.Errorf("there's no active execID available")
			t.Fatal(errors.New("there's no active execID available"))
		}
		targetExecID = execIDs[len(execIDs)+execRef]
	} else {
		if len(execIDs) <= execRef {
			t.Errorf("specified ExecRef is out of range")
			t.Fatal(errors.New("specified ExecRef is out of range"))
		}
		targetExecID = execIDs[execRef]
	}

	raw["ExecID"] = targetExecID
	newBytes, err := json.Marshal(raw)
	require.True(t, err == nil)
	// t.Log("remarshaling into json:", string(newBytes), err)
	return newBytes

}

func GetItemIDsFromNames(bytes []byte, t *testing.T) []string {
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
	return ItemIDs
}
