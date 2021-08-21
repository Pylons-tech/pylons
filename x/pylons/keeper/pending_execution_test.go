package keeper_test

import (
	"github.com/Pylons-tech/pylons/x/pylons/keeper"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func createNPendingExecution(k keeper.Keeper, ctx sdk.Context, n int) []types.Execution {
	items := make([]types.Execution, n)
	for i := range items {
		items[i].Creator = "any"
		items[i].ID = k.AppendPendingExecution(ctx, items[i], 0)
	}
	return items
}

func (suite *IntegrationTestSuite) TestPendingExecutionGet() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	items := createNPendingExecution(k, ctx, 10)
	for _, item := range items {
		require.Equal(item, k.GetPendingExecution(ctx, item.ID))
	}
}

func (suite *IntegrationTestSuite) TestPendingExecutionExist() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	items := createNPendingExecution(k, ctx, 10)
	for _, item := range items {
		require.True(k.HasPendingExecution(ctx, item.ID))
	}
}

func (suite *IntegrationTestSuite) TestPendingExecutionGetAll() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	items := createNPendingExecution(k, ctx, 10)
	require.Equal(items, k.GetAllPendingExecution(ctx))
}

func (suite *IntegrationTestSuite) TestPendingExecutionCount() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	items := createNPendingExecution(k, ctx, 10)
	count := uint64(len(items))
	require.Equal(count, k.GetPendingExecutionCount(ctx))
}
