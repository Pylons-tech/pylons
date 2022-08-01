package keeper

import "github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"

type msgServer struct {
	Keeper
}

// NewMsgServerImpl returns an implementation of the MsgServer interface
// for the provided Keeper.
func NewMsgServerImpl(keeper Keeper) v1beta1.MsgServer {
	return &msgServer{Keeper: keeper}
}

var _ v1beta1.MsgServer = msgServer{}
