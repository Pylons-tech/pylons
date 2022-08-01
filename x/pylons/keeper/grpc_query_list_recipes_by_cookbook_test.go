package keeper_test

import (
	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/query"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func (suite *IntegrationTestSuite) TestListRecipesByCookbook() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	wctx := sdk.WrapSDKContext(ctx)
	cookbooks := createNCookbook(k, ctx, 1)
	msgs := createNRecipe(k, ctx, cookbooks[0], 10)

	requestFunc := func(next []byte, offset, limit uint64, total bool, cookbookID string) *v1beta1.QueryListRecipesByCookbookRequest {
		return &v1beta1.QueryListRecipesByCookbookRequest{
			Pagination: &query.PageRequest{
				Key:        next,
				Offset:     offset,
				Limit:      limit,
				CountTotal: total,
			},
			CookbookId: cookbookID,
		}
	}

	for _, tc := range []struct {
		desc     string
		request  *v1beta1.QueryListRecipesByCookbookRequest
		response *v1beta1.QueryListRecipesByCookbookResponse
		err      error
	}{
		{
			desc:     "ByLimit",
			request:  requestFunc(nil, 0, 5, false, cookbooks[0].Id),
			response: &v1beta1.QueryListRecipesByCookbookResponse{Recipes: msgs[:5]},
		},
		{
			desc:     "All",
			request:  requestFunc(nil, 0, 0, true, cookbooks[0].Id),
			response: &v1beta1.QueryListRecipesByCookbookResponse{Recipes: msgs},
		},
		{
			desc:     "NoRecipes",
			request:  requestFunc(nil, 0, 0, true, "missing"),
			response: &v1beta1.QueryListRecipesByCookbookResponse{Recipes: []v1beta1.Recipe{}},
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
