package msgs

import (
	"encoding/json"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// NewMsgDisableTrade a constructor for DisableTrade msg
func NewMsgDisableTrade(tradeID string, sender sdk.AccAddress) MsgDisableTrade {
	return MsgDisableTrade{
		TradeID: tradeID,
		Sender:  sender.String(),
	}
}

// Route should return the name of the module
func (msg MsgDisableTrade) Route() string { return RouterKey }

// Type should return the action
func (msg MsgDisableTrade) Type() string { return "disable_trade" }

// ValidateBasic validates the Msg
func (msg MsgDisableTrade) ValidateBasic() error {

	if msg.Sender == "" {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender)
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
	from, err := sdk.AccAddressFromBech32(msg.Sender)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{from}
}
