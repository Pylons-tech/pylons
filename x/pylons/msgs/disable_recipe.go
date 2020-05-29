package msgs

import (
	"encoding/json"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// MsgDisableRecipe defines a DisableRecipe message
type MsgDisableRecipe struct {
	RecipeID string
	Sender   sdk.AccAddress
}

// NewMsgDisableRecipe a constructor for DisableRecipe msg
func NewMsgDisableRecipe(recipeID string, sender sdk.AccAddress) MsgDisableRecipe {
	return MsgDisableRecipe{
		RecipeID: recipeID,
		Sender:   sender,
	}
}

// Route should return the name of the module
func (msg MsgDisableRecipe) Route() string { return "pylons" }

// Type should return the action
func (msg MsgDisableRecipe) Type() string { return "disable_recipe" }

// ValidateBasic validates the Msg
func (msg MsgDisableRecipe) ValidateBasic() error {

	if msg.Sender.Empty() {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender.String())

	}

	return nil
}

// GetSignBytes encodes the message for signing
func (msg MsgDisableRecipe) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners gets the signer who should have signed the message
func (msg MsgDisableRecipe) GetSigners() []sdk.AccAddress {
	return []sdk.AccAddress{msg.Sender}
}
