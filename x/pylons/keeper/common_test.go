package keeper_test

import "github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"

const (
	COMMON_SENDER     = "COMMON_SENDER"
	COMMON_RECIPIENT  = "COMMON_RECIPIENT"
	COMMON_AMOUNT     = "1denom"
	COMMON_COOKBOOKID = "COMMON_COOKBOOKID"
	COMMON_RECIPEID   = "COMMON_RECIPEID"
	COMMON_RECEIVER   = "COMMON_RECEIVER"
)

func NewStandardError(code, msg string) v1beta1.StandardError {
	return v1beta1.StandardError{
		Code:    code,
		Message: msg,
	}
}
