package main

import (
	"testing"

	"github.com/MikeSofaer/pylons/x/pylons/types"
)

type CreateRecipeMsgValueModel struct {
	BlockInterval int64 `json:",string"`
	CoinInputs    types.CoinInputList
	CookbookID    string
	Description   string
	Entries       types.WeightedParamList
	ItemInputs    types.ItemInputList
	Name          string
	Sender        string
}

func TestCreateRecipeViaCLI(t *testing.T) {
	// TODO if we find a way to sign using sequence number between same blocks, this wait can be removed
	WaitForNextBlock()

	tests := []struct {
		name string
	}{
		{
			"basic flow test",
		},
	}

	mCB, err := GetMockedCookbook(t)
	ErrValidation(t, "error getting mocked cookbook %+v", err)

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			eugenAddr := GetAccountAddr("eugen", t)
			TestTxWithMsg(t, CreateRecipeMsgValueModel{
				BlockInterval: 0,
				CoinInputs:    types.GenCoinInputList("wood", 5), // should use GenCoinInput
				CookbookID:    mCB.ID,                            // should use mocked ID
				Description:   "this has to meet character limits lol",
				Entries:       types.GenEntries("chair", "Raichu"), // use GenEntries
				ItemInputs:    types.GenItemInputList("Raichu"),    // use GenItem
				Name:          "Recipe00001",
				Sender:        eugenAddr,
			}, "pylons/CreateRecipe")
		})
	}
}
