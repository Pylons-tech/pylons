package msgs

import (
	"encoding/json"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// MsgGetPylons defines a GetPylons message
type MsgGetPylons struct {
	Amount    sdk.Coins
	Requester sdk.AccAddress
}

// NewMsgGetPylons is a function to get MsgGetPylons msg from required params
func NewMsgGetPylons(amount sdk.Coins, requester sdk.AccAddress) MsgGetPylons {
	return MsgGetPylons{
		Amount:    amount,
		Requester: requester,
	}
}

// Route should return the name of the module
func (msg MsgGetPylons) Route() string { return RouterKey }

// Type should return the action
func (msg MsgGetPylons) Type() string { return "get_pylons" }

// ValidateBasic is a function to validate MsgGetPylons msg
func (msg MsgGetPylons) ValidateBasic() error {

	if msg.Requester.Empty() {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Requester.String())
	}
	if !msg.Amount.IsAllPositive() {
		return sdkerrors.Wrap(sdkerrors.ErrUnknownRequest, "Amount cannot be less than 0/negative")
	}
	return nil
}

// GetSignBytes encodes the message for signing
func (msg MsgGetPylons) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners encodes the message for signing
func (msg MsgGetPylons) GetSigners() []sdk.AccAddress {
	return []sdk.AccAddress{msg.Requester}
}
