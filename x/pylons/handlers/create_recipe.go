package handlers

import (
	"context"
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// HandlerMsgCreateRecipe is used to create recipe by a developer
func (k msgServer) HandlerMsgCreateRecipe(ctx context.Context, msg *msgs.MsgCreateRecipe) (*msgs.MsgCreateRecipeResponse, error) {

	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	sdkCtx := sdk.UnwrapSDKContext(ctx)
	sender := sdk.AccAddress(msg.Sender)

	// validate cookbook id
	cook, err := k.GetCookbook(sdkCtx, msg.CookbookID)
	if err != nil {
		return nil, errInternal(err)
	}
	// validate sender
	if !cook.Sender.Equals(sender) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "cookbook not owned by the sender")
	}

	recipe := types.NewRecipe(
		msg.Name, msg.CookbookID, msg.Description,
		*msg.CoinInputs,
		*msg.ItemInputs,
		msg.Entries,
		*msg.Outputs,
		msg.BlockInterval, sender)

	if msg.RecipeID != "" {
		if k.HasRecipeWithCookbookID(sdkCtx, msg.CookbookID, msg.RecipeID) {
			return nil, errInternal(fmt.Errorf("The recipeID %s is already present in CookbookID %s", msg.RecipeID, msg.CookbookID))
		}
		recipe.ID = msg.RecipeID
	}
	if err := recipe.ItemInputs.Validate(); err != nil {
		return nil, errInternal(err)
	}

	if err := k.SetRecipe(sdkCtx, recipe); err != nil {
		return nil, errInternal(err)
	}

	return &msgs.MsgCreateRecipeResponse{
		RecipeID: recipe.ID,
		Message:  "successfully created a recipe",
		Status:   "Success",
	}, nil
}
