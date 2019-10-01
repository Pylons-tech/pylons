package handlers

import (
	"encoding/json"

	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

type UpdateRecipeResponse struct {
	RecipeID string `json:"RecipeID"`
}

// HandlerMsgUpdateRecipe is used to create cookbook by a developer
func HandlerMsgUpdateRecipe(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgUpdateRecipe) sdk.Result {

	err := msg.ValidateBasic()
	if err != nil {
		return err.Result()
	}

	rc, err2 := keeper.GetRecipe(ctx, msg.ID)

	// only the original sender (owner) of the cookbook can update the cookbook
	if !rc.Sender.Equals(msg.Sender) {
		return sdk.ErrUnauthorized("the owner of the recipe is different then the current sender").Result()
	}

	if err2 != nil {
		return sdk.ErrInternal(err2.Error()).Result()
	}

	rc.Description = msg.Description
	rc.CookbookId = msg.CookbookId
	rc.CoinInputs = msg.CoinInputs
	rc.ItemInputs = msg.ItemInputs
	rc.Entries = msg.Entries
	rc.BlockInterval = msg.BlockInterval
	rc.RecipeName = msg.RecipeName

	if err := keeper.UpdateRecipe(ctx, msg.ID, rc); err != nil {
		return sdk.ErrInternal(err.Error()).Result()
	}

	mRecipe, err2 := json.Marshal(map[string]string{
		"RecipeID": msg.ID,
	})

	if err2 != nil {
		return sdk.ErrInternal(err2.Error()).Result()
	}

	return sdk.Result{Data: mRecipe}
}
