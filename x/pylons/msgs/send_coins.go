package msgs

import (
	"encoding/json"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// MsgSendCoins defines a SendCoins message
type MsgSendCoins struct {
	Amount   sdk.Coins
	Sender   sdk.AccAddress
	Receiver sdk.AccAddress
}

// NewMsgSendCoins is a function to get MsgSendCoins msg from required params
func NewMsgSendCoins(amount sdk.Coins, sender sdk.AccAddress, receiver sdk.AccAddress) MsgSendCoins {
	return MsgSendCoins{
		Amount:   amount,
		Sender:   sender,
		Receiver: receiver,
	}
}

// Route should return the name of the module
func (msg MsgSendCoins) Route() string { return RouterKey }

// Type should return the action
func (msg MsgSendCoins) Type() string { return "send_pylons" }

// ValidateBasic is a function to validate MsgSendCoins msg
func (msg MsgSendCoins) ValidateBasic() error {

	if msg.Sender.Empty() {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender.String())

	}

	if msg.Receiver.Empty() {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Receiver.String())
	}

	if !msg.Amount.IsAllPositive() {
		return sdkerrors.Wrap(sdkerrors.ErrUnknownRequest, "Amount cannot be less than 0/negative")

	}

	return nil
}

// GetSignBytes encodes the message for signing
func (msg MsgSendCoins) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners is a function to get signers from MsgSendCoins msg
func (msg MsgSendCoins) GetSigners() []sdk.AccAddress {
	return []sdk.AccAddress{msg.Sender}
}
