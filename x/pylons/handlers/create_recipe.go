package handlers

import (
	"math/rand"
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

type CreateRecipeResponse struct {
	RecipeID string `json:"RecipeID"`
}

// HandlerMsgCreateRecipe is used to create recipe by a developer
func HandlerMsgCreateRecipe(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgCreateRecipe) (*sdk.Result, error) {
	// set random seed at the start point of handler
	rand.Seed(types.RandomSeed(ctx))
	
	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}
	cook, err2 := keeper.GetCookbook(ctx, msg.CookbookID)
	if err2 != nil {
		return nil, errInternal(err2)
	}
	if !cook.Sender.Equals(msg.Sender) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "cookbook not owned by the sender")
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
			return nil, errInternal(fmt.Errorf("The recipeID %s is already present in CookbookID %s", msg.RecipeID, msg.CookbookID))
		}
		recipe.ID = msg.RecipeID
	}
	if err := recipe.ItemInputs.Validate(); err != nil {
		return nil, errInternal(err)
	}

	if err := keeper.SetRecipe(ctx, recipe); err != nil {
		return nil, errInternal(err)
	}

	return marshalJson(CreateRecipeResponse{
		recipe.ID,
	})
}
