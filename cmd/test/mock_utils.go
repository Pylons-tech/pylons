package main

import (
	"testing"

	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	"github.com/MikeSofaer/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
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
	sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
	require.True(t, err == nil)

	TestTxWithMsg(t, msgs.NewMsgCreateCookbook(
		"COOKBOOK_MOCK_001",
		"this has to meet character limits lol",
		"SketchyCo",
		"1.0.0",
		"example@example.com",
		0,
		msgs.DefaultCostPerBlock,
		sdkAddr))
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

func GetMockedCookbook(t *testing.T) (CookbookListModel, error) {
	err := MockCookbook(t)
	ErrValidation(t, "error mocking cookbook %+v", err)

	cbList, err := ListCookbookViaCLI()
	if err != nil {
		return CookbookListModel{}, err
	}
	return cbList[0], nil
}

///////////RECIPE//////////////////////////////////////////////

func MockRecipeWithName(name string, outputItemName string, t *testing.T) error {
	return MockDelayedExecutionRecipeWithName(0, name, outputItemName, t)
}

func MockDelayedExecutionRecipeWithName(interval int, name string, outputItemName string, t *testing.T) error {
	exist, err := CheckRecipeExistByName(name)
	ErrValidation(t, "error checking if recipe already exist %+v", err)

	if exist { // finish mock if already available
		return nil
	}
	mCB, err := GetMockedCookbook(t)
	ErrValidation(t, "error getting mocked cookbook %+v", err)

	eugenAddr := GetAccountAddr("eugen", t)
	sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
	require.True(t, err == nil)
	TestTxWithMsg(t,
		msgs.NewMsgCreateRecipe(
			name,
			mCB.ID,
			"this has to meet character limits lol",
			types.GenCoinInputList("pylon", 5),
			types.ItemInputList{},
			types.GenItemOnlyEntry(outputItemName),
			interval,
			sdkAddr))
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
