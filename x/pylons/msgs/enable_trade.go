package msgs

import (
	"encoding/json"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// NewMsgEnableTrade a constructor for EnableTrade msg
func NewMsgEnableTrade(tradeID string, sender sdk.AccAddress) MsgEnableTrade {
	return MsgEnableTrade{
		TradeID: tradeID,
		Sender:  sender.String(),
	}
}

// Route should return the name of the module
func (msg MsgEnableTrade) Route() string { return RouterKey }

// Type should return the action
func (msg MsgEnableTrade) Type() string { return "enable_trade" }

// ValidateBasic validates the Msg
func (msg MsgEnableTrade) ValidateBasic() error {

	if msg.Sender == "" {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender)
	}

	return nil
}

// GetSignBytes encodes the message for signing
func (msg MsgEnableTrade) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners gets the signer who should have signed the message
func (msg MsgEnableTrade) GetSigners() []sdk.AccAddress {
	return []sdk.AccAddress{sdk.AccAddress(msg.Sender)}
}
