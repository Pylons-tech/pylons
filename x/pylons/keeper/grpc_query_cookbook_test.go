package keeper

import (
	"testing"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func TestCookbookQuerySingle(t *testing.T) {
	keeper, ctx := setupKeeper(t)
	wctx := sdk.WrapSDKContext(ctx)
	msgs := createNCookbook(keeper, ctx, 2)
	for _, tc := range []struct {
		desc     string
		request  *types.QueryGetCookbookRequest
		response *types.QueryGetCookbookResponse
		err      error
	}{
		{
			desc:     "First",
			request:  &types.QueryGetCookbookRequest{Index: msgs[0].Index},
			response: &types.QueryGetCookbookResponse{Cookbook: &msgs[0]},
		},
		{
			desc:     "Second",
			request:  &types.QueryGetCookbookRequest{Index: msgs[1].Index},
			response: &types.QueryGetCookbookResponse{Cookbook: &msgs[1]},
		},
		{
			desc:    "KeyNotFound",
			request: &types.QueryGetCookbookRequest{Index: "missing"},
			err:     status.Error(codes.InvalidArgument, "not found"),
		},
		{
			desc: "InvalidRequest",
			err:  status.Error(codes.InvalidArgument, "invalid request"),
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			response, err := keeper.Cookbook(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.Equal(t, tc.response, response)
			}
		})
	}
}
