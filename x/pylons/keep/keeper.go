package keep

import (
	"github.com/cosmos/cosmos-sdk/codec"
	"github.com/cosmos/cosmos-sdk/x/bank"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// Keeper maintains the link to data storage and exposes getter/setter methods for the various parts of the state machine
type Keeper struct {
	CoinKeeper bank.Keeper
	StoreKey   sdk.StoreKey // Unexposed key to access store from sdk.Context
	Cdc        *codec.Codec // The wire codec for binary encoding/decoding.
}

func NewKeeper(coinKeeper bank.Keeper, storeKey sdk.StoreKey, cdc *codec.Codec) Keeper {

	return Keeper{
		CoinKeeper: coinKeeper,
		StoreKey:   storeKey,
		Cdc:        cdc,
	}
}
