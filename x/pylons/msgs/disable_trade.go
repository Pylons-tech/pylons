package msgs

import (
	"encoding/json"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// MsgDisableTrade defines a DisableTrade message
type MsgDisableTrade struct {
	TradeID string
	Sender  sdk.AccAddress
}

// NewMsgDisableTrade a constructor for DisableTrade msg
func NewMsgDisableTrade(tradeID string, sender sdk.AccAddress) MsgDisableTrade {
	return MsgDisableTrade{
		TradeID: tradeID,
		Sender:  sender,
	}
}

// Route should return the name of the module
func (msg MsgDisableTrade) Route() string { return "pylons" }

// Type should return the action
func (msg MsgDisableTrade) Type() string { return "disable_trade" }

// ValidateBasic validates the Msg
func (msg MsgDisableTrade) ValidateBasic() sdk.Error {

	if msg.Sender.Empty() {
		return sdk.ErrInvalidAddress(msg.Sender.String())
	}

	return nil
}

// GetSignBytes encodes the message for signing
func (msg MsgDisableTrade) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners gets the signer who should have signed the message
func (msg MsgDisableTrade) GetSigners() []sdk.AccAddress {
	return []sdk.AccAddress{msg.Sender}
}
