package keeper_test

import (
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

const (
	COMMON_SENDER     = "COMMON_SENDER"
	COMMON_RECIPIENT  = "COMMON_RECIPIENT"
	COMMON_AMOUNT     = "1denom"
	COMMON_COOKBOOKID = "COMMON_COOKBOOKID"
	COMMON_RECIPEID   = "COMMON_RECIPEID"
	COMMON_RECEIVER   = "COMMON_RECEIVER"
)

func NewStandardError(code, msg string) types.StandardError {
	return types.StandardError{
		Code:    code,
		Message: msg,
	}
}
