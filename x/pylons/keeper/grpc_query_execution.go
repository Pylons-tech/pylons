package keeper

import (
	"context"

	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/cosmos/cosmos-sdk/types/query"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k Keeper) ExecutionAll(c context.Context, req *types.QueryAllExecutionRequest) (*types.QueryAllExecutionResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}

	var executions []*types.Execution
	ctx := sdk.UnwrapSDKContext(c)

	store := ctx.KVStore(k.storeKey)
	executionStore := prefix.NewStore(store, types.KeyPrefix(types.ExecutionKey))

	pageRes, err := query.Paginate(executionStore, req.Pagination, func(key []byte, value []byte) error {
		var execution types.Execution
		if err := k.cdc.UnmarshalBinaryBare(value, &execution); err != nil {
			return err
		}

		executions = append(executions, &execution)
		return nil
	})

	if err != nil {
		return nil, status.Error(codes.Internal, err.Error())
	}

	return &types.QueryAllExecutionResponse{Execution: executions, Pagination: pageRes}, nil
}

func (k Keeper) Execution(c context.Context, req *types.QueryGetExecutionRequest) (*types.QueryGetExecutionResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}

	var execution types.Execution
	ctx := sdk.UnwrapSDKContext(c)

	if !k.HasExecution(ctx, req.Id) {
		return nil, sdkerrors.ErrKeyNotFound
	}

	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.ExecutionKey))
	k.cdc.MustUnmarshalBinaryBare(store.Get(GetExecutionIDBytes(req.Id)), &execution)

	return &types.QueryGetExecutionResponse{Execution: &execution}, nil
}
