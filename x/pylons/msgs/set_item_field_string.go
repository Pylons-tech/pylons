package msgs

import (
	"encoding/json"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// MsgSendPylons defines a SendPylons message
type MsgUpdateItemString struct {
	Field  string
	Value  string
	Sender sdk.AccAddress
	ItemID string
}

func NewMsgUpdateItemString(ItemID, Field, Value string, Sender sdk.AccAddress) MsgUpdateItemString {
	return MsgUpdateItemString{
		ItemID: ItemID,
		Field:  Field,
		Value:  Value,
		Sender: Sender,
	}
}

// Route should return the name of the module
func (msg MsgUpdateItemString) Route() string { return "pylons" }

// Type should return the action
func (msg MsgUpdateItemString) Type() string { return "update_item_string" }

func (msg MsgUpdateItemString) ValidateBasic() sdk.Error {

	if msg.Sender.Empty() {
		return sdk.ErrInvalidAddress(msg.Sender.String())
	}

	if len(msg.ItemID) == 0 {
		return sdk.ErrUnknownRequest("item id length should be more than 0")
	}

	if len(msg.Field) == 0 {
		return sdk.ErrUnknownRequest("field length should be more than 0")
	}

	if len(msg.Value) == 0 {
		return sdk.ErrUnknownRequest("value length should be more than 0")
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

func (msg MsgUpdateItemString) GetSigners() []sdk.AccAddress {
	return []sdk.AccAddress{msg.Sender}
}
