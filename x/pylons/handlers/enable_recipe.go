package handlers

import (
	"encoding/json"

	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// EnableRecipeResp is the response for executeRecipe
type EnableRecipeResp struct {
	Message string
	Status  string
}

// HandlerMsgEnableRecipe is used to create cookbook by a developer
func HandlerMsgEnableRecipe(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgEnableRecipe) sdk.Result {

	err := msg.ValidateBasic()
	if err != nil {
		return err.Result()
	}

	recipe, err2 := keeper.GetRecipe(ctx, msg.RecipeID)
	if err2 != nil {
		return sdk.ErrInternal(err2.Error()).Result()
	}
	recipe.Disabled = false

	err2 = keeper.UpdateRecipe(ctx, msg.RecipeID, recipe)
	if err2 != nil {
		return sdk.ErrInternal(err2.Error()).Result()
	}

	resp, err2 := json.Marshal(EnableRecipeResp{
		Message: "successfully enabled the recipe",
		Status:  "Success",
	})

	if err2 != nil {
		return sdk.ErrInternal(err2.Error()).Result()

	}

	return sdk.Result{Data: resp}
}
