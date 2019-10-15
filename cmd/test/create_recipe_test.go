package main

import (
	"testing"

	"github.com/MikeSofaer/pylons/x/pylons/types"
)

type CreateRecipeMsgValueModel struct {
	BlockInterval int64 `json:",string"`
	CoinInputs    types.CoinInputList
	CookbookId    string
	Description   string
	Entries       types.WeightedParamList
	ItemInputs    types.ItemInputList
	RecipeName    string
	Sender        string
}

func TestCreateRecipeViaCLI(t *testing.T) {
	err := MockCookbook(t)
	if err != nil {
		t.Errorf("error mocking cookbook %+v", err)
		t.Fatal(err)
	}

	tests := []struct {
		name string
	}{
		{
			"basic flow test",
		},
	}

	mCB, err := GetMockedCookbook() // WaitForCookbookArrival(5)
	if err != nil {
		t.Errorf("error getting mocked cookbook %+v", err)
		t.Fatal(err)
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			eugenAddr := GetAccountAddr("eugen", t)
			TestTxWithMsg(t, CreateRecipeMsgValueModel{
				BlockInterval: 0,
				CoinInputs:    types.GenCoinInputList("wood", 5), // should use GenCoinInput
				CookbookId:    mCB.ID,                            // should use mocked ID
				Description:   "this has to meet character limits lol",
				Entries:       types.GenEntries("chair", "Raichu"), // use GenEntries
				ItemInputs:    types.GenItemInputList("Raichu"),    // use GenItem
				RecipeName:    "RCP_TestCreateRecipe_001",
				Sender:        eugenAddr,
			}, "pylons/CreateRecipe")
		})
	}
}
