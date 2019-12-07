package handlers

import (
	"encoding/json"

	"github.com/MikeSofaer/pylons/x/pylons/keep"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

func errInternal(err error) sdk.Result {

	return sdk.ErrInternal(err.Error()).Result()
}

func recipeChangeContext(ctx sdk.Context, keeper keep.Keeper, recipeID string, msgSender sdk.AccAddress, recipeFn RecipeChangeFn) sdk.Result {

	recipe, err2 := keeper.GetRecipe(ctx, recipeID)
	if err2 != nil {
		return errInternal(err2)
	}

	if !msgSender.Equals(recipe.Sender) {
		return sdk.ErrUnauthorized("msg sender is not the owner of the recipe").Result()
	}

	err2 = recipeFn(&recipe)
	if err2 != nil {
		return errInternal(err2)
	}

	err2 = keeper.UpdateRecipe(ctx, recipeID, recipe)
	if err2 != nil {
		return errInternal(err2)
	}

	resp, err2 := json.Marshal(EnableRecipeResp{
		Message: "successfully changed the recipe",
		Status:  "Success",
	})

	if err2 != nil {
		return errInternal(err2)
	}

	return sdk.Result{Data: resp}
}
