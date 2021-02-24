package handlers

import (
	"context"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)



// HandlerMsgEnableRecipe is used to enable recipe by a developer
func (k msgServer) HandlerMsgEnableRecipe(ctx context.Context, msg *msgs.MsgEnableRecipe) (*msgs.MsgEnableRecipeResponse, error) {

	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	sdkCtx := sdk.UnwrapSDKContext(ctx)
	sender := sdk.AccAddress(msg.Sender)

	recipe, err := k.GetRecipe(sdkCtx, msg.RecipeID)
	if err != nil {
		return nil, errInternal(err)
	}

	if !sender.Equals(recipe.Sender) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "msg sender is not the owner of the recipe")
	}

	recipe.Disabled = false

	err = k.UpdateRecipe(sdkCtx, msg.RecipeID, recipe)
	if err != nil {
		return nil, errInternal(err)
	}

	return &msgs.MsgEnableRecipeResponse{
		Message: "successfully enabled the recipe",
		Status:  "Success",
	}, nil
}
