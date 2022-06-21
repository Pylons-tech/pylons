package types

import (
	"fmt"
	"testing"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/stretchr/testify/require"
)

// TODO add tests
func TestEntryListsByIDsValid1(t *testing.T) {
	entryList := EntriesList{}

	recipe := Recipe{
		Entries: entryList,
	}

	idList := []string{}

	_, _, _, err := EntryListsByIDs(idList, recipe)
	require.NoError(t, err)
}

func TestEntryListsByIDsValid2(t *testing.T) {
	entryList := EntriesList{
		CoinOutputs: []CoinOutput{
			{
				Id:      "id1",
				Coin:    sdk.NewInt64Coin("coin", 10),
				Program: "",
			},
		},
		ItemOutputs: []ItemOutput{
			{
				Id: "id2",
			},
		},
		ItemModifyOutputs: []ItemModifyOutput{
			{
				Id: "id3",
			},
		},
	}

	recipe := Recipe{
		Entries: entryList,
	}

	idList := []string{"id1", "id2", "id3"}

	coinOutputs, itemOutputs, itemModifyOutputs, err := EntryListsByIDs(idList, recipe)
	require.NoError(t, err)
	require.Equal(t, entryList.CoinOutputs, coinOutputs)
	require.Equal(t, entryList.ItemOutputs[0].Id, itemOutputs[0].Id)
	require.Equal(t, entryList.ItemModifyOutputs, itemModifyOutputs)
}

func TestEntryListsByIDsValid3(t *testing.T) {
	entryList := EntriesList{
		CoinOutputs: []CoinOutput{
			{
				Id:      "id1",
				Coin:    sdk.NewInt64Coin("coin", 10),
				Program: "",
			},
		},
		ItemOutputs: []ItemOutput{
			{
				Id: "id2",
			},
		},
		ItemModifyOutputs: []ItemModifyOutput{
			{
				Id: "id3",
			},
		},
	}

	recipe := Recipe{
		Entries: entryList,
	}

	idList := []string{"id1", "id3"}

	coinOutputs, _, itemModifyOutputs, err := EntryListsByIDs(idList, recipe)
	require.NoError(t, err)
	require.Equal(t, entryList.CoinOutputs, coinOutputs)
	require.Equal(t, entryList.ItemModifyOutputs, itemModifyOutputs)
}

func TestEntryListsByIDsInvalid1(t *testing.T) {
	entryList := EntriesList{}

	recipe := Recipe{
		Entries: entryList,
	}

	idList := []string{"id"}

	_, _, _, err := EntryListsByIDs(idList, recipe)
	expected := fmt.Errorf("no entry with the ID %s available", idList[0])
	require.Contains(t, err.Error(), expected.Error())
}

func TestEntryListsByIDsInvalid2(t *testing.T) {
	entryList := EntriesList{
		CoinOutputs: []CoinOutput{
			{
				Id:      "id1",
				Coin:    sdk.NewInt64Coin("coin", 10),
				Program: "",
			},
		},
		ItemOutputs: []ItemOutput{
			{
				Id: "id4",
			},
		},
		ItemModifyOutputs: []ItemModifyOutput{
			{
				Id: "id3",
			},
		},
	}

	recipe := Recipe{
		Entries: entryList,
	}

	idList := []string{"id1", "id2", "id3"}

	_, _, _, err := EntryListsByIDs(idList, recipe)
	expected := fmt.Errorf("no entry with the ID %s available", idList[1])
	require.Contains(t, err.Error(), expected.Error())
}
