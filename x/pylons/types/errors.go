package types

// DONTCOVER

import (
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// x/pylons module sentinel errors
var (
	ErrInvalidRequestField = sdkerrors.Register(ModuleName, 1100, "invalid field provided in request")
	ErrInvalidTierUpgrade = sdkerrors.Register(ModuleName, 1101, "invalid tier upgrade")
	// this line is used by starport scaffolding # ibc/errors
)
