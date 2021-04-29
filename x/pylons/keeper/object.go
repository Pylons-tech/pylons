package keeper

import (
	"encoding/json"
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// SetObject set custom object in ctx store
func (k Keeper) SetObject(ctx sdk.Context, storageType, id string, keeperKey sdk.StoreKey, object interface{}) error {

	mObject, err := json.Marshal(object)
	if err != nil {
		return err
	}
	store := ctx.KVStore(keeperKey)
	store.Set([]byte(id), mObject)
	k.IncreaseEntityCount(ctx)
	return nil
}

// GetObject unmarshals to the object provided
func (k Keeper) GetObject(ctx sdk.Context, storageType, id string, keeperKey sdk.StoreKey, object interface{}) error {
	store := ctx.KVStore(keeperKey)

	if !store.Has([]byte(id)) {
		return fmt.Errorf("The %s doesn't exist", storageType)
	}

	mObject := store.Get([]byte(id))
	return json.Unmarshal(mObject, object)
}

// UpdateObject update object in ctx store
func (k Keeper) UpdateObject(ctx sdk.Context, storageType, id string, keeperKey sdk.StoreKey, object interface{}) error {
	store := ctx.KVStore(keeperKey)

	if !store.Has([]byte(id)) {
		return fmt.Errorf("The %s with gid %s does not exist", storageType, id)
	}
	mObject, err := json.Marshal(object)
	if err != nil {
		return err
	}
	store.Set([]byte(id), mObject)
	return nil
}

// DeleteObject delete object in ctx store
func (k Keeper) DeleteObject(ctx sdk.Context, storageType, id string, keeperKey sdk.StoreKey) error {
	store := ctx.KVStore(keeperKey)

	if !store.Has([]byte(id)) {
		return fmt.Errorf("The %s with the id %s doesn't exist", storageType, id)
	}
	store.Delete([]byte(id))
	return nil
}
