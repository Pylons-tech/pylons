package msgs

import (
	"encoding/json"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// MsgSendItems defines a SendItems message
type MsgSendItems struct {
	TargetItem types.Item
	Sender     sdk.AccAddress
	Receiver   sdk.AccAddress
}

// NewMsgSendItems is a function to get MsgSendItems msg from required params
func NewMsgSendItems(targetItem types.Item, sender sdk.AccAddress, receiver sdk.AccAddress) MsgSendItems {
	return MsgSendItems{
		TargetItem: targetItem,
		Sender:     sender,
		Receiver:   receiver,
	}
}

// Route should return the name of the module
func (msg MsgSendItems) Route() string { return "pylons" }

// Type should return the action
func (msg MsgSendItems) Type() string { return "send_items" }

// ValidateBasic is a function to validate MsgSendItems msg
func (msg MsgSendItems) ValidateBasic() error {

	if msg.Sender.Empty() {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender.String())

	}

	if msg.Receiver.Empty() {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Receiver.String())

	}

	// if !msg.Amount.IsAllPositive() {
	// 	return sdkerrors.Wrap(sdkerrors.ErrUnknownRequest, "Amount cannot be less than 0/negative")

	// }

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
