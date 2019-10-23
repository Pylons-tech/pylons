package queriers

import (
	"github.com/MikeSofaer/pylons/x/pylons/keep"
	sdk "github.com/cosmos/cosmos-sdk/types"
	abci "github.com/tendermint/tendermint/abci/types"
)

// query endpoints supported by the nameservice Querier
const (
	KeyGetExecution = "get_execution"
)

// GetExecution returns an execution based on the execution id
func GetExecution(ctx sdk.Context, path []string, req abci.RequestQuery, keeper keep.Keeper) ([]byte, sdk.Error) {
	if len(path) == 0 {
		return nil, sdk.ErrInternal("no execution id is provided in path")
	}
	execID := path[0]
	exec, err := keeper.GetExecution(ctx, execID)

	if err != nil {
		return nil, sdk.ErrInternal(err.Error())
	}
	// if we cannot find the value then it should return an error
	bz, err := keeper.Cdc.MarshalJSON(exec)
	if err != nil {
		return nil, sdk.ErrInternal(err.Error())
	}

	return bz, nil

}
