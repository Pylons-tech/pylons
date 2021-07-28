package types

import sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

// Tier defines the kind of cookbook this is
const (
	// Basic is the free int64 which does allow developers to use pylons ( paid currency ) in their
	// games
	Basic int64 = iota
	Premium
)

// ValidateTier validates the tier
func ValidateTier(level int64) error {
	if level == Basic || level == Premium {
		return nil
	}

	return sdkerrors.Wrap(ErrInvalidRequestField, "invalid cookbook plan")
}
