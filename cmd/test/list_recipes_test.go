package main

import (
	"testing"

	"github.com/MikeSofaer/pylons/x/pylons/types"
	"github.com/stretchr/testify/require"
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
	err = MockRecipe(t)
	if err != nil {
		t.Errorf("error mocking recipe %+v", err)
		t.Fatal(err)
	}

	tests := []struct {
		name string
	}{
		{
			"basic flow test",
		},
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			recipes := ListRecipesViaCLI()
			require.True(t, len(recipes) > 0)
		})
	}
}
