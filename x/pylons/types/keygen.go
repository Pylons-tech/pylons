package types

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/google/uuid"
)

// KeyGen generates key for the store
func KeyGen(sender sdk.AccAddress) string {
	id := uuid.New()
	return sender.String() + id.String()
}
