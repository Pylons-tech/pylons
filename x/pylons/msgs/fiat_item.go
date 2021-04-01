package msgs

import (
	"encoding/json"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// NewMsgFiatItem a constructor for MsgFiatItem msg
func NewMsgFiatItem(cookbookID string, doubles types.DoubleKeyValueList, longs types.LongKeyValueList, strings types.StringKeyValueList, sender string, transferFee int64) MsgFiatItem {
	return MsgFiatItem{
		CookbookID:  cookbookID,
		Doubles:     doubles,
		Longs:       longs,
		Strings:     strings,
		Sender:      sender,
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
	from, err := sdk.AccAddressFromBech32(msg.Sender)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{from}
}
