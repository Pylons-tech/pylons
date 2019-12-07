package handlers

import (
	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	"github.com/MikeSofaer/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// EnableRecipeResp is the response for enableRecipe
type EnableRecipeResp struct {
	Message string
	Status  string
}

// RecipeChangeFn is used to change recipe inside a closure
type RecipeChangeFn func(recipe *types.Recipe) error

// HandlerMsgEnableRecipe is used to enable recipe by a developer
func HandlerMsgEnableRecipe(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgEnableRecipe) sdk.Result {
	err := msg.ValidateBasic()
	if err != nil {
		return err.Result()
	}
	return recipeChangeContext(ctx, keeper, msg.RecipeID, msg.Sender, func(recipe *types.Recipe) error {
		recipe.Disabled = false
		return nil
	})
}
