package msgs

import (
	"encoding/json"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// NewMsgSendItems is a function to get MsgSendItems msg from required params
func NewMsgSendItems(itemIDs []string, sender, receiver string) MsgSendItems {
	return MsgSendItems{
		ItemIDs:  itemIDs,
		Sender:   sender,
		Receiver: receiver,
	}
}

// Route should return the name of the module
func (msg MsgSendItems) Route() string { return RouterKey }

// Type should return the action
func (msg MsgSendItems) Type() string { return "send_items" }

// ValidateBasic is a function to validate MsgSendItems msg
func (msg MsgSendItems) ValidateBasic() error {
	checked := make(map[string]bool)

	for _, val := range msg.ItemIDs {
		if val == "" {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "ItemID is invalid")
		}

		if checked[val] {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "Duplicated items in items trasfer")
		}

		checked[val] = true
	}

	if msg.Sender == msg.Receiver {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "Sender and receiver should be different")
	}

	if msg.Sender == "" {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender)
	}

	if msg.Receiver == "" {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Receiver)
	}

	return nil
}

// GetSignBytes encodes the message for signing
func (msg MsgSendItems) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners is a function to get signers from MsgSendItems msg
func (msg MsgSendItems) GetSigners() []sdk.AccAddress {
	from, err := sdk.AccAddressFromBech32(msg.Sender)
	if err != nil {
		panic(err)
	}
	return []sdk.AccAddress{from}
}
