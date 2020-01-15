package handlers

import (
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// EnableRecipeResp is the response for enableRecipe
type EnableRecipeResp struct {
	Message string
	Status  string
}

// HandlerMsgEnableRecipe is used to enable recipe by a developer
func HandlerMsgEnableRecipe(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgEnableRecipe) sdk.Result {

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

	recipe.Disabled = false

	err2 = keeper.UpdateRecipe(ctx, msg.RecipeID, recipe)
	if err2 != nil {
		return errInternal(err2)
	}

	return marshalJson(EnableRecipeResp{
		Message: "successfully enabled the recipe",
		Status:  "Success",
	})
}
