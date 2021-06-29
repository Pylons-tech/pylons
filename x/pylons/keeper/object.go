package keeper

import (
	"encoding/json"
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// SetObject set custom object in ctx store
func (keeper Keeper) SetObject(ctx sdk.Context, storageType, id string, keeperKey sdk.StoreKey, object interface{}) error {

	mObject, err := json.Marshal(object)
	if err != nil {
		return err
	}
	store := ctx.KVStore(keeperKey)
	store.Set([]byte(id), mObject)
	keeper.IncreaseEntityCount(ctx)
	return nil
}

// GetObject unmarshals to the object provided
func (keeper Keeper) GetObject(ctx sdk.Context, storageType, id string, keeperKey sdk.StoreKey, object interface{}) error {
	store := ctx.KVStore(keeperKey)

	if !store.Has([]byte(id)) {
		return fmt.Errorf("key %s not present in %s store", id, storageType)
	}

	mObject := store.Get([]byte(id))
	return json.Unmarshal(mObject, object)
}

// UpdateObject update object in ctx store
func (keeper Keeper) UpdateObject(ctx sdk.Context, storageType, id string, keeperKey sdk.StoreKey, object interface{}) error {
	store := ctx.KVStore(keeperKey)

	if !store.Has([]byte(id)) {
		return fmt.Errorf("key %s not present in %s store", id, storageType)
	}
	mObject, err := json.Marshal(object)
	if err != nil {
		return err
	}
	store.Set([]byte(id), mObject)
	return nil
}

// DeleteObject delete object in ctx store
func (keeper Keeper) DeleteObject(ctx sdk.Context, storageType, id string, keeperKey sdk.StoreKey) error {
	store := ctx.KVStore(keeperKey)

	if !store.Has([]byte(id)) {
		return fmt.Errorf("key %s not present in %s store", id, storageType)
	}
	store.Delete([]byte(id))
	return nil
}
