package handlers

import (
	"encoding/json"

	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	"github.com/MikeSofaer/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

type CreateRecipeResponse struct {
	RecipeID string `json:"RecipeID"`
}

// HandlerMsgCreateRecipe is used to create recipe by a developer
func HandlerMsgCreateRecipe(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgCreateRecipe) sdk.Result {

	// TODO: for item upgrade recipe, should have item input size as 1
	err := msg.ValidateBasic()
	if err != nil {
		return err.Result()
	}
	cook, err2 := keeper.GetCookbook(ctx, msg.CookbookID)
	if !cook.Sender.Equals(msg.Sender) {
		return sdk.ErrUnauthorized("cookbook not owned by the sender").Result()
	}

	recipe := types.NewRecipe(
		msg.Name, msg.CookbookID, msg.Description,
		msg.RType,
		msg.CoinInputs,
		msg.ItemInputs,
		msg.Entries,
		msg.ToUpgrade,
		msg.BlockInterval, msg.Sender)
	if err := keeper.SetRecipe(ctx, recipe); err != nil {
		return errInternal(err)
	}

	mRecipe, err2 := json.Marshal(CreateRecipeResponse{
		recipe.ID,
	})

	if err2 != nil {
		return errInternal(err2)
	}

	return sdk.Result{Data: mRecipe}
}
