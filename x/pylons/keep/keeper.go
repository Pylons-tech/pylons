package keep

import (
	"fmt"

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
	// LockedCoinList types.LockedCoinList
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

// HasCoins checks if the send has enough coins
func HasCoins(keeper Keeper, ctx sdk.Context, sender sdk.AccAddress, amt sdk.Coins) bool {
	fmt.Print("\n\n\n----------      keep.HasCoins begin     ----------\n\nsender's balance:\n",
		keeper.CoinKeeper.GetCoins(ctx, sender).String(),
		"\n\namt:\n", amt.String())

	lockedCoin, err := keeper.GetLockedCoin(ctx, sender)
	fmt.Print("\n\nlocked coin:\n", lockedCoin.String(), "\n", err)

	if err == nil {
		newAmount := lockedCoin.Amount.Sort().Add(amt.Sort()...)
		fmt.Print("\n\nnewAmount:\n", newAmount.String())

		fmt.Print("\n\n----------      keep.HasCoins end     ----------\n\n")
		return keeper.CoinKeeper.HasCoins(ctx, sender, newAmount)
	}

	if lockedCoin.Amount.Empty() {
		fmt.Print("\n\n----------      EMPTY!   keep.HasCoins end     ----------\n\n")
		return keeper.CoinKeeper.HasCoins(ctx, sender, amt)
	}

	fmt.Print("\n\n----------      keep.HasCoins end     ----------\n\n")
	return false
}

// SendCoins send coins
func SendCoins(keeper Keeper, ctx sdk.Context, fromAddr sdk.AccAddress, toAddr sdk.AccAddress, amt sdk.Coins) error {
	if HasCoins(keeper, ctx, fromAddr, amt) {
		return keeper.CoinKeeper.SendCoins(ctx, fromAddr, toAddr, amt)
	}

	return sdkerrors.Wrap(sdkerrors.ErrInsufficientFunds, "the sender doesn't have sufficient coins")
}
