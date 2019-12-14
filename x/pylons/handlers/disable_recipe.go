package handlers

import (
	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// DisableRecipeResp is the response for disableRecipe
type DisableRecipeResp struct {
	Message string
	Status  string
}

// HandlerMsgDisableRecipe is used to disable recipe by a developer
func HandlerMsgDisableRecipe(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgDisableRecipe) sdk.Result {

	err := msg.ValidateBasic()
	if err != nil {
		return err.Result()
	}

	recipe, err2 := keeper.GetRecipe(ctx, msg.RecipeID)
	if err2 != nil {
		return errInternal(err2)
	}

	if !msg.Sender.Equals(recipe.Sender) {
		return sdk.ErrUnauthorized("msg sender is not the owner of the recipe").Result()
	}
	recipe.Disabled = true

	err2 = keeper.UpdateRecipe(ctx, msg.RecipeID, recipe)
	if err2 != nil {
		return errInternal(err2)
	}

	return marshalJson(DisableRecipeResp{
		Message: "successfully disabled the recipe",
		Status:  "Success",
	})
}
