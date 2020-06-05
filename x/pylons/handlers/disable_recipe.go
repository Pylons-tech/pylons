package handlers

import (
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// DisableRecipeResp is the response for disableRecipe
type DisableRecipeResp struct {
	Message string
	Status  string
}

// HandlerMsgDisableRecipe is used to disable recipe by a developer
func HandlerMsgDisableRecipe(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgDisableRecipe) (*sdk.Result, error) {

	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	recipe, err2 := keeper.GetRecipe(ctx, msg.RecipeID)
	if err2 != nil {
		return nil, errInternal(err2)
	}

	if !msg.Sender.Equals(recipe.Sender) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "msg sender is not the owner of the recipe")
	}
	recipe.Disabled = true

	err2 = keeper.UpdateRecipe(ctx, msg.RecipeID, recipe)
	if err2 != nil {
		return nil, errInternal(err2)
	}

	return marshalJSON(DisableRecipeResp{
		Message: "successfully disabled the recipe",
		Status:  "Success",
	})
}
