package queriers

import (
	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	abci "github.com/tendermint/tendermint/abci/types"
)

// query endpoints supported by the nameservice Querier
const (
	KeyListExecutions = "list_executions"
)

// ExecResp is the response for ListExecutions
type ExecResp struct {
	Executions []types.Execution
}

// ListExecutions lists all the executions based on the sender address
func ListExecutions(ctx sdk.Context, path []string, req abci.RequestQuery, keeper keep.Keeper) ([]byte, sdk.Error) {
	sender := path[0]
	senderAddr, err := sdk.AccAddressFromBech32(sender)

	if err != nil {
		return nil, sdk.ErrInternal(err.Error())
	}
	execs, err := keeper.GetExecutionsBySender(ctx, senderAddr)

	if err != nil {
		return nil, sdk.ErrInternal(err.Error())
	}

	execResp := ExecResp{
		Executions: execs,
	}

	// if we cannot find the value then it should return an error
	mItems, err := keeper.Cdc.MarshalJSON(execResp)
	if err != nil {
		return nil, sdk.ErrInternal(err.Error())
	}

	return mItems, nil

}
