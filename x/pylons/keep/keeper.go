package keep

import (
	"errors"

	"github.com/cosmos/cosmos-sdk/codec"
	"github.com/cosmos/cosmos-sdk/x/bank"
	"github.com/google/guid"

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

// SetCookbook sets the cookbook with the name as the key
func (k Keeper) SetCookbook(ctx sdk.Context, cookbook types.Cookbook) error {

	if cookbook.Sender.Empty() {
		return errors.New("the sender cannot be empty")

	}
	store := ctx.KVStore(k.StoreKey)

	id := guid.New()
	store.Set([]byte(id), k.Cdc.MustMarshalBinaryBare(cookbook))
	return nil
}

// GetCookbook returns cookbook based on UUID
func (k Keeper) GetCookbook(ctx sdk.Context, id string) types.Cookbook {
	if cookbook.Sender.Empty() {
		return errors.New("the sender cannot be empty")
	}

	store := ctx.KVStore(k.StoreKey)

	uCB := store.Get([]byte(id))
	var cookbook types.Cookbook

	k.cdc.MustUnmarshalBinaryBare(uCB, &cookbook)
	return cookbook
}

func (k Keeper) UpdateCookbook() {

}

func (k Keeper) DeleteCookbook() {

}
