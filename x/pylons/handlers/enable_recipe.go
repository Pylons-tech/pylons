package handlers

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// EnableRecipe is used to enable recipe by a developer
func (k msgServer) EnableRecipe(ctx context.Context, msg *types.MsgEnableRecipe) (*types.MsgEnableRecipeResponse, error) {

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

	recipe.Disabled = false

	err = k.UpdateRecipe(sdkCtx, msg.RecipeID, recipe)
	if err != nil {
		return nil, errInternal(err)
	}

	return &types.MsgEnableRecipeResponse{
		Message: "successfully enabled the recipe",
		Status:  "Success",
	}, nil
}
