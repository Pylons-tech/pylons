package fixtureTest

import (
	"encoding/json"
	"errors"
	"io/ioutil"
	"os"
	"testing"

	intTest "github.com/MikeSofaer/pylons/cmd/test"
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
	ItemIDs  []string `json:"ItemIDs"`
}

type ExecRefReader struct {
	ExecRef int
}

type ItemInputsRefReader struct {
	ItemInputRefs []string
}

type NewOutputRefReader struct {
	Ref    string
	Weight int
}

type NewEntryReader struct {
	CoinOutputs []types.CoinOutput
	ItemOutputs []NewOutputRefReader
}

type NewEntriesReader struct {
	Entries NewEntryReader
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

func ReadFile(fileURL string, t *testing.T) []byte {
	jsonFile, err := os.Open(fileURL)
	if err != nil {
		t.Errorf("%+v", err)
	}

	defer jsonFile.Close()

	byteValue, _ := ioutil.ReadAll(jsonFile)
	return byteValue
}

func UpdateSenderName(bytes []byte, t *testing.T) []byte {
	var raw map[string]interface{}
	if err := json.Unmarshal(bytes, &raw); err != nil {
		t.Fatal("read raw file using json.Unmarshal:", err)
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
		t.Fatal("read raw file using json.Unmarshal:", err)
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
		t.Fatal("read raw file using json.Unmarshal:", err)
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
		t.Fatal("read execRef using json.Unmarshal:", err)
	}

	var raw map[string]interface{}
	if err := json.Unmarshal(bytes, &raw); err != nil {
		t.Fatal("read raw file using json.Unmarshal:", err)
	}
	// t.Log("bytes", string(bytes))
	// t.Log("raw parse", raw)
	execRef := execRefReader.ExecRef
	// t.Log("execRef", execRef, len(execIDs))
	var targetExecID string
	if execRef < 0 {
		if len(execIDs) == 0 {
			t.Fatal(errors.New("there's no active execID available"))
		}
		targetExecID = execIDs[len(execIDs)+execRef]
	} else {
		if len(execIDs) <= execRef {
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
		t.Fatal("read item names using json.Unmarshal:", err)
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

func GetItemInputsFromBytes(bytes []byte, t *testing.T) types.ItemInputList {
	var itemInputRefsReader ItemInputsRefReader
	if err := json.Unmarshal(bytes, &itemInputRefsReader); err != nil {
		t.Fatal("read itemInputRefsReader using json.Unmarshal:", err)
	}

	var itemInputs types.ItemInputList

	for _, iiRef := range itemInputRefsReader.ItemInputRefs {
		var ii types.ItemInput
		iiBytes := ReadFile(iiRef, t)
		err := intTest.GetAminoCdc().UnmarshalJSON(iiBytes, &ii)
		if err != nil {
			t.Fatal("error parsing item input provided via fixture error=", err)
		}
		t.Log("read item input result=", ii)

		itemInputs = append(itemInputs, ii)
	}
	return itemInputs
}

func GetEntriesFromBytes(bytes []byte, t *testing.T) types.WeightedParamList {
	var entriesReader NewEntriesReader
	if err := json.Unmarshal(bytes, &entriesReader); err != nil {
		t.Fatal("read entriesReader using json.Unmarshal:", err)
	}

	var wpl types.WeightedParamList
	for _, co := range entriesReader.Entries.CoinOutputs {
		wpl = append(wpl, co)
	}

	for _, io := range entriesReader.Entries.ItemOutputs {
		var pio types.ItemOutput // parsed item output
		ioBytes := ReadFile(io.Ref, t)
		err := json.Unmarshal(ioBytes, &pio)
		if err != nil {
			t.Fatal("error parsing item output provided via fixture Bytes=", string(ioBytes), "error=", err)
		}
		t.Log("read item output result=", pio)
		pio.Weight = io.Weight
		wpl = append(wpl, pio)
	}

	return wpl
}
