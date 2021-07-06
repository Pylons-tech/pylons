package handlers

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// CreateAccount is used to send pylons to requesters. This handler is part of the
// faucet
func (srv msgServer) CreateAccount(ctx context.Context, msg *types.MsgCreateAccount) (*types.MsgCreateExecutionResponse, error) {

	err := msg.ValidateBasic()

	if err != nil {
		return nil, errInternal(err)
	}

	return &types.MsgCreateExecutionResponse{
		Message: "successfully created the account",
		Status:  "Success",
	}, nil
}
