package types

// DONTCOVER

import (
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// x/pylons module sentinel errors
var (
	ErrInvalidRequestField     = sdkerrors.Register(ModuleName, 1100, "invalid field provided in request")
	ErrItemMatch               = sdkerrors.Register(ModuleName, 1101, "item mismatch")
	ErrItemQuantityExceeded    = sdkerrors.Register(ModuleName, 1102, "item exceeded maximum quantity")
	ErrInvalidPendingExecution = sdkerrors.Register(ModuleName, 1103, "completing execution would create an inconsistent state")
	ErrDuplicateUsername       = sdkerrors.Register(ModuleName, 1104, "username already taken by another account")
	ErrItemLocked              = sdkerrors.Register(ModuleName, 1105, "item locked")
	// this line is used by starport scaffolding # ibc/errors
)
