package intTest

import (
	"testing"

	"github.com/MikeSofaer/pylons/x/pylons/handlers"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	"github.com/MikeSofaer/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

///////////COOKBOOK//////////////////////////////////////////////

// MockCookbook mock a cookbook which can refer to on all tests
// currently there's no need to create more than 2 cookbooks
func MockCookbook(t *testing.T) (string, error) {
	guid, exist, err := CheckCookbookExist()
	if err != nil {
		return "", err
	}
	if exist { // finish mock if already available
		return guid, nil
	}
	eugenAddr := GetAccountAddr("eugen", t)
	sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
	require.True(t, err == nil)

	txhash := TestTxWithMsg(t, msgs.NewMsgCreateCookbook(
		"COOKBOOK_MOCK_001",
		"this has to meet character limits lol",
		"SketchyCo",
		"1.0.0",
		"example@example.com",
		0,
		msgs.DefaultCostPerBlock,
		sdkAddr))

	err = WaitForNextBlock()
	ErrValidation(t, "error waiting for creating cookbook %+v", err)

	txHandleResBytes, err := GetTxDetail(txhash, t)
	require.True(t, err == nil)
	resp := handlers.CreateCBResponse{}
	err = GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
	require.True(t, err == nil)

	return resp.CookbookID, nil
}

func CheckCookbookExist() (string, bool, error) {
	cbList, err := ListCookbookViaCLI()
	if err != nil {
		return "", false, err
	}
	if len(cbList) > 0 {
		return cbList[0].ID, true, nil
	}
	return "", false, nil
}

func GetMockedCookbook(t *testing.T) (types.Cookbook, error) {
	guid, err := MockCookbook(t)
	ErrValidation(t, "error mocking cookbook %+v", err)

	return GetCookbookByGUID(guid)
}

///////////RECIPE//////////////////////////////////////////////

func MockRecipeWithName(name string, outputItemName string, t *testing.T) (string, error) {
	return MockRecipeGUID(0, name, outputItemName, t)
}

func MockRecipeGUID(interval int64, name string, outputItemName string, t *testing.T) (string, error) {
	guid, err := GetRecipeGUIDFromName(name)
	ErrValidation(t, "error checking if recipe already exist %+v", err)

	if len(guid) > 0 { // finish mock if already available
		return guid, nil
	}

	mCB, err := GetMockedCookbook(t)
	ErrValidation(t, "error getting mocked cookbook %+v", err)

	eugenAddr := GetAccountAddr("eugen", t)
	sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
	require.True(t, err == nil)
	txhash := TestTxWithMsg(t,
		msgs.NewMsgCreateRecipe(
			name,
			mCB.ID,
			"this has to meet character limits lol",
			types.GenCoinInputList("pylon", 5),
			types.ItemInputList{},
			types.GenItemOnlyEntry(outputItemName),
			interval,
			sdkAddr))

	err = WaitForNextBlock()
	ErrValidation(t, "error waiting for creating recipe %+v", err)

	txHandleResBytes, err := GetTxDetail(txhash, t)
	require.True(t, err == nil)
	resp := handlers.CreateRecipeResponse{}
	err = GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
	require.True(t, err == nil)

	return resp.RecipeID, nil
}

func GetRecipeGUIDFromName(name string) (string, error) {
	rcpList, err := ListRecipesViaCLI()
	if err != nil {
		return "", err
	}
	rcp, _ := FindRecipeFromArrayByName(rcpList, name)
	return rcp.ID, nil
}
