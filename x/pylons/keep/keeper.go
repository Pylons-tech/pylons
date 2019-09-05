package keep

import (
	"github.com/cosmos/cosmos-sdk/codec"
	"github.com/cosmos/cosmos-sdk/x/bank"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// Keeper maintains the link to data storage and exposes getter/setter methods for the various parts of the state machine
type Keeper struct {
	CoinKeeper  bank.Keeper
	CookbookKey sdk.StoreKey // Unexposed key to access cookbook store from sdk.Context
	RecipeKey   sdk.StoreKey
	ItemKey     sdk.StoreKey
	Cdc         *codec.Codec // The wire codec for binary encoding/decoding

}

// NewKeeper creates a new Keeper
func NewKeeper(coinKeeper bank.Keeper, cookbookKey, recipeKey, itemKey sdk.StoreKey, cdc *codec.Codec) Keeper {
	return Keeper{
		CoinKeeper:  coinKeeper,
		CookbookKey: cookbookKey,
		RecipeKey:   recipeKey,
		ItemKey:     itemKey,
		Cdc:         cdc,
	}
}
