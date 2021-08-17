package keeper

import (
	"testing"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/stretchr/testify/require"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func TestExecutionQuerySingle(t *testing.T) {
	keeper, ctx := setupKeeper(t)
	wctx := sdk.WrapSDKContext(ctx)
	msgs := createNExecution(&keeper, ctx, 2)
	msgs = append(msgs, createNPendingExecution(&keeper, ctx, 1)...)
	for _, tc := range []struct {
		desc     string
		request  *types.QueryGetExecutionRequest
		response *types.QueryGetExecutionResponse
		err      error
	}{
		{
			desc:     "First",
			request:  &types.QueryGetExecutionRequest{ID: msgs[0].ID},
			response: &types.QueryGetExecutionResponse{Completed: true, Execution: msgs[0]},
		},
		{
			desc:     "Second",
			request:  &types.QueryGetExecutionRequest{ID: msgs[1].ID},
			response: &types.QueryGetExecutionResponse{Completed: true, Execution: msgs[1]},
		},
		{
			desc:     "Pending",
			request:  &types.QueryGetExecutionRequest{ID: msgs[2].ID},
			response: &types.QueryGetExecutionResponse{Completed: false, Execution: msgs[2]},
		},
		{
			desc:    "KeyNotFound",
			request: &types.QueryGetExecutionRequest{ID: "not_found"},
			err:     sdkerrors.ErrKeyNotFound,
		},
		{
			desc: "InvalidRequest",
			err:  status.Error(codes.InvalidArgument, "invalid request"),
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			response, err := keeper.Execution(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.Equal(t, tc.response, response)
			}
		})
	}
}
