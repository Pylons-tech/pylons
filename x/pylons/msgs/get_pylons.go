package msgs

import (
	"encoding/json"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// MsgGetPylons defines a GetPylons message
type MsgGetPylons struct {
	Amount    sdk.Coins
	Requester sdk.AccAddress
}

func NewMsgGetPylons(amount sdk.Coins, requester sdk.AccAddress) MsgGetPylons {
	return MsgGetPylons{
		Amount:    amount,
		Requester: requester,
	}
}

// Route should return the name of the module
func (msg MsgGetPylons) Route() string { return "pylons" }

// Type should return the action
func (msg MsgGetPylons) Type() string { return "get_pylons" }

func (msg MsgGetPylons) ValidateBasic() sdk.Error {

	if msg.Requester.Empty() {
		return sdk.ErrInvalidAddress(msg.Requester.String())
	}
	if !msg.Amount.IsAllPositive() {
		return sdk.ErrUnknownRequest("Amount cannot be less than 0/negative")
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

func (msg MsgGetPylons) GetSigners() []sdk.AccAddress {
	return []sdk.AccAddress{msg.Requester}
}
