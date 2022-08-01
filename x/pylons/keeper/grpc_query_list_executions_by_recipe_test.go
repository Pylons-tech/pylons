package keeper_test

import (
	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/query"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func (suite *IntegrationTestSuite) TestListExecutionsByRecipe() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	wctx := sdk.WrapSDKContext(ctx)
	cookbookID := "testCookbookID"
	recipeID := "testRecipeID"
	msgs := createNExecutionForSingleRecipe(k, ctx, 10, cookbookID, recipeID)

	requestFunc := func(next []byte, offset, limit uint64, total bool, cookbookID, recipeID string) *v1beta1.QueryListExecutionsByRecipeRequest {
		return &v1beta1.QueryListExecutionsByRecipeRequest{
			Pagination: &query.PageRequest{
				Key:        next,
				Offset:     offset,
				Limit:      limit,
				CountTotal: total,
			},
			CookbookId: cookbookID,
			RecipeId:   recipeID,
		}
	}

	for _, tc := range []struct {
		desc     string
		request  *v1beta1.QueryListExecutionsByRecipeRequest
		response *v1beta1.QueryListExecutionsByRecipeResponse
		err      error
	}{
		{
			desc:     "ByOffset",
			request:  requestFunc(nil, 5, 5, false, cookbookID, recipeID),
			response: &v1beta1.QueryListExecutionsByRecipeResponse{CompletedExecutions: msgs[5:]},
		},
		{
			desc:     "All",
			request:  requestFunc(nil, 0, 0, true, cookbookID, recipeID),
			response: &v1beta1.QueryListExecutionsByRecipeResponse{CompletedExecutions: msgs},
		},
		{
			desc:     "NoExecutions",
			request:  requestFunc(nil, 5, 5, true, "missing", "missing"),
			response: &v1beta1.QueryListExecutionsByRecipeResponse{CompletedExecutions: []v1beta1.Execution{}},
		},
		{
			desc: "InvalidRequest",
			err:  status.Error(codes.InvalidArgument, "invalid request"),
		},
	} {
		tc := tc
		suite.Run(tc.desc, func() {
			response, err := k.ListExecutionsByRecipe(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(err, tc.err)
			} else {
				require.Equal(tc.response.CompletedExecutions, response.CompletedExecutions)
			}
		})
	}
}
