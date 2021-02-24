package handlers

import (
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
)

type msgServer struct {
	keep.Keeper
}


// NewMsgServerImpl returns an implementation of the bank MsgServer interface
// for the provided Keeper.
func NewMsgServerImpl(keeper keep.Keeper) msgs.MsgServer {
	return &msgServer{Keeper: keeper}
}

var _ msgs.MsgServer = msgServer{}
