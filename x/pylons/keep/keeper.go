package keep

import (
	"github.com/cosmos/cosmos-sdk/codec"
	"github.com/cosmos/cosmos-sdk/x/bank"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// Keeper maintains the link to data storage and exposes getter/setter methods for the various parts of the state machine
type Keeper struct {
	CoinKeeper        bank.Keeper
	Cdc               *codec.Codec // The wire codec for binary encoding/decoding
	EntityKey         sdk.StoreKey
	GoogleIAPOrderKey sdk.StoreKey
	CookbookKey       sdk.StoreKey
	RecipeKey         sdk.StoreKey
	ItemKey           sdk.StoreKey
	ExecutionKey      sdk.StoreKey
	TradeKey          sdk.StoreKey
	LockedCoinKey     sdk.StoreKey
}

// NewKeeper creates a new Keeper
func NewKeeper(coinKeeper bank.Keeper, cdc *codec.Codec, storeKeys map[string]*sdk.KVStoreKey) Keeper {
	return Keeper{
		CoinKeeper:        coinKeeper,
		Cdc:               cdc,
		EntityKey:         storeKeys[KeyPylonsEntity],
		GoogleIAPOrderKey: storeKeys[KeyGoogleIAPOrder],
		CookbookKey:       storeKeys[KeyPylonsCookbook],
		RecipeKey:         storeKeys[KeyPylonsRecipe],
		ItemKey:           storeKeys[KeyPylonsItem],
		ExecutionKey:      storeKeys[KeyPylonsExecution],
		TradeKey:          storeKeys[KeyPylonsTrade],
		LockedCoinKey:     storeKeys[KeyPylonsLockedCoin],
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
