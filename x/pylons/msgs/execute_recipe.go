package msgs

import (
	"encoding/json"

	"github.com/MikeSofaer/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// MsgExecuteRecipe defines a SetName message
type MsgExecuteRecipe struct {
	RecipeID string
	Inputs   types.InputList
	Sender   sdk.AccAddress
}

// NewMsgExecuteRecipe a constructor for ExecuteCookbook msg
func NewMsgExecuteRecipe(recipeID string, inputs types.InputList, sender sdk.AccAddress) MsgExecuteRecipe {
	return MsgExecuteRecipe{
		RecipeID: recipeID,
		Inputs:   inputs,
		Sender:   sender,
	}
}

// Route should return the name of the module
func (msg MsgExecuteRecipe) Route() string { return "pylons" }

// Type should return the action
func (msg MsgExecuteRecipe) Type() string { return "execute_recipe" }

// ValidateBasic validates the Msg
func (msg MsgExecuteRecipe) ValidateBasic() sdk.Error {

	if msg.Sender.Empty() {
		return sdk.ErrInvalidAddress(msg.Sender.String())
	}

	return nil
}

// GetSignBytes encodes the message for signing
func (msg MsgExecuteRecipe) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners gets the signer who should have signed the message
func (msg MsgExecuteRecipe) GetSigners() []sdk.AccAddress {
	return []sdk.AccAddress{msg.Sender}
}
