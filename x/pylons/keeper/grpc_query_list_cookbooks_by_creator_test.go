package keeper

import (
	"testing"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func TestListCookbooksByCreator(t *testing.T) {
	keeper, ctx := setupKeeper(t)
	wctx := sdk.WrapSDKContext(ctx)
	msgs := createNCookbook(keeper, ctx, 2)

	for _, tc := range []struct {
		desc     string
		request  *types.QueryListCookbooksByCreatorRequest
		response *types.QueryListCookbooksByCreatorResponse
		err      error
	}{
		{
			desc:     "First",
			request:  &types.QueryListCookbooksByCreatorRequest{Creator: msgs[0].Creator},
			response: &types.QueryListCookbooksByCreatorResponse{Cookbooks: []types.Cookbook{msgs[0]}},
		},
		{
			desc:     "Second",
			request:  &types.QueryListCookbooksByCreatorRequest{Creator: msgs[1].Creator},
			response: &types.QueryListCookbooksByCreatorResponse{Cookbooks: []types.Cookbook{msgs[1]}},
		},
		{
			desc:     "KeyNotFound",
			request:  &types.QueryListCookbooksByCreatorRequest{Creator: "missing"},
			response: &types.QueryListCookbooksByCreatorResponse{Cookbooks: []types.Cookbook(nil)},
		},
		{
			desc: "InvalidRequest",
			err:  status.Error(codes.InvalidArgument, "invalid request"),
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			response, err := keeper.ListCookbooksByCreator(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.Equal(t, tc.response, response)
			}
		})
	}
}
