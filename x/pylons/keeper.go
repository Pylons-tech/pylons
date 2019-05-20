package pylons

import (
	"github.com/cosmos/cosmos-sdk/codec"
	"github.com/cosmos/cosmos-sdk/x/bank"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// Keeper maintains the link to data storage and exposes getter/setter methods for the various parts of the state machine
type Keeper struct {
	coinKeeper bank.Keeper
	storeKey   sdk.StoreKey // Unexposed key to access store from sdk.Context
	cdc        *codec.Codec // The wire codec for binary encoding/decoding.
}
