package keeper_test

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/query"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (suite *IntegrationTestSuite) TestListRecipesByCookbook() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	wctx := sdk.WrapSDKContext(ctx)
	cookbooks := createNCookbook(k, ctx, 1)
	msgs := createNRecipe(&k, ctx, cookbooks[0], 10)

	requestFunc := func(next []byte, offset, limit uint64, total bool, cookbookID string) *types.QueryListRecipesByCookbookRequest {
		return &types.QueryListRecipesByCookbookRequest{
			Pagination: &query.PageRequest{
				Key:        next,
				Offset:     offset,
				Limit:      limit,
				CountTotal: total,
			},
			CookbookID: cookbookID,
		}
	}

	for _, tc := range []struct {
		desc     string
		request  *types.QueryListRecipesByCookbookRequest
		response *types.QueryListRecipesByCookbookResponse
		err      error
	}{
		{
			desc:     "ByOffset",
			request:  requestFunc(nil, 0, 5, false, cookbooks[0].ID),
			response: &types.QueryListRecipesByCookbookResponse{Recipes: msgs[:5]},
		},
		{
			desc:     "All",
			request:  requestFunc(nil, 0, 0, true, cookbooks[0].ID),
			response: &types.QueryListRecipesByCookbookResponse{Recipes: msgs},
		},
		{
			desc:     "NoRecipes",
			request:  requestFunc(nil, 0, 0, true, "missing"),
			response: &types.QueryListRecipesByCookbookResponse{Recipes: []types.Recipe{}},
		},
		{
			desc: "InvalidRequest",
			err:  status.Error(codes.InvalidArgument, "invalid request"),
		},
	} {
		tc := tc
		suite.Run(tc.desc, func() {
			response, err := k.ListRecipesByCookbook(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(err, tc.err)
			} else {
				require.Equal(tc.response.Recipes, response.Recipes)
			}
		})
	}
}
