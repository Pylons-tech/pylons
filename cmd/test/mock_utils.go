package main

import (
	"testing"

	"github.com/MikeSofaer/pylons/x/pylons/types"
)

///////////COOKBOOK//////////////////////////////////////////////

// MockCookbook mock a cookbook which can refer to on all tests
// currently there's no need to create more than 2 cookbooks
func MockCookbook(t *testing.T) error {
	exist, err := CheckCookbookExist()
	if err != nil {
		return err
	}
	if exist { // finish mock if already available
		return nil
	}
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

func CheckCookbookExist() (bool, error) {
	cbList, err := ListCookbookViaCLI()
	if err != nil {
		return false, err
	}
	if len(cbList) > 0 {
		return true, nil
	}
	return false, nil
}

func GetMockedCookbook() (CookbookListModel, error) {
	cbList, err := ListCookbookViaCLI()
	if err != nil {
		return CookbookListModel{}, err
	}
	return cbList[0], nil
}

///////////RECIPE//////////////////////////////////////////////

func MockRecipeWithName(name string, t *testing.T) error {
	return MockDelayedExecutionRecipeWithName(0, name, t)
}

func MockDelayedExecutionRecipeWithName(interval int64, name string, t *testing.T) error {
	exist, err := CheckRecipeExistByName(name)
	if err != nil {
		t.Errorf("error checking if recipe already exist %+v", err)
		t.Fatal(err)
	}
	if exist { // finish mock if already available
		return nil
	}
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

func CheckRecipeExistByName(name string) (bool, error) {
	rcpList, err := ListRecipesViaCLI()
	if err != nil {
		return false, err
	}
	_, exist := FindRecipeFromArrayByName(rcpList, name)
	return exist, nil
}
