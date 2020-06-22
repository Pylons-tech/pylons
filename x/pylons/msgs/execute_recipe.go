package msgs

import (
	"encoding/json"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// MsgExecuteRecipe defines a SetName message
type MsgExecuteRecipe struct {
	RecipeID string
	Sender   sdk.AccAddress
	ItemIDs  []string
}

// NewMsgExecuteRecipe a constructor for ExecuteCookbook msg
func NewMsgExecuteRecipe(recipeID string, sender sdk.AccAddress, itemIDs []string) MsgExecuteRecipe {
	msg := MsgExecuteRecipe{
		RecipeID: recipeID,
		Sender:   sender,
		ItemIDs:  itemIDs,
	}
	return msg
}

// Route should return the name of the module
func (msg MsgExecuteRecipe) Route() string { return RouterKey }

// Type should return the action
func (msg MsgExecuteRecipe) Type() string { return "execute_recipe" }

// ValidateBasic validates the Msg
func (msg MsgExecuteRecipe) ValidateBasic() error {

	if msg.Sender.Empty() {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender.String())

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
