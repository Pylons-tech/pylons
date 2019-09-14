package keep

import (
	"errors"
	"fmt"

	"github.com/MikeSofaer/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// SetExecution sets a exec in the key store
func (k Keeper) SetExecution(ctx sdk.Context, exec types.Execution) error {
	if exec.Sender.Empty() {
		return errors.New("SetExecution: the sender cannot be empty")
	}
	mr, err := k.Cdc.MarshalBinaryBare(exec)
	if err != nil {
		return err
	}

	store := ctx.KVStore(k.ExecutionKey)
	store.Set([]byte(exec.ID), mr)
	return nil
}

// GetExecution returns exec based on UUID
func (k Keeper) GetExecution(ctx sdk.Context, id string) (types.Execution, error) {
	store := ctx.KVStore(k.ExecutionKey)

	if !store.Has([]byte(id)) {
		return types.Execution{}, errors.New("The execution doesn't exist")
	}

	ur := store.Get([]byte(id))
	var exec types.Execution

	k.Cdc.MustUnmarshalBinaryBare(ur, &exec)
	return exec, nil
}

// UpdateExecution is used to update the exec using the id
func (k Keeper) UpdateExecution(ctx sdk.Context, id string, exec types.Execution) error {
	if exec.Sender.Empty() {
		return errors.New("UpdateExecution: the sender cannot be empty")

	}
	store := ctx.KVStore(k.ExecutionKey)

	if !store.Has([]byte(id)) {
		return fmt.Errorf("the exec with gid %s does not exist", id)
	}
	mr, err := k.Cdc.MarshalBinaryBare(exec)
	if err != nil {
		return err
	}
	store.Set([]byte(id), mr)
	return nil
}
