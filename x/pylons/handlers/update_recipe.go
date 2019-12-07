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

// HandlerMsgUpdateRecipe is used to update recipe by a developer
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
		return errInternal(err2)
	}

	rc.Description = msg.Description
	rc.CookbookID = msg.CookbookID
	rc.CoinInputs = msg.CoinInputs
	rc.ItemInputs = msg.ItemInputs
	rc.Entries = msg.Entries
	rc.BlockInterval = msg.BlockInterval
	rc.Name = msg.Name

	if err := keeper.UpdateRecipe(ctx, msg.ID, rc); err != nil {
		return errInternal(err)
	}

	mRecipe, err2 := json.Marshal(UpdateRecipeResponse{
		msg.ID,
	})

	if err2 != nil {
		return errInternal(err2)
	}

	return sdk.Result{Data: mRecipe}
}
