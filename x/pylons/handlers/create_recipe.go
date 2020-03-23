package handlers

import (
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

type CreateRecipeResponse struct {
	RecipeID string `json:"RecipeID"`
}

// HandlerMsgCreateRecipe is used to create recipe by a developer
func HandlerMsgCreateRecipe(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgCreateRecipe) sdk.Result {

	err := msg.ValidateBasic()
	if err != nil {
		return err.Result()
	}
	cook, err2 := keeper.GetCookbook(ctx, msg.CookbookID)
	if err2 != nil {
		return errInternal(err2)
	}
	if !cook.Sender.Equals(msg.Sender) {
		return sdk.ErrUnauthorized("cookbook not owned by the sender").Result()
	}

	recipe := types.NewRecipe(
		msg.Name, msg.CookbookID, msg.Description,
		msg.CoinInputs,
		msg.ItemInputs,
		msg.Entries,
		msg.Outputs,
		msg.BlockInterval, msg.Sender)

	if msg.RecipeID != "" {
		if keeper.HasRecipeWithCookbookID(ctx, msg.CookbookID, msg.RecipeID) {
			return errInternal(fmt.Errorf("The recipeID %s is already present in CookbookID %s", msg.RecipeID, msg.CookbookID))
		}
		recipe.ID = msg.RecipeID
	}
	if err := recipe.ItemInputs.Validate(); err != nil {
		return errInternal(err)
	}

	if err := keeper.SetRecipe(ctx, recipe); err != nil {
		return errInternal(err)
	}

	return marshalJson(CreateRecipeResponse{
		recipe.ID,
	})
}
