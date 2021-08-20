package keeper_test

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
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
		suite.Run(tc.desc, func() {
			response, err := k.ListRecipesByCookbook(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(err, tc.err)
			} else {
				require.Equal(tc.response, response)
			}
		})
	}
}
