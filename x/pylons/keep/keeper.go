package keep

import (
	"errors"

	"github.com/cosmos/cosmos-sdk/codec"
	"github.com/cosmos/cosmos-sdk/x/bank"
	"github.com/google/uuid"

	"fmt"

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
	mCB, err := k.Cdc.MarshalBinaryBare(cookbook)
	if err != nil {
		return err
	}
	store := ctx.KVStore(k.StoreKey)

	id := uuid.New()
	store.Set([]byte(id.String()), mCB)
	return nil
}

// GetCookbook returns cookbook based on UUID
func (k Keeper) GetCookbook(ctx sdk.Context, id string) types.Cookbook {
	store := ctx.KVStore(k.StoreKey)

	uCB := store.Get([]byte(id))
	var cookbook types.Cookbook

	k.Cdc.MustUnmarshalBinaryBare(uCB, &cookbook)
	return cookbook
}

// UpdateCookbook is used to update the cookbook using the id
func (k Keeper) UpdateCookbook(ctx sdk.Context, id string, cookbook types.Cookbook) error {
	if cookbook.Sender.Empty() {
		return errors.New("the sender cannot be empty")

	}
	store := ctx.KVStore(k.StoreKey)

	if !store.Has([]byte(id)) {
		return fmt.Errorf("the cookbook with gid %s does not exist", id)
	}
	mCB, err := k.Cdc.MarshalBinaryBare(cookbook)
	if err != nil {
		return err
	}
	store.Set([]byte(id), mCB)
	return nil
}

// func (k Keeper) GetCookbooksIterator(ctx sdk.Context) sdk.Iterator {

// }

// DeleteCookbook
func (k Keeper) DeleteCookbook(ctx sdk.Context, id string) {
	store := ctx.KVStore(k.StoreKey)
	store.Delete([]byte(id))
}
