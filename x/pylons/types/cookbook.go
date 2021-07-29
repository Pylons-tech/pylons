package types

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

const (
	// Basic only allows creation of recipes that do not use pylons
	Basic int64 = iota
	// Premium allows creation of recipes that use pylons
	Premium
)

// Tier defines the kind of cookbook this is
type Tier struct {
	Tier int64
	Fee  sdk.Coins
}

// BasicTier is the cookbook tier which doesn't allow paid recipes which means
// the developers cannot have recipes where they can actually charge a fee in pylons
//var BasicTier = Tier{
//	Tier: Basic,
//	Fee:   BasicFee,
//}

// PremiumTier the cookbook tier which does allow paid recipes
//var PremiumTier = Tier{
//	Tier: Premium,
//	Fee:   PremiumFee,
//}

// ValidateTier validates the tier
func ValidateTier(tier int64) error {
	if tier == Basic || tier == Premium {
		return nil
	}

	return sdkerrors.Wrap(ErrInvalidRequestField, "invalid cookbook plan")
}
