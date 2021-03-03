package queriers

import (
	"context"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
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
func (querier *querierServer) ListExecutions(ctx context.Context, req *types.ListExecutionsRequest) (*types.ListExecutionsResponse, error) {
	if req.Sender == "" {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "no address is provided in path")
	}

	senderAddr, err := sdk.AccAddressFromBech32(req.Sender)

	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}
	execs, err := querier.Keeper.GetExecutionsBySender(sdk.UnwrapSDKContext(ctx), senderAddr)

	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	return &types.ListExecutionsResponse{
		Executions: types.ExecutionsToListProto(execs),
	}, nil
}
