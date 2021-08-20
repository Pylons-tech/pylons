package keeper_test

import (
	"testing"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func TestListRecipesByCookbook(t *testing.T) {
	k, ctx := setupKeeper(t)
	wctx := sdk.WrapSDKContext(ctx)
	cookbooks := createNCookbook(&k, ctx, 1)
	msgs := createNRecipe(&k, ctx, cookbooks[0], 10)

	for _, tc := range []struct {
		desc     string
		request  *types.QueryListRecipesByCookbookRequest
		response *types.QueryListRecipesByCookbookResponse
		err      error
	}{
		{
			desc:     "First",
			request:  &types.QueryListRecipesByCookbookRequest{CookbookID: cookbooks[0].ID},
			response: &types.QueryListRecipesByCookbookResponse{Recipes: msgs},
		},
		{
			desc:     "NoRecipes",
			request:  &types.QueryListRecipesByCookbookRequest{CookbookID: "missing"},
			response: &types.QueryListRecipesByCookbookResponse{Recipes: []types.Recipe(nil)},
		},
		{
			desc: "InvalidRequest",
			err:  status.Error(codes.InvalidArgument, "invalid request"),
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			response, err := k.ListRecipesByCookbook(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.Equal(t, tc.response, response)
			}
		})
	}
}
