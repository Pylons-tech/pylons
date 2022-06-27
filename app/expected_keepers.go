package app

import (
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// FeegrantKeeper defines the expected feegrant keeper.
type PylonsKeeper interface {
	GetParams(ctx sdk.Context) (params types.Params)
}
