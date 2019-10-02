package handlers

import (
	"encoding/json"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	"github.com/MikeSofaer/pylons/x/pylons/types"
)

func MockCookbook(tci keep.TestCoinInput, sender sdk.AccAddress) CreateCBResponse {
	cookbookName := "cookbook-00001"
	cookbookDesc := "this has to meet character limits"
	msg := msgs.NewMsgCreateCookbook(cookbookName, cookbookDesc, "SketchyCo", "1.0.0", "example@example.com", 1, msgs.DefaultCostPerBlock, sender)
	cbResult := HandlerMsgCreateCookbook(tci.Ctx, tci.PlnK, msg)
	cbData := CreateCBResponse{}
	json.Unmarshal(cbResult.Data, &cbData)
	return cbData
}

func MockRecipe(
	tci keep.TestCoinInput,
	recipeName string,
	coinInputList types.CoinInputList,
	itemInputList types.ItemInputList,
	entries types.WeightedParamList,
	cookbookID string,
	blockInterval int,
	sender sdk.AccAddress,
) CreateRecipeResponse {
	newRcpMsg := msgs.NewMsgCreateRecipe(recipeName, cookbookID, "this has to meet character limits",
		coinInputList,
		itemInputList,
		entries,
		blockInterval,
		sender,
	)
	newRcpResult := HandlerMsgCreateRecipe(tci.Ctx, tci.PlnK, newRcpMsg)
	recipeData := CreateRecipeResponse{}
	json.Unmarshal(newRcpResult.Data, &recipeData)
	return recipeData
}
