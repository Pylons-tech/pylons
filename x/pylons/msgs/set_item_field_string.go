package msgs

import (
	"encoding/json"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// MsgUpdateItemString defines a UpdateItemString message
type MsgUpdateItemString struct {
	Field  string
	Value  string
	Sender sdk.AccAddress
	ItemID string
}

// NewMsgUpdateItemString is a function to get MsgUpdateItemString msg from required params
func NewMsgUpdateItemString(ItemID, Field, Value string, Sender sdk.AccAddress) MsgUpdateItemString {
	return MsgUpdateItemString{
		ItemID: ItemID,
		Field:  Field,
		Value:  Value,
		Sender: Sender,
	}
}

// Route should return the name of the module
func (msg MsgUpdateItemString) Route() string { return RouterKey }

// Type should return the action
func (msg MsgUpdateItemString) Type() string { return "update_item_string" }

// ValidateBasic is a function to validate MsgUpdateItemString msg
func (msg MsgUpdateItemString) ValidateBasic() error {

	if msg.Sender.Empty() {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender.String())
	}

	if len(msg.ItemID) == 0 {
		return sdkerrors.Wrap(sdkerrors.ErrUnknownRequest, "item id length should be more than 0")
	}

	if len(msg.Field) == 0 {
		return sdkerrors.Wrap(sdkerrors.ErrUnknownRequest, "field length should be more than 0")
	}

	if len(msg.Value) == 0 {
		return sdkerrors.Wrap(sdkerrors.ErrUnknownRequest, "value length should be more than 0")
	}
	return nil
}

// GetSignBytes encodes the message for signing
func (msg MsgUpdateItemString) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners is a function to get signers from MsgUpdateItemString msg
func (msg MsgUpdateItemString) GetSigners() []sdk.AccAddress {
	return []sdk.AccAddress{msg.Sender}
}
