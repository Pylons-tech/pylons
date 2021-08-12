package keeper

import (
	"testing"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func TestItemQuerySingle(t *testing.T) {
	keeper, ctx := setupKeeper(t)
	wctx := sdk.WrapSDKContext(ctx)
	msgs := createNItem(&keeper, ctx, 2)
	for _, tc := range []struct {
		desc     string
		request  *types.QueryGetItemRequest
		response *types.QueryGetItemResponse
		err      error
	}{
		{
			desc:     "First",
			request:  &types.QueryGetItemRequest{CookbookID: msgs[0].CookbookID, ID: msgs[0].ID},
			response: &types.QueryGetItemResponse{Item: &msgs[0]},
		},
		{
			desc:     "Second",
			request:  &types.QueryGetItemRequest{CookbookID: msgs[1].CookbookID, ID: msgs[1].ID},
			response: &types.QueryGetItemResponse{Item: &msgs[1]},
		},
		{
			desc:    "KeyNotFound",
			request: &types.QueryGetItemRequest{ID: "missing"},
			err:     status.Error(codes.InvalidArgument, "not found"),
		},
		{
			desc: "InvalidRequest",
			err:  status.Error(codes.InvalidArgument, "invalid request"),
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			response, err := keeper.Item(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.Equal(t, tc.response, response)
			}
		})
	}
}
