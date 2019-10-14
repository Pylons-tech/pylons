package msgs

import (
	"encoding/json"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// MsgCheckExecution defines a CheckExecution message
type MsgCheckExecution struct {
	ExecID string
	Sender sdk.AccAddress
	// if this is set to true then we complete the execution by paying for it
	PayToComplete bool
}

// NewMsgCheckExecution a constructor for CheckExecution msg
func NewMsgCheckExecution(execID string, ptc bool, sender sdk.AccAddress) MsgCheckExecution {
	return MsgCheckExecution{
		ExecID:        execID,
		Sender:        sender,
		PayToComplete: ptc,
	}
}

// Route should return the name of the module
func (msg MsgCheckExecution) Route() string { return "pylons" }

// Type should return the action
func (msg MsgCheckExecution) Type() string { return "check_execution" }

// ValidateBasic validates the Msg
func (msg MsgCheckExecution) ValidateBasic() sdk.Error {

	if msg.Sender.Empty() {
		return sdk.ErrInvalidAddress(msg.Sender.String())
	}

	return nil
}

// GetSignBytes encodes the message for signing
func (msg MsgCheckExecution) GetSignBytes() []byte {
	b, err := json.Marshal(msg)
	if err != nil {
		panic(err)
	}
	return sdk.MustSortJSON(b)
}

// GetSigners gets the signer who should have signed the message
func (msg MsgCheckExecution) GetSigners() []sdk.AccAddress {
	return []sdk.AccAddress{msg.Sender}
}
