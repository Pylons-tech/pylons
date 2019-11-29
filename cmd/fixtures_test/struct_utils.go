package fixtureTest

import (
	"encoding/json"
	"io/ioutil"
	"os"
	"testing"

	intTest "github.com/MikeSofaer/pylons/cmd/test"
	"github.com/MikeSofaer/pylons/x/pylons/types"

	"github.com/stretchr/testify/require"
)

var execIDs map[string]string = make(map[string]string)

func ReadFile(fileURL string, t *testing.T) []byte {
	jsonFile, err := os.Open(fileURL)
	if err != nil {
		t.Errorf("%+v", err)
	}

	defer jsonFile.Close()

	byteValue, _ := ioutil.ReadAll(jsonFile)
	return byteValue
}

func UnmarshalIntoEmptyInterface(bytes []byte, t *testing.T) map[string]interface{} {
	var raw map[string]interface{}
	if err := json.Unmarshal(bytes, &raw); err != nil {
		t.Fatal("read raw file using json.Unmarshal:", err)
	}
	return raw
}

func UpdateSenderName(bytes []byte, t *testing.T) []byte {
	raw := UnmarshalIntoEmptyInterface(bytes, t)

	senderName, ok := raw["Sender"].(string)
	require.True(t, ok)
	raw["Sender"] = intTest.GetAccountAddr(senderName, t)
	newBytes, err := json.Marshal(raw)
	require.True(t, err == nil)
	// t.Log("remarshaling into json:", string(newBytes), err)
	return newBytes
}

func UpdateCookbookName(bytes []byte, t *testing.T) []byte {
	raw := UnmarshalIntoEmptyInterface(bytes, t)

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
	raw := UnmarshalIntoEmptyInterface(bytes, t)

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
	raw := UnmarshalIntoEmptyInterface(bytes, t)

	var execRefReader struct {
		ExecRef string
	}
	if err := json.Unmarshal(bytes, &execRefReader); err != nil {
		t.Fatal("read execRef using json.Unmarshal:", err)
	}

	var ok bool
	raw["ExecID"], ok = execIDs[execRefReader.ExecRef]
	if !ok {
		t.Fatal("execID not available for ref=", execRefReader.ExecRef)
	}
	newBytes, err := json.Marshal(raw)
	require.True(t, err == nil)
	return newBytes
}

func GetItemIDsFromNames(bytes []byte, t *testing.T) []string {
	var itemNamesResp struct {
		ItemNames []string
	}
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
	var itemInputRefsReader struct {
		ItemInputRefs []string
	}
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
		itemInputs = append(itemInputs, ii)
	}
	return itemInputs
}

func GetEntriesFromBytes(bytes []byte, t *testing.T) types.WeightedParamList {
	var entriesReader struct {
		Entries struct {
			CoinOutputs []types.CoinOutput
			ItemOutputs []struct {
				Ref    string
				Weight int
			}
		}
	}

	if err := json.Unmarshal(bytes, &entriesReader); err != nil {
		t.Fatal("read entriesReader using json.Unmarshal:", err)
	}

	var wpl types.WeightedParamList
	for _, co := range entriesReader.Entries.CoinOutputs {
		wpl = append(wpl, co)
	}

	for _, io := range entriesReader.Entries.ItemOutputs {
		var pio types.ItemOutput
		ioBytes := ReadFile(io.Ref, t)
		err := json.Unmarshal(ioBytes, &pio)
		if err != nil {
			t.Fatal("error parsing item output provided via fixture Bytes=", string(ioBytes), "error=", err)
		}
		pio.Weight = io.Weight
		wpl = append(wpl, pio)
	}

	return wpl
}
