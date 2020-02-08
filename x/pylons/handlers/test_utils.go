package handlers

import (
	"encoding/json"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func MockCookbook(tci keep.TestCoinInput, sender sdk.AccAddress) CreateCBResponse {
	return MockCookbookByName(tci, sender, "cookbook-00001")
}

func MockCookbookByName(tci keep.TestCoinInput, sender sdk.AccAddress, cookbookName string) CreateCBResponse {
	cookbookDesc := "this has to meet character limits"
	msg := msgs.NewMsgCreateCookbook(cookbookName, "", cookbookDesc, "SketchyCo", "1.0.0", "example@example.com", 1, msgs.DefaultCostPerBlock, sender)
	cbResult := HandlerMsgCreateCookbook(tci.Ctx, tci.PlnK, msg)
	cbData := CreateCBResponse{}
	json.Unmarshal(cbResult.Data, &cbData)
	return cbData
}

func MockRecipe(
	tci keep.TestCoinInput,
	rcpName string,
	rcpType types.RecipeType,
	coinInputList types.CoinInputList,
	itemInputList types.ItemInputList,
	entries types.WeightedParamList,
	toUpgrade types.ItemUpgradeParams,
	cbID string,
	blockInterval int64,
	sender sdk.AccAddress,
) CreateRecipeResponse {
	newRcpMsg := msgs.NewMsgCreateRecipe(rcpName, cbID, "", "this has to meet character limits",
		rcpType,
		coinInputList,
		itemInputList,
		entries,
		toUpgrade,
		blockInterval,
		sender,
	)
	newRcpResult := HandlerMsgCreateRecipe(tci.Ctx, tci.PlnK, newRcpMsg)
	recipeData := CreateRecipeResponse{}
	json.Unmarshal(newRcpResult.Data, &recipeData)
	return recipeData
}

type PopularRecipeType int

const (
	RCP_DEFAULT                                   PopularRecipeType = 0
	RCP_5xWOODCOIN_TO_1xCHAIRCOIN                 PopularRecipeType = 1
	RCP_5_BLOCK_DELAYED_5xWOODCOIN_TO_1xCHAIRCOIN PopularRecipeType = 2
	RCP_5xWOODCOIN_1xRAICHU_BUY                   PopularRecipeType = 3
	RCP_RAICHU_NAME_UPGRADE                       PopularRecipeType = 4
	RCP_2_BLOCK_DELAYED_KNIFE_UPGRADE             PopularRecipeType = 5
	RCP_2_BLOCK_DELAYED_KNIFE_MERGE               PopularRecipeType = 6
	RCP_2_BLOCK_DELAYED_KNIFE_BUYER               PopularRecipeType = 7
)

func GetParamsForPopularRecipe(hfrt PopularRecipeType) (types.RecipeType, types.CoinInputList, types.ItemInputList, types.WeightedParamList, types.ItemUpgradeParams, int64) {
	switch hfrt {
	case RCP_5xWOODCOIN_TO_1xCHAIRCOIN: // 5 x woodcoin -> 1 x chair coin recipe
		return types.GENERATION,
			types.GenCoinInputList("wood", 5),
			types.ItemInputList{},
			types.GenCoinOnlyEntry("chair"),
			types.ItemUpgradeParams{},
			0
	case RCP_5_BLOCK_DELAYED_5xWOODCOIN_TO_1xCHAIRCOIN: // 5 x woodcoin -> 1 x chair coin recipe, 5 block delayed
		return types.GENERATION,
			types.GenCoinInputList("wood", 5),
			types.ItemInputList{},
			types.GenCoinOnlyEntry("chair"),
			types.ItemUpgradeParams{},
			5
	case RCP_5xWOODCOIN_1xRAICHU_BUY:
		return types.GENERATION,
			types.GenCoinInputList("wood", 5),
			types.ItemInputList{},
			types.GenItemOnlyEntry("Raichu"),
			types.ItemUpgradeParams{},
			0
	case RCP_RAICHU_NAME_UPGRADE:
		return types.UPGRADE,
			types.CoinInputList{},
			types.GenItemInputList("Raichu"),
			types.WeightedParamList{},
			types.GenToUpgradeForString("Name", "RaichuV2"),
			0
	case RCP_2_BLOCK_DELAYED_KNIFE_UPGRADE:
		return types.UPGRADE,
			types.CoinInputList{},
			types.GenItemInputList("Knife"),
			types.WeightedParamList{},
			types.GenToUpgradeForString("Name", "KnifeV2"),
			2
	case RCP_2_BLOCK_DELAYED_KNIFE_MERGE:
		return types.GENERATION,
			types.CoinInputList{},
			types.GenItemInputList("Knife", "Knife"),
			types.GenItemOnlyEntry("KnifeMRG"),
			types.ItemUpgradeParams{},
			2
	case RCP_2_BLOCK_DELAYED_KNIFE_BUYER:
		return types.GENERATION,
			types.GenCoinInputList("wood", 5),
			types.ItemInputList{},
			types.GenItemOnlyEntry("Knife"),
			types.ItemUpgradeParams{},
			2
	default: // 5 x woodcoin -> 1 x chair coin recipe, no delay
		return types.GENERATION,
			types.GenCoinInputList("wood", 5),
			types.ItemInputList{},
			types.GenEntries("chair", "Raichu"),
			types.ItemUpgradeParams{},
			0
	}
}

func MockPopularRecipe(
	hfrt PopularRecipeType,
	tci keep.TestCoinInput,
	rcpName string,
	cbID string,
	sender sdk.AccAddress,
) CreateRecipeResponse {
	rcpType, ciL, iiL, entries, upgrades, bI := GetParamsForPopularRecipe(hfrt)
	return MockRecipe(
		tci, rcpName,
		rcpType, ciL, iiL, entries, upgrades,
		cbID,
		bI,
		sender,
	)
}

// MockExecution executes a mockRecipe
func MockExecution(
	tci keep.TestCoinInput,
	rcpID string, // rcpID of blockInterval > 0
	sender sdk.AccAddress,
	itemIDs []string,
) (ExecuteRecipeResp, error) {
	msg := msgs.NewMsgExecuteRecipe(rcpID, sender, itemIDs, []string{})
	result := HandlerMsgExecuteRecipe(tci.Ctx, tci.PlnK, msg)

	execRcpResponse := ExecuteRecipeResp{}
	err := json.Unmarshal(result.Data, &execRcpResponse)
	return execRcpResponse, err
}

// MockTrade creates a trade
func MockTrade(
	tci keep.TestCoinInput,
	coinInputList types.CoinInputList,
	itemInputList types.ItemInputList,
	coinOutputs sdk.Coins,
	itemOutputs types.ItemList,
	sender sdk.AccAddress,
) (CreateTradeResponse, error) {
	msg := msgs.NewMsgCreateTrade(coinInputList, itemInputList, coinOutputs, itemOutputs, "", sender)
	result := HandlerMsgCreateTrade(tci.Ctx, tci.PlnK, msg)
	createTrdResponse := CreateTradeResponse{}
	err := json.Unmarshal(result.Data, &createTrdResponse)
	return createTrdResponse, err
}
