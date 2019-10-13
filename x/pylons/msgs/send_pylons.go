package msgs

import (
	"encoding/json"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// MsgSendPylons defines a SendPylons message
type MsgSendPylons struct {
	Amount   sdk.Coins
	Sender   sdk.AccAddress
	Receiver sdk.AccAddress
}

func NewMsgSendPylons(amount sdk.Coins, sender sdk.AccAddress, receiver sdk.AccAddress) MsgSendPylons {
	return MsgSendPylons{
		Amount:   amount,
		Sender:   sender,
		Receiver: receiver,
	}
}

// Route should return the name of the module
func (msg MsgSendPylons) Route() string { return "pylons" }

// Type should return the action
func (msg MsgSendPylons) Type() string { return "send_pylons" }

func (msg MsgSendPylons) ValidateBasic() sdk.Error {

	if msg.Sender.Empty() {
		return sdk.ErrInvalidAddress(msg.Sender.String())
	}

	if msg.Receiver.Empty() {
		return sdk.ErrInvalidAddress(msg.Receiver.String())
	}

	if !msg.Amount.IsAllPositive() {
		return sdk.ErrUnknownRequest("Amount cannot be less than 0/negative")
	}

	return nil
}

// GetSignBytes encodes the message for signing
func (msg MsgSendPylons) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

func (msg MsgSendPylons) GetSigners() []sdk.AccAddress {
	return []sdk.AccAddress{msg.Sender}
}
