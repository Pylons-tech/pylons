package handlers

import (
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// UpdateRecipeResponse is a struct to control update recipe response
type UpdateRecipeResponse struct {
	RecipeID string `json:"RecipeID"`
	Message  string
	Status   string
}

// HandlerMsgUpdateRecipe is used to update recipe by a developer
func HandlerMsgUpdateRecipe(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgUpdateRecipe) (*sdk.Result, error) {

	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	rc, err := keeper.GetRecipe(ctx, msg.ID)

	// only the original sender (owner) of the cookbook can update the cookbook
	if !rc.Sender.Equals(msg.Sender) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "the owner of the recipe is different then the current sender")
	}

	if err != nil {
		return nil, errInternal(err)
	}

	rc.Description = msg.Description
	rc.CookbookID = msg.CookbookID
	rc.CoinInputs = msg.CoinInputs
	rc.ItemInputs = msg.ItemInputs
	rc.Entries = msg.Entries
	rc.BlockInterval = msg.BlockInterval
	rc.Name = msg.Name
	rc.Outputs = msg.Outputs

	if err := keeper.UpdateRecipe(ctx, msg.ID, rc); err != nil {
		return nil, errInternal(err)
	}

	return marshalJSON(UpdateRecipeResponse{
		RecipeID: msg.ID,
		Message:  "successfully updated the recipe",
		Status:   "Success",
	})
}
