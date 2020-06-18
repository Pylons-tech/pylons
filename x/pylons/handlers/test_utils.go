package handlers

import (
	"encoding/json"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// MockCookbook mock cookbook
func MockCookbook(tci keep.TestCoinInput, sender sdk.AccAddress) CreateCookbookResponse {
	return MockCookbookByName(tci, sender, "cookbook-00001")
}

// MockCookbookByName mock cookbook with specific name
func MockCookbookByName(tci keep.TestCoinInput, sender sdk.AccAddress, cookbookName string) CreateCookbookResponse {
	cookbookDesc := "this has to meet character limits"
	msg := msgs.NewMsgCreateCookbook(cookbookName, "", cookbookDesc, "SketchyCo", "1.0.0", "example@example.com", 1, msgs.DefaultCostPerBlock, sender)
	cbResult, err := HandlerMsgCreateCookbook(tci.Ctx, tci.PlnK, msg)
	if err != nil {
		panic(err.Error())
	}
	cbData := CreateCookbookResponse{}
	//nolint:errcheck
	json.Unmarshal((*cbResult).Data, &cbData)
	return cbData
}

// MockRecipe mock recipe with details
func MockRecipe(
	tci keep.TestCoinInput,
	rcpName string,
	coinInputList types.CoinInputList,
	itemInputList types.ItemInputList,
	entries types.EntriesList,
	outputs types.WeightedOutputsList,
	cbID string,
	blockInterval int64,
	sender sdk.AccAddress,
) CreateRecipeResponse {
	newRcpMsg := msgs.NewMsgCreateRecipe(rcpName, cbID, "", "this has to meet character limits",
		coinInputList,
		itemInputList,
		entries,
		outputs,
		blockInterval,
		sender,
	)
	newRcpResult, err := HandlerMsgCreateRecipe(tci.Ctx, tci.PlnK, newRcpMsg)
	if err != nil {
		panic(err.Error())
	}
	recipeData := CreateRecipeResponse{}
	//nolint:errcheck
	json.Unmarshal(newRcpResult.Data, &recipeData)
	return recipeData
}

// PopularRecipeType is a type for popular recipes
type PopularRecipeType int

// describes popular recipes
const (
	// a default recipe
	RcpDefault PopularRecipeType = 0
	// a recipe to convert 5x woodcoin to chaircoin
	Rcp5xWoodcoinTo1xChaircoin PopularRecipeType = 1
	// a recipe to convert 5x woodcoin to chaircoin, which is 5 block delayed
	Rcp5BlockDelayed5xWoodcoinTo1xChaircoin PopularRecipeType = 2
	// a recipe to convert 5x woodcoin to 1x raichu item
	Rcp5xWoodcoinTo1xRaichuItemBuy PopularRecipeType = 3
	// a recipe to upgrade raichu's name
	RcpRaichuNameUpgrade PopularRecipeType = 4
	// a recipe to upgrade raichu's name with catalyst item
	RcpRaichuNameUpgradeWithCatalyst PopularRecipeType = 5
	// a recipe to upgrade knife, which is 2 block delayed
	Rcp2BlockDelayedKnifeUpgrade PopularRecipeType = 6
	// a recipe to merge two knives, which is 2 block delayed
	Rcp2BlockDelayedKnifeMerge PopularRecipeType = 7
	// a recipe to buy a knife, which is 2 block delayed
	Rcp2BlockDelayedKnifeBuyer PopularRecipeType = 8
)

// GetParamsForPopularRecipe is a function to get popular recipe's attributes
func GetParamsForPopularRecipe(hfrt PopularRecipeType) (types.CoinInputList, types.ItemInputList, types.EntriesList, types.WeightedOutputsList, int64) {
	switch hfrt {
	case Rcp5xWoodcoinTo1xChaircoin: // 5 x woodcoin -> 1 x chair coin recipe
		return types.GenCoinInputList("wood", 5),
			types.ItemInputList{},
			types.GenCoinOnlyEntry("chair"),
			types.GenOneOutput(1),
			0
	case Rcp5BlockDelayed5xWoodcoinTo1xChaircoin: // 5 x woodcoin -> 1 x chair coin recipe, 5 block delayed
		return types.GenCoinInputList("wood", 5),
			types.ItemInputList{},
			types.GenCoinOnlyEntry("chair"),
			types.GenOneOutput(1),
			5
	case Rcp5xWoodcoinTo1xRaichuItemBuy:
		return types.GenCoinInputList("wood", 5),
			types.ItemInputList{},
			types.GenItemOnlyEntry("Raichu"),
			types.GenOneOutput(1),
			0
	case RcpRaichuNameUpgrade:
		return types.CoinInputList{},
			types.GenItemInputList("Raichu"),
			types.GenEntriesFirstItemNameUpgrade("RaichuV2"),
			types.GenOneOutput(1),
			0
	case RcpRaichuNameUpgradeWithCatalyst:
		return types.CoinInputList{},
			types.GenItemInputList("RaichuTC", "catalyst"),
			types.GenEntriesFirstItemNameUpgrade("RaichuTCV2"),
			types.GenOneOutput(1),
			0
	case Rcp2BlockDelayedKnifeUpgrade:
		return types.CoinInputList{},
			types.GenItemInputList("Knife"),
			types.GenEntriesFirstItemNameUpgrade("KnifeV2"),
			types.GenOneOutput(1),
			2
	case Rcp2BlockDelayedKnifeMerge:
		return types.CoinInputList{},
			types.GenItemInputList("Knife", "Knife"),
			types.GenItemOnlyEntry("KnifeMRG"),
			types.GenOneOutput(1),
			2
	case Rcp2BlockDelayedKnifeBuyer:
		return types.GenCoinInputList("wood", 5),
			types.ItemInputList{},
			types.GenItemOnlyEntry("Knife"),
			types.GenOneOutput(1),
			2
	default: // 5 x woodcoin -> 1 x chair coin recipe, no delay
		return types.GenCoinInputList("wood", 5),
			types.ItemInputList{},
			types.GenEntries("chair", "Raichu"),
			types.GenOneOutput(1),
			0
	}
}

// MockPopularRecipe mock popular recipes
func MockPopularRecipe(
	hfrt PopularRecipeType,
	tci keep.TestCoinInput,
	rcpName string,
	cbID string,
	sender sdk.AccAddress,
) CreateRecipeResponse {
	ciL, iiL, entries, outputs, bI := GetParamsForPopularRecipe(hfrt)
	return MockRecipe(
		tci, rcpName,
		ciL, iiL, entries, outputs,
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
) (ExecuteRecipeResponse, error) {
	msg := msgs.NewMsgExecuteRecipe(rcpID, sender, itemIDs)
	result, _ := HandlerMsgExecuteRecipe(tci.Ctx, tci.PlnK, msg)

	execRcpResponse := ExecuteRecipeResponse{}
	err := json.Unmarshal(result.Data, &execRcpResponse)
	return execRcpResponse, err
}

// MockTrade creates a trade
func MockTrade(
	tci keep.TestCoinInput,
	coinInputList types.CoinInputList,
	itemInputList types.TradeItemInputList,
	coinOutputs sdk.Coins,
	itemOutputs types.ItemList,
	sender sdk.AccAddress,
) (CreateTradeResponse, error) {
	msg := msgs.NewMsgCreateTrade(coinInputList, itemInputList, coinOutputs, itemOutputs, "", sender)
	result, _ := HandlerMsgCreateTrade(tci.Ctx, tci.PlnK, msg)
	createTrdResponse := CreateTradeResponse{}
	err := json.Unmarshal(result.Data, &createTrdResponse)
	return createTrdResponse, err
}
