package msgs

import (
	"encoding/json"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// MsgDeleteTrade defines a DeleteTrade message
type MsgDeleteTrade struct {
	TradeID string
	Sender  sdk.AccAddress
}

// NewMsgDeleteTrade a constructor for DeleteTrade msg
func NewMsgDeleteTrade(
	tradeID string,
	sender sdk.AccAddress) MsgDeleteTrade {
	return MsgDeleteTrade{
		TradeID: tradeID,
		Sender:  sender,
	}
}

// Route should return the name of the module
func (msg MsgDeleteTrade) Route() string { return "pylons" }

// Type should return the action
func (msg MsgDeleteTrade) Type() string { return "delete_trade" }

// ValidateBasic validates the Msg
func (msg MsgDeleteTrade) ValidateBasic() sdk.Error {

	if msg.Sender.Empty() {
		return sdk.ErrInvalidAddress(msg.Sender.String())
	}

	return nil
}

// GetSignBytes encodes the message for signing
func (msg MsgDeleteTrade) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners gets the signer who should have signed the message
func (msg MsgDeleteTrade) GetSigners() []sdk.AccAddress {
	return []sdk.AccAddress{msg.Sender}
}
