package keep

import (
	"errors"

	"github.com/cosmos/cosmos-sdk/codec"
	"github.com/cosmos/cosmos-sdk/x/bank"

	"github.com/MikeSofaer/pylons/x/pylons/types"
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

func (k Keeper) SetCookbook(ctx sdk.Context, name string, cookbook types.Cookbook) error {

	if cookbook.Sender.Empty() {
		return errors.New("the sender cannot be empty")

	}
	store := ctx.KVStore(k.StoreKey)

	store.Set([]byte(name), k.Cdc.MustMarshalBinaryBare(cookbook))
	return nil
}

func (k Keeper) GetCookbook() {

}

func (k Keeper) UpdateCookbook() {

}

func (k Keeper) DeleteCookbook() {

}
