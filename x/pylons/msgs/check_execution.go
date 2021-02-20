package msgs

import (
	"encoding/json"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// NewMsgCheckExecution a constructor for CheckExecution msg
func NewMsgCheckExecution(execID string, ptc bool, sender sdk.AccAddress) MsgCheckExecution {
	return MsgCheckExecution{
		ExecID:        execID,
		Sender:        sender.String(),
		PayToComplete: ptc,
	}
}

// Route should return the name of the module
func (msg MsgCheckExecution) Route() string { return RouterKey }

// Type should return the action
func (msg MsgCheckExecution) Type() string { return "check_execution" }

// ValidateBasic validates the Msg
func (msg MsgCheckExecution) ValidateBasic() error {

	if msg.Sender == "" {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, msg.Sender)
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
	return []sdk.AccAddress{sdk.AccAddress(msg.Sender)}
}
