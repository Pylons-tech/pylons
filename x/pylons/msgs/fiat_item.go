package msgs

import (
	"encoding/json"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// NewMsgFiatItem a constructor for MsgFiatItem msg
func NewMsgFiatItem(cookbookID string, doubles []*types.DoubleKeyValue, longs []*types.LongKeyValue, strings []*types.StringKeyValue, sender sdk.AccAddress, transferFee int64) MsgFiatItem {
	return MsgFiatItem{
		CookbookID:  cookbookID,
		Doubles:     doubles,
		Longs:       longs,
		Strings:     strings,
		Sender:      sender.String(),
		TransferFee: transferFee,
	}
}

// Route should return the name of the module
func (msg MsgFiatItem) Route() string { return RouterKey }

// Type should return the action
func (msg MsgFiatItem) Type() string { return "fiat_item" }

// ValidateBasic validates the Msg
func (msg MsgFiatItem) ValidateBasic() error {
	if msg.Sender == "" {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender)
	}

	return nil
}

// GetSignBytes encodes the message for signing
func (msg MsgFiatItem) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners gets the signer who should have signed the message
func (msg MsgFiatItem) GetSigners() []sdk.AccAddress {
	return []sdk.AccAddress{sdk.AccAddress(msg.Sender)}
}
