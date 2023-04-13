package types

// DONTCOVER

import (
	errorsmod "cosmossdk.io/errors"
)

// x/pylons module sentinel errors
var (
	ErrInvalidRequestField     = errorsmod.Register(ModuleName, 1100, "invalid field provided in request")
	ErrItemMatch               = errorsmod.Register(ModuleName, 1101, "item mismatch")
	ErrItemQuantityExceeded    = errorsmod.Register(ModuleName, 1102, "item exceeded maximum quantity")
	ErrInvalidPendingExecution = errorsmod.Register(ModuleName, 1103, "completing execution would create an inconsistent state")
	ErrDuplicateUsername       = errorsmod.Register(ModuleName, 1104, "username already taken by another account")
	ErrItemLocked              = errorsmod.Register(ModuleName, 1105, "item locked")
	ErrReceiptAlreadyUsed      = errorsmod.Register(ModuleName, 1106, "receipt already used")
	ErrReferralUserNotFound    = errorsmod.Register(ModuleName, 1107, "referral user not found")
	ErrAccountNotFound         = errorsmod.Register(ModuleName, 1108, "account not created")
)
