package main

import (
	"testing"

	"github.com/MikeSofaer/pylons/x/pylons/types"
)

func MockCookbook(t *testing.T) error {
	eugenAddr := GetAccountAddr("eugen", t)
	TestTxWithMsg(t, CreateCookbookMsgValueModel{
		Description:  "this has to meet character limits lol",
		Developer:    "SketchyCo",
		Level:        "0",
		Name:         "COOKBOOK_MOCK_001",
		Sender:       eugenAddr,
		SupportEmail: "example@example.com",
		Version:      "1.0.0",
	}, "pylons/CreateCookbook")
	return WaitForNextBlock()
}

func MockRecipe(t *testing.T) error {
	return MockRecipeWithName("Recipe00001", t)
}

func MockRecipeWithName(name string, t *testing.T) error {
	return MockDelayedExecutionRecipeWithName(0, name, t)
}

func MockDelayedExecutionRecipeWithName(interval int64, name string, t *testing.T) error {
	mCB, err := GetMockedCookbook()
	if err != nil {
		t.Errorf("error getting mocked cookbook %+v", err)
		t.Fatal(err)
	}
	eugenAddr := GetAccountAddr("eugen", t)
	TestTxWithMsg(t, CreateRecipeMsgValueModel{
		BlockInterval: interval,
		CoinInputs:    types.GenCoinInputList("pylon", 5),
		CookbookId:    mCB.ID,
		Description:   "this has to meet character limits lol",
		Entries:       types.GenItemOnlyEntry("Zombie"),
		ItemInputs:    types.ItemInputList{},
		RecipeName:    name,
		Sender:        eugenAddr,
	}, "pylons/CreateRecipe")
	return WaitForNextBlock()
}

func GetMockedCookbook() (CookbookListModel, error) {
	cbList, err := ListCookbookViaCLI()
	if err != nil {
		return CookbookListModel{}, err
	}
	return cbList[0], nil
}
