package keeper_test

import (
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

// Test for GetRecipeHistory function

// TEST 1
// we create message (type: types.QueryGetRecipeHistoryRequest) with default CookbookId and RecipeId
// check if no error

// TEST 2
// we create nil message (type: types.QueryGetRecipeHistoryRequest)
// check if if error is proper
func (suite *IntegrationTestSuite) TestGetRecipeHistory() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	wctx := sdk.WrapSDKContext(ctx)

	for _, tc := range []struct {
		desc    string
		request *types.QueryGetRecipeHistoryRequest
		err     error
	}{
		{
			desc: "Completed",
			request: &types.QueryGetRecipeHistoryRequest{
				CookbookId: "any",
				RecipeId:   "any",
			},
		},
		{
			desc: "Invalid request",
			err:  status.Error(codes.InvalidArgument, "invalid request"),
		},
	} {
		tc := tc
		suite.Run(tc.desc, func() {
			_, err := k.GetRecipeHistory(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(err, tc.err)
			} else {
				require.NoError(err)
			}
		})
	}
}
