package handlers

import (
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// HandlerMsgCreateAccount is used to send pylons to requesters. This handler is part of the
// faucet
func HandlerMsgCreateAccount(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgCreateAccount) (*sdk.Result, error) {

	err := msg.ValidateBasic()

	if err != nil {
		return nil, errInternal(err)
	}

	return &sdk.Result{}, nil
}
