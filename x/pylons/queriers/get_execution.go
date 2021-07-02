package queriers

import (
	"context"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/Pylons-tech/pylons/x/pylons/types"
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
		Executions: execs,
	}, nil
}

// ListRecipeExecutions lists all executions of a recipe for all addresses
func (querier *querierServer) ListRecipeExecutions(ctx context.Context, req *types.ListRecipeExecutionsRequest) (*types.ListRecipeExecutionsResponse, error) {
	if req.Recipe == "" {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "no recipe provided")
	}

	// check if recipe exists in store
	_, err := querier.Keeper.GetRecipe(sdk.UnwrapSDKContext(ctx), req.Recipe)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	var executions []types.Execution
	// iterate through all Executions to build return slice
	allExec := querier.Keeper.GetExecutions(sdk.UnwrapSDKContext(ctx))
	for _, e := range allExec {
		if e.RecipeID == req.Recipe {
			executions = append(executions, e)
		}
	}

	return &types.ListRecipeExecutionsResponse{
		Executions: executions,
	}, nil
}
