package handlers

import (
	"context"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// HandlerMsgDisableRecipe is used to disable recipe by a developer
func (k msgServer) HandlerMsgDisableRecipe(ctx context.Context, msg *msgs.MsgDisableRecipe) (*msgs.MsgDisableRecipeResponse, error) {

	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	sdkCtx := sdk.UnwrapSDKContext(ctx)
	sender, _ := sdk.AccAddressFromBech32(msg.Sender)

	recipe, err := k.GetRecipe(sdkCtx, msg.RecipeID)
	if err != nil {
		return nil, errInternal(err)
	}

	if sender.String() != recipe.Sender {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "msg sender is not the owner of the recipe")
	}
	recipe.Disabled = true

	err = k.UpdateRecipe(sdkCtx, msg.RecipeID, recipe)
	if err != nil {
		return nil, errInternal(err)
	}

	return &msgs.MsgDisableRecipeResponse{
		Message: "successfully disabled the recipe",
		Status:  "Success",
	}, nil
}
