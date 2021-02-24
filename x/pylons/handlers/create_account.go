package handlers

import (
	"context"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
)

// HandlerMsgCreateAccount is used to send pylons to requesters. This handler is part of the
// faucet
func (k msgServer) HandlerMsgCreateAccount(ctx context.Context, msg *msgs.MsgCreateAccount) (*msgs.MsgCreateExecutionResponse, error) {

	err := msg.ValidateBasic()

	if err != nil {
		return nil, errInternal(err)
	}

	return &msgs.MsgCreateExecutionResponse{
		Message: "successfully created the account",
		Status:  "Success",
	}, nil
}
