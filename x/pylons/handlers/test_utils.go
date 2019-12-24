package handlers

import (
	"encoding/json"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	"github.com/MikeSofaer/pylons/x/pylons/types"
)

func MockCookbook(tci keep.TestCoinInput, sender sdk.AccAddress) CreateCBResponse {
	return MockCookbookByName(tci, sender, "cookbook-00001")
}

func MockCookbookByName(tci keep.TestCoinInput, sender sdk.AccAddress, cookbookName string) CreateCBResponse {
	cookbookDesc := "this has to meet character limits"
	msg := msgs.NewMsgCreateCookbook(cookbookName, cookbookDesc, "SketchyCo", "1.0.0", "example@example.com", 1, msgs.DefaultCostPerBlock, sender)
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
	newRcpMsg := msgs.NewMsgCreateRecipe(rcpName, cbID, "this has to meet character limits",
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

func MockPopularRecipe(
	hfrt string,
	tci keep.TestCoinInput,
	rcpName string,
	cbID string,
	sender sdk.AccAddress,
) CreateRecipeResponse {
	switch hfrt {
	case "5xWOODCOIN_TO_1xCHAIRCOIN_RECIPE": // 5 x woodcoin -> 1 x chair coin recipe
		return MockRecipe(
			tci, rcpName,
			types.GENERATION,
			types.GenCoinInputList("wood", 5),
			types.ItemInputList{},
			types.GenCoinOnlyEntry("chair"),
			types.ItemUpgradeParams{},
			cbID,
			0,
			sender,
		)
	case "5_BLOCK_DELAYED_5xWOODCOIN_TO_1xCHAIRCOIN_RECIPE": // 5 x woodcoin -> 1 x chair coin recipe, 5 block delayed
		return MockRecipe(
			tci, rcpName,
			types.GENERATION,
			types.GenCoinInputList("wood", 5),
			types.ItemInputList{},
			types.GenCoinOnlyEntry("chair"),
			types.ItemUpgradeParams{},
			cbID,
			5,
			sender,
		)
	case "5xWOODCOIN_1xRAICHU_BUY_RECIPE":
		return MockRecipe(
			tci, rcpName,
			types.GENERATION,
			types.GenCoinInputList("wood", 5),
			types.ItemInputList{},
			types.GenItemOnlyEntry("Raichu"),
			types.ItemUpgradeParams{},
			cbID,
			0,
			sender,
		)
	case "RAICHU_NAME_UPGRADE_RECIPE":
		return MockRecipe(
			tci, rcpName,
			types.UPGRADE,
			types.CoinInputList{},
			types.GenItemInputList("Raichu"),
			types.WeightedParamList{},
			types.GenToUpgradeForString("Name", "RaichuV2"),
			cbID,
			0,
			sender,
		)
	default: // 5 x woodcoin -> 1 x chair coin recipe, no delay
		return MockRecipe(
			tci, rcpName,
			types.GENERATION,
			types.GenCoinInputList("wood", 5),
			types.ItemInputList{},
			types.GenEntries("chair", "Raichu"),
			types.ItemUpgradeParams{},
			cbID,
			0,
			sender,
		)
	}
}

// MockExecution executes a mockRecipe
func MockExecution(
	tci keep.TestCoinInput,
	rcpID string, // rcpID of blockInterval > 0
	sender sdk.AccAddress,
	itemIDs []string,
) (ExecuteRecipeResp, error) {
	msg := msgs.NewMsgExecuteRecipe(rcpID, sender, itemIDs)
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
