package msgs

import (
	"encoding/json"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// NewMsgSendCoins is a function to get MsgSendCoins msg from required params
func NewMsgSendCoins(amount sdk.Coins, sender sdk.AccAddress, receiver sdk.AccAddress) MsgSendCoins {
	return MsgSendCoins{
		Amount:   amount,
		Sender:   sender.String(),
		Receiver: receiver.String(),
	}
}

// Route should return the name of the module
func (msg MsgSendCoins) Route() string { return RouterKey }

// Type should return the action
func (msg MsgSendCoins) Type() string { return "send_coins" }

// ValidateBasic is a function to validate MsgSendCoins msg
func (msg MsgSendCoins) ValidateBasic() error {

	if msg.Sender == "" {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender)
	}

	if msg.Receiver == "" {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Receiver)
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
	from, err := sdk.AccAddressFromBech32(msg.Sender)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{from}
}
