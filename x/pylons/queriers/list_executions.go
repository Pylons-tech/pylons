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

func (er ExecResp) String() string {
	output := "ExecResp{"
	for _, e := range er.Executions {
		output += e.String()
		output += ",\n"
	}
	output += "}"
	return output
}

// ListExecutions lists all the executions based on the sender address
func ListExecutions(ctx sdk.Context, path []string, req abci.RequestQuery, keeper keep.Keeper) ([]byte, sdk.Error) {
	if len(path) == 0 {
		return nil, sdk.ErrInternal("no address is provided in path")
	}

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
