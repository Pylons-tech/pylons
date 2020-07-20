package keep

import (
	"github.com/cosmos/cosmos-sdk/codec"
	"github.com/cosmos/cosmos-sdk/x/bank"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// Keeper maintains the link to data storage and exposes getter/setter methods for the various parts of the state machine
type Keeper struct {
	CoinKeeper        bank.Keeper
	EntityKey         sdk.StoreKey
	GoogleIAPOrderKey sdk.StoreKey
	ExecutionKey      sdk.StoreKey
	CookbookKey       sdk.StoreKey
	RecipeKey         sdk.StoreKey
	ItemKey           sdk.StoreKey
	TradeKey          sdk.StoreKey
	Cdc               *codec.Codec // The wire codec for binary encoding/decoding
}

// NewKeeper creates a new Keeper
func NewKeeper(coinKeeper bank.Keeper, entityKey, googleIAPOrderKey, cookbookKey, recipeKey, itemKey, execKey sdk.StoreKey, tradeKey sdk.StoreKey, cdc *codec.Codec) Keeper {
	return Keeper{
		CoinKeeper:        coinKeeper,
		EntityKey:         entityKey,
		GoogleIAPOrderKey: googleIAPOrderKey,
		ExecutionKey:      execKey,
		CookbookKey:       cookbookKey,
		RecipeKey:         recipeKey,
		ItemKey:           itemKey,
		TradeKey:          tradeKey,
		Cdc:               cdc,
	}
}
