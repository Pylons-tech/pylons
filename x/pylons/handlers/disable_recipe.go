package handlers

import (
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// DisableRecipeResponse is the response for disableRecipe
type DisableRecipeResponse struct {
	Message string
	Status  string
}

// HandlerMsgDisableRecipe is used to disable recipe by a developer
func HandlerMsgDisableRecipe(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgDisableRecipe) (*sdk.Result, error) {

	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	recipe, err := keeper.GetRecipe(ctx, msg.RecipeID)
	if err != nil {
		return nil, errInternal(err)
	}

	if !msg.Sender.Equals(recipe.Sender) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "msg sender is not the owner of the recipe")
	}
	recipe.Disabled = true

	err = keeper.UpdateRecipe(ctx, msg.RecipeID, recipe)
	if err != nil {
		return nil, errInternal(err)
	}

	return marshalJSON(DisableRecipeResponse{
		Message: "successfully disabled the recipe",
		Status:  "Success",
	})
}
