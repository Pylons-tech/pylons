package keeper

import (
	"github.com/cosmos/cosmos-sdk/codec"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	bankkeeper "github.com/cosmos/cosmos-sdk/x/bank/keeper"
)

// Keeper maintains the link to data storage and exposes getter/setter methods for the various parts of the state machine
type Keeper struct {
	CoinKeeper          bankkeeper.Keeper
	Cdc                 *codec.LegacyAmino // The wire codec for binary encoding/decoding
	EntityKey           sdk.StoreKey
	GoogleIAPOrderKey   sdk.StoreKey
	PaymentForStripeKey sdk.StoreKey
	CookbookKey         sdk.StoreKey
	RecipeKey           sdk.StoreKey
	ItemKey             sdk.StoreKey
	ExecutionKey        sdk.StoreKey
	TradeKey            sdk.StoreKey
	HistoryKey          sdk.StoreKey
	LockedCoinKey       sdk.StoreKey
	PaymentIDKey        sdk.StoreKey
}

// NewKeeper creates a new Keeper
func NewKeeper(coinKeeper bankkeeper.Keeper, cdc *codec.LegacyAmino, storeKeys map[string]*sdk.KVStoreKey) Keeper {
	return Keeper{
		CoinKeeper:          coinKeeper,
		Cdc:                 cdc,
		EntityKey:           storeKeys[KeyPylonsEntity],
		GoogleIAPOrderKey:   storeKeys[KeyGoogleIAPOrder],
		PaymentForStripeKey: storeKeys[KeyPaymentForStripe],
		CookbookKey:         storeKeys[KeyPylonsCookbook],
		RecipeKey:           storeKeys[KeyPylonsRecipe],
		ItemKey:             storeKeys[KeyPylonsItem],
		ExecutionKey:        storeKeys[KeyPylonsExecution],
		TradeKey:            storeKeys[KeyPylonsTrade],
		HistoryKey:          storeKeys[KeyPylonsHistory],
		LockedCoinKey:       storeKeys[KeyPylonsLockedCoin],
		PaymentIDKey:        storeKeys[KeyPylonsPaymentID],
	}
}

// HasCoins checks if the sender has enough coins
func HasCoins(keeper Keeper, ctx sdk.Context, sender sdk.AccAddress, amount sdk.Coins) bool {
	lockedCoin := keeper.GetLockedCoin(ctx, sender)
	newAmount := lockedCoin.Amount.Sort().Add(amount.Sort()...)
	for _, coin := range newAmount {
		if !keeper.CoinKeeper.HasBalance(ctx, sender, coin) {
			return false
		}
	}
	return true
}

// SendCoins send coins
func SendCoins(keeper Keeper, ctx sdk.Context, fromAddr sdk.AccAddress, toAddr sdk.AccAddress, amount sdk.Coins) error {
	if HasCoins(keeper, ctx, fromAddr, amount) {
		return keeper.CoinKeeper.SendCoins(ctx, fromAddr, toAddr, amount)
	}

	return sdkerrors.Wrap(sdkerrors.ErrInsufficientFunds, "the sender doesn't have sufficient coins")
}
