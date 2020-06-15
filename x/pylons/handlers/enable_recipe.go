package handlers

import (
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// EnableRecipeResponse is the response for enableRecipe
type EnableRecipeResponse struct {
	Message string
	Status  string
}

// HandlerMsgEnableRecipe is used to enable recipe by a developer
func HandlerMsgEnableRecipe(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgEnableRecipe) (*sdk.Result, error) {

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

	recipe.Disabled = false

	err = keeper.UpdateRecipe(ctx, msg.RecipeID, recipe)
	if err != nil {
		return nil, errInternal(err)
	}

	return marshalJSON(EnableRecipeResponse{
		Message: "successfully enabled the recipe",
		Status:  "Success",
	})
}
