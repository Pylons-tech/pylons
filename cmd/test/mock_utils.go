package intTest

import (
	testing "github.com/Pylons-tech/pylons/cmd/fixtures_test/evtesting"

	"github.com/Pylons-tech/pylons/x/pylons/handlers"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
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
	t.MustNil(err)

	txhash := TestTxWithMsgWithNonce(t, msgs.NewMsgCreateCookbook(
		"COOKBOOK_MOCK_001",
		"",
		"this has to meet character limits lol",
		"SketchyCo",
		"1.0.0",
		"example@example.com",
		0,
		msgs.DefaultCostPerBlock,
		sdkAddr),
		"eugen",
		false,
	)

	err = WaitForNextBlock()
	ErrValidation(t, "error waiting for creating cookbook %+v", err)

	txHandleResBytes, err := GetTxData(txhash, t)
	t.MustNil(err)
	resp := handlers.CreateCBResponse{}
	err = GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
	t.MustNil(err)

	return resp.CookbookID, nil
}

func CheckCookbookExist() (string, bool, error) {
	cbList, err := ListCookbookViaCLI("")
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

func MockNoDelayItemGenRecipeGUID(name string, outputItemName string, t *testing.T) (string, error) {
	return MockRecipeGUID(0, types.GENERATION, name, "", outputItemName, t)
}

func MockRecipeGUID(interval int64, rcpType types.RecipeType, name, curItemName, desItemName string, t *testing.T) (string, error) {
	if rcpType == types.GENERATION {
		return MockDetailedRecipeGUID(name, rcpType,
			types.GenCoinInputList("pylon", 5),
			types.ItemInputList{}, types.GenItemOnlyEntry(desItemName),
			types.ItemUpgradeParams{},
			interval,
			t,
		)
	} else { // UPGRADE recipe
		return MockDetailedRecipeGUID(name, rcpType,
			types.GenCoinInputList("pylon", 5),
			types.GenSingleItemInputList(curItemName),
			types.WeightedParamList{},
			types.GenItemNameUpgradeParams(desItemName),
			interval,
			t,
		)
	}
}

func MockPopularRecipeGUID(hfrt handlers.PopularRecipeType,
	rcpName string,
	t *testing.T,
) (string, error) {
	rcpType, ciL, iiL, entries, upgrades, bI := handlers.GetParamsForPopularRecipe(hfrt)
	return MockDetailedRecipeGUID(rcpName, rcpType, ciL, iiL, entries, upgrades, bI, t)
}

func MockDetailedRecipeGUID(
	rcpName string,
	rcpType types.RecipeType,
	ciL types.CoinInputList,
	iiL types.ItemInputList,
	entries types.WeightedParamList,
	upgrades types.ItemUpgradeParams,
	interval int64,
	t *testing.T,
) (string, error) {
	guid, err := GetRecipeGUIDFromName(rcpName, "")
	ErrValidation(t, "error checking if recipe already exist %+v", err)

	if len(guid) > 0 { // finish mock if already available
		return guid, nil
	}

	mCB, err := GetMockedCookbook(t)
	ErrValidation(t, "error getting mocked cookbook %+v", err)

	eugenAddr := GetAccountAddr("eugen", t)
	sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
	t.MustNil(err)
	txhash := TestTxWithMsgWithNonce(t,
		msgs.NewMsgCreateRecipe(
			rcpName,
			mCB.ID,
			"",
			"this has to meet character limits lol",
			rcpType,
			ciL,
			iiL,
			entries,
			upgrades,
			interval,
			sdkAddr),
		"eugen",
		false,
	)

	err = WaitForNextBlock()
	ErrValidation(t, "error waiting for creating recipe %+v", err)

	txHandleResBytes, err := GetTxData(txhash, t)
	t.MustNil(err)
	resp := handlers.CreateRecipeResponse{}
	err = GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
	t.MustNil(err)

	return resp.RecipeID, nil
}

func GetRecipeGUIDFromName(name string, account string) (string, error) {
	rcpList, err := ListRecipesViaCLI(account)
	if err != nil {
		return "", err
	}
	rcp, _ := FindRecipeFromArrayByName(rcpList, name)
	return rcp.ID, nil
}

///////////ITEM//////////////////////////////////////////////

func MockItemGUID(name string, t *testing.T) string {
	mCB, err := GetMockedCookbook(t)
	ErrValidation(t, "error getting mocked cookbook %+v", err)

	eugenAddr := GetAccountAddr("eugen", t)
	sdkAddr, err := sdk.AccAddressFromBech32(eugenAddr)
	t.MustNil(err)

	txhash := TestTxWithMsgWithNonce(t, msgs.NewMsgFiatItem(mCB.ID,
		[]types.DoubleKeyValue{},
		[]types.LongKeyValue{},
		[]types.StringKeyValue{
			types.StringKeyValue{
				Key:   "Name",
				Value: name,
			},
		},
		sdkAddr,
	),
		"eugen",
		false,
	)

	err = WaitForNextBlock()
	ErrValidation(t, "error waiting for creating item %+v", err)

	txHandleResBytes, err := GetTxData(txhash, t)
	t.MustNil(err)
	resp := handlers.FiatItemResponse{}
	err = GetAminoCdc().UnmarshalJSON(txHandleResBytes, &resp)
	t.MustNil(err)

	return resp.ItemID
}
