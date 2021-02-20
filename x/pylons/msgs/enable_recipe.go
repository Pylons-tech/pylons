package msgs

import (
	"encoding/json"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// NewMsgEnableRecipe a constructor for EnableRecipe msg
func NewMsgEnableRecipe(recipeID string, sender sdk.AccAddress) MsgEnableRecipe {
	return MsgEnableRecipe{
		RecipeID: recipeID,
		Sender:   sender.String(),
	}
}

// Route should return the name of the module
func (msg MsgEnableRecipe) Route() string { return RouterKey }

// Type should return the action
func (msg MsgEnableRecipe) Type() string { return "enable_recipe" }

// ValidateBasic validates the Msg
func (msg MsgEnableRecipe) ValidateBasic() error {

	if msg.Sender == "" {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender)
	}

	return nil
}

// GetSignBytes encodes the message for signing
func (msg MsgEnableRecipe) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners gets the signer who should have signed the message
func (msg MsgEnableRecipe) GetSigners() []sdk.AccAddress {
	return []sdk.AccAddress{sdk.AccAddress(msg.Sender)}
}
