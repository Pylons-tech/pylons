package keeper_test

import (
	"testing"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func TestRecipeQuerySingle(t *testing.T) {
	k, ctx := setupKeeper(t)
	wctx := sdk.WrapSDKContext(ctx)
	cookbooks := createNCookbook(&k, ctx, 1)
	msgs := createNRecipe(&k, ctx, cookbooks[0], 2)
	for _, tc := range []struct {
		desc     string
		request  *types.QueryGetRecipeRequest
		response *types.QueryGetRecipeResponse
		err      error
	}{
		{
			desc:     "First",
			request:  &types.QueryGetRecipeRequest{CookbookID: msgs[0].CookbookID, ID: msgs[0].ID},
			response: &types.QueryGetRecipeResponse{Recipe: msgs[0]},
		},
		{
			desc:     "Second",
			request:  &types.QueryGetRecipeRequest{CookbookID: msgs[1].CookbookID, ID: msgs[1].ID},
			response: &types.QueryGetRecipeResponse{Recipe: msgs[1]},
		},
		{
			desc:    "KeyNotFound",
			request: &types.QueryGetRecipeRequest{CookbookID: "missing", ID: "missing"},
			err:     status.Error(codes.InvalidArgument, "not found"),
		},
		{
			desc: "InvalidRequest",
			err:  status.Error(codes.InvalidArgument, "invalid request"),
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			response, err := k.Recipe(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.Equal(t, tc.response, response)
			}
		})
	}
}
