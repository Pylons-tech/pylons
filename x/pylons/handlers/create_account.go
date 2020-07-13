package handlers

import (
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// CreateAccountResponse is the response for create-account
type CreateAccountResponse struct {
	Message string
	Status  string
}

// HandlerMsgCreateAccount is used to send pylons to requesters. This handler is part of the
// faucet
func HandlerMsgCreateAccount(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgCreateAccount) (*sdk.Result, error) {

	err := msg.ValidateBasic()

	if err != nil {
		return nil, errInternal(err)
	}

	return marshalJSON(CreateAccountResponse{
		Message: "successfully created the account",
		Status:  "Success",
	})
}
