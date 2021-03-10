package handlers

import (
	"context"
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
func (k msgServer) HandlerMsgUpdateRecipe(ctx context.Context, msg *msgs.MsgUpdateRecipe) (*msgs.MsgUpdateRecipeResponse, error) {

	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	sdkCtx := sdk.UnwrapSDKContext(ctx)
	sender, _ := sdk.AccAddressFromBech32(msg.Sender)

	rc, err := k.GetRecipe(sdkCtx, msg.ID)

	// only the original sender (owner) of the cookbook can update the cookbook
	if rc.Sender != sender.String() {
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

	if err := k.UpdateRecipe(sdkCtx, msg.ID, rc); err != nil {
		return nil, errInternal(err)
	}

	return &msgs.MsgUpdateRecipeResponse{
		RecipeID: msg.ID,
		Message:  "successfully updated the recipe",
		Status:   "Success",
	}, nil
}
