package keep

import (
	"encoding/json"
	"errors"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// SetExecution sets a exec in the key store
func (k Keeper) SetExecution(ctx sdk.Context, exec types.Execution) error {
	if exec.Sender.Empty() {
		return errors.New("SetExecution: the sender cannot be empty")
	}
	return k.SetObject(ctx, types.TypeExecution, exec.ID, k.ExecutionKey, exec)
}

// GetExecution returns exec based on UUID
func (k Keeper) GetExecution(ctx sdk.Context, id string) (types.Execution, error) {
	exec := types.Execution{}
	err := k.GetObject(ctx, types.TypeExecution, id, k.ExecutionKey, &exec)
	return exec, err
}

// UpdateExecution is used to update the exec using the id
func (k Keeper) UpdateExecution(ctx sdk.Context, id string, exec types.Execution) error {
	if exec.Sender.Empty() {
		return errors.New("UpdateExecution: the sender cannot be empty")
	}

	return k.UpdateObject(ctx, types.TypeExecution, id, k.ExecutionKey, exec)
}

// GetExecutionsBySender returns all delayed excutions by sender
func (k Keeper) GetExecutionsBySender(ctx sdk.Context, sender sdk.AccAddress) ([]types.Execution, error) {
	store := ctx.KVStore(k.ExecutionKey)
	iter := sdk.KVStorePrefixIterator(store, []byte(sender.String()))

	var execs []types.Execution
	for ; iter.Valid(); iter.Next() {
		var exec types.Execution
		mExec := iter.Value()
		err := json.Unmarshal(mExec, &exec)
		if err != nil {
			return nil, sdk.ErrInternal(err.Error())
		}
		execs = append(execs, exec)
	}
	return execs, nil
}

// GetPendingExecutionsBySender returns all the pending executions by sender
func (k Keeper) GetPendingExecutionsBySender(ctx sdk.Context, sender sdk.AccAddress) ([]types.Execution, error) {
	var pExecs []types.Execution
	execs, err := k.GetExecutionsBySender(ctx, sender)
	if err != nil {
		return nil, err
	}

	for _, exec := range execs {
		// if the execution is not completed
		if !exec.Completed {
			pExecs = append(pExecs, exec)
		}

	}
	return pExecs, nil
}
