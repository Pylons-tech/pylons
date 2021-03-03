package queriers

import (
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

type querierServer struct {
	keep.Keeper
}

func NewQuerierServerImpl(k keep.Keeper) *querierServer {
	return &querierServer{Keeper: k}
}

var _ types.QueryServer = &querierServer{}
