package msgs

import (
	"encoding/json"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// MsgSendPylons defines a SendPylons message
type MsgSetItemFieldString struct {
	Field  string
	Value  string
	Sender sdk.AccAddress
	ItemID string
}

func NewMsgSetItemFieldString(ItemID, Field, Value string, Sender sdk.AccAddress) MsgSetItemFieldString {
	return MsgSetItemFieldString{
		ItemID: ItemID,
		Field:  Field,
		Value:  Value,
		Sender: Sender,
	}
}

// Route should return the name of the module
func (msg MsgSetItemFieldString) Route() string { return "pylons" }

// Type should return the action
func (msg MsgSetItemFieldString) Type() string { return "set_item_field_string" }

func (msg MsgSetItemFieldString) ValidateBasic() sdk.Error {

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
func (msg MsgSetItemFieldString) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

func (msg MsgSetItemFieldString) GetSigners() []sdk.AccAddress {
	return []sdk.AccAddress{msg.Sender}
}
