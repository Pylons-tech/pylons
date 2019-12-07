package handlers

import (
	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	"github.com/MikeSofaer/pylons/x/pylons/types"
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
	return recipeChangeContext(ctx, keeper, msg.RecipeID, msg.Sender, func(recipe *types.Recipe) error {
		// we disable the recipe
		recipe.Disabled = true
		return nil
	})
}
