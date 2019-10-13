package msgs

import (
	"encoding/json"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// MsgDropItem defines a SetName message
type MsgDropItem struct {
	ExecID string
	Sender sdk.AccAddress
	// if this is set to true then we complete the execution by paying for it
	PayToComplete bool
}

// MsgDropItem a constructor for ExecuteCookbook msg
func NewMsgDropItem(execID string, ptc bool, sender sdk.AccAddress) MsgDropItem {
	return MsgDropItem{
		ExecID:        execID,
		Sender:        sender,
		PayToComplete: ptc,
	}
}

// Route should return the name of the module
func (msg MsgDropItem) Route() string { return "pylons" }

// Type should return the action
func (msg MsgDropItem) Type() string { return "check_execution" }

// ValidateBasic validates the Msg
func (msg MsgDropItem) ValidateBasic() sdk.Error {

	if msg.Sender.Empty() {
		return sdk.ErrInvalidAddress(msg.Sender.String())
	}

	return nil
}

// GetSignBytes encodes the message for signing
func (msg MsgDropItem) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners gets the signer who should have signed the message
func (msg MsgDropItem) GetSigners() []sdk.AccAddress {
	return []sdk.AccAddress{msg.Sender}
}
