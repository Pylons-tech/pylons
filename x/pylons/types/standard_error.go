package types

func NewStandardError(code, msg string) *StandardError {
	return &StandardError{
		Code:    code,
		Message: msg,
	}
}
