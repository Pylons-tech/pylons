package msgs

import (
	"encoding/json"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// MsgSendItems defines a SendItems message
type MsgSendItems struct {
	ItemIDs  []string
	Sender   sdk.AccAddress
	Receiver sdk.AccAddress
}

// NewMsgSendItems is a function to get MsgSendItems msg from required params
func NewMsgSendItems(itemIDs []string, sender sdk.AccAddress, receiver sdk.AccAddress) MsgSendItems {
	return MsgSendItems{
		ItemIDs:  itemIDs,
		Sender:   sender,
		Receiver: receiver,
	}
}

// Route should return the name of the module
func (msg MsgSendItems) Route() string { return "pylons" }

// Type should return the action
func (msg MsgSendItems) Type() string { return "send_items" }

// ValidateBasic is a function to validate MsgSendItems msg
func (msg MsgSendItems) ValidateBasic() error {

	for _, val := range msg.ItemIDs {
		if val == "" {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "ItemID is invalid")
		}
	}

	if msg.Sender.String() == msg.Receiver.String() {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "Sender and receiver should be different")
	}

	if msg.Sender.Empty() {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender.String())
	}

	if msg.Receiver.Empty() {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Receiver.String())
	}

	return nil
}

// GetSignBytes encodes the message for signing
func (msg MsgSendItems) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners is a function to get signers from MsgSendItems msg
func (msg MsgSendItems) GetSigners() []sdk.AccAddress {
	return []sdk.AccAddress{msg.Sender}
}
