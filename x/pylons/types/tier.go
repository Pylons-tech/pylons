package types

import (
	"errors"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// Level is the kind of cookbook a developer can create
type Level int

const (
	// Basic is the free level which does allow developers to use pylons ( paid currency ) in their
	// games
	Basic Level = iota
	Premium
)

// Validate validates the Level
func (l Level) Validate() error {
	if l == Basic || l == Premium {
		return nil
	}

	return errors.New("Invalid cookbook plan")
}

var (

	// BasicFee is the fee charged to create a basic cookbook
	BasicFee = NewPylon(10000)

	// PremiumFee is the fee charged to create a premium cookbook
	PremiumFee = NewPylon(50000)
)

// Tier defines the kind of cookbook this is
type Tier struct {
	Level Level
	Fee   sdk.Coins
}

// BasicTier is the cookbook tier which doesn't allow paid receipes which means
// the developers cannot have receipes where they can actually carge a fee in pylons
var BasicTier = Tier{
	Level: Basic,
	Fee:   BasicFee,
}

var PremiumTier = Tier{
	Level: Premium,
	Fee:   PremiumFee,
}
