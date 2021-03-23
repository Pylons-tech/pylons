package queriers

import (
	"context"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// query endpoints supported by the nameservice Querier
const (
	KeyGetExecution = "get_execution"
)

// GetExecution returns an execution based on the execution id
func (querier *querierServer) GetExecution(ctx context.Context, req *types.GetExecutionRequest) (*types.GetExecutionResponse, error) {
	if req.ExecutionID == "" {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "no execution id is provided in path")
	}

	exec, err := querier.Keeper.GetExecution(sdk.UnwrapSDKContext(ctx), req.ExecutionID)

	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	return &types.GetExecutionResponse{
		NodeVersion: exec.NodeVersion,
		ID:          exec.ID,
		RecipeID:    exec.RecipeID,
		CookbookID:  exec.CookbookID,
		CoinsInput:  exec.CoinInputs,
		ItemInputs:  exec.ItemInputs,
		BlockHeight: exec.BlockHeight,
		Sender:      exec.Sender,
		Completed:   exec.Completed,
	}, nil

}
