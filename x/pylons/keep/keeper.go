package keep

import (
	"github.com/cosmos/cosmos-sdk/codec"
	"github.com/cosmos/cosmos-sdk/x/bank"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// Keeper maintains the link to data storage and exposes getter/setter methods for the various parts of the state machine
type Keeper struct {
	CoinKeeper    bank.Keeper
	EntityKey     sdk.StoreKey
	ExecutionKey  sdk.StoreKey
	CookbookKey   sdk.StoreKey
	RecipeKey     sdk.StoreKey
	ItemKey       sdk.StoreKey
	TradeKey      sdk.StoreKey
	LockedCoinKey sdk.StoreKey
	Cdc           *codec.Codec // The wire codec for binary encoding/decoding
}

// NewKeeper creates a new Keeper
func NewKeeper(coinKeeper bank.Keeper, entityKey, cookbookKey, recipeKey, itemKey, execKey sdk.StoreKey, tradeKey sdk.StoreKey, lockedCoinKey sdk.StoreKey, cdc *codec.Codec) Keeper {
	return Keeper{
		CoinKeeper:    coinKeeper,
		EntityKey:     entityKey,
		ExecutionKey:  execKey,
		CookbookKey:   cookbookKey,
		RecipeKey:     recipeKey,
		ItemKey:       itemKey,
		TradeKey:      tradeKey,
		LockedCoinKey: lockedCoinKey,
		Cdc:           cdc,
	}
}

// HasCoins checks if the sender has enough coins
func HasCoins(keeper Keeper, ctx sdk.Context, sender sdk.AccAddress, amount sdk.Coins) bool {
	lockedCoin := keeper.GetLockedCoin(ctx, sender)
	newAmount := lockedCoin.Amount.Sort().Add(amount.Sort()...)
	return keeper.CoinKeeper.HasCoins(ctx, sender, newAmount)
}

// SendCoins send coins
func SendCoins(keeper Keeper, ctx sdk.Context, fromAddr sdk.AccAddress, toAddr sdk.AccAddress, amount sdk.Coins) error {
	if HasCoins(keeper, ctx, fromAddr, amount) {
		return keeper.CoinKeeper.SendCoins(ctx, fromAddr, toAddr, amount)
	}

	return sdkerrors.Wrap(sdkerrors.ErrInsufficientFunds, "the sender doesn't have sufficient coins")
}
