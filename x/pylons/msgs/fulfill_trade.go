package msgs

import (
	"encoding/json"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// MsgFulfillTrade defines a FulfillTrade message
type MsgFulfillTrade struct {
	TradeID string
	Sender  sdk.AccAddress
	ItemIDs []string
}

// NewMsgFulfillTrade a constructor for FulfillTrade msg
func NewMsgFulfillTrade(TradeID string, sender sdk.AccAddress, itemIDs []string) MsgFulfillTrade {
	return MsgFulfillTrade{
		TradeID: TradeID,
		Sender:  sender,
		ItemIDs: itemIDs,
	}
}

// Route should return the name of the module
func (msg MsgFulfillTrade) Route() string { return RouterKey }

// Type should return the action
func (msg MsgFulfillTrade) Type() string { return "fulfill_trade" }

// ValidateBasic validates the Msg
func (msg MsgFulfillTrade) ValidateBasic() error {

	if msg.Sender.Empty() {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender.String())
	}

	return nil
}

// GetSignBytes encodes the message for signing
func (msg MsgFulfillTrade) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners gets the signer who should have signed the message
func (msg MsgFulfillTrade) GetSigners() []sdk.AccAddress {
	return []sdk.AccAddress{msg.Sender}
}
