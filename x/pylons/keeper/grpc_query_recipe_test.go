package keeper

import (
	"testing"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func TestRecipeQuerySingle(t *testing.T) {
	keeper, ctx := setupKeeper(t)
	wctx := sdk.WrapSDKContext(ctx)
	msgs := createNRecipe(keeper, ctx, 2)
	for _, tc := range []struct {
		desc     string
		request  *types.QueryGetRecipeRequest
		response *types.QueryGetRecipeResponse
		err      error
	}{
		{
			desc:     "First",
			request:  &types.QueryGetRecipeRequest{Index: msgs[0].Index},
			response: &types.QueryGetRecipeResponse{Recipe: &msgs[0]},
		},
		{
			desc:     "Second",
			request:  &types.QueryGetRecipeRequest{Index: msgs[1].Index},
			response: &types.QueryGetRecipeResponse{Recipe: &msgs[1]},
		},
		{
			desc:    "KeyNotFound",
			request: &types.QueryGetRecipeRequest{Index: "missing"},
			err:     status.Error(codes.InvalidArgument, "not found"),
		},
		{
			desc: "InvalidRequest",
			err:  status.Error(codes.InvalidArgument, "invalid request"),
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			response, err := keeper.Recipe(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.Equal(t, tc.response, response)
			}
		})
	}
}


