package tx

import "errors"

// TODO create more error types and replace current string usages
var (
	// nolint: deadcode
	errInvalidSigner = errors.New("tx intended signer does not match the given signer")
)
