package v1beta1

func NewStandardError(code, msg string) *StandardError {
	return &StandardError{
		Code:    code,
		Message: msg,
	}
}
