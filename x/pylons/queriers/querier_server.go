package queriers

import (
	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

type querierServer struct {
	keeper.Keeper
}

// nolint
func NewQuerierServerImpl(k keeper.Keeper) *querierServer {
	return &querierServer{Keeper: k}
}

var _ types.QueryServer = &querierServer{}
