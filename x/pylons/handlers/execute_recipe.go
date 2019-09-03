package handlers

import (
	"encoding/json"

	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// ExecuteRecipeResp is the response for executeRecipe
type ExecuteRecipeResp struct {
	Message string
	Status  string
}

// HandlerMsgExecuteRecipe is used to create cookbook by a developer
func HandlerMsgExecuteRecipe(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgExecuteRecipe) sdk.Result {

	err := msg.ValidateBasic()
	if err != nil {
		return err.Result()
	}

	recipe, err2 := keeper.GetRecipe(ctx, msg.RecipeID)
	if err2 != nil {
		return sdk.ErrInternal(err2.Error()).Result()
	}

	var cl sdk.Coins
	for _, inp := range recipe.CoinInputs {
		cl = append(cl, sdk.NewCoin(inp.Coin, sdk.NewInt(inp.Count)))
	}

	if !keeper.CoinKeeper.HasCoins(ctx, msg.Sender, cl) {
		return sdk.ErrInternal("insufficient coin balance").Result()
	}

	// output coins to the sender
	var ocl sdk.Coins

	for _, out := range recipe.CoinOutputs {
		ocl = append(ocl, sdk.NewCoin(out.Coin, sdk.NewInt(out.Count)))
	}

	// TODO: send the coins to a master address instead of burning them
	// think about making this adding and subtracting atomic using inputoutputcoins method
	_, _, err = keeper.CoinKeeper.SubtractCoins(ctx, msg.Sender, cl)
	if err != nil {
		return err.Result()
	}

	_, _, err = keeper.CoinKeeper.AddCoins(ctx, msg.Sender, ocl)
	if err != nil {
		return err.Result()
	}

	resp, err2 := json.Marshal(ExecuteRecipeResp{
		Message: "successfully executed the recipe",
		Status:  "Success",
	})

	if err2 != nil {
		return sdk.ErrInternal(err2.Error()).Result()

	}

	return sdk.Result{Data: resp}
}
