package keeper_test

func (suite *IntegrationTestSuite) TestExecutionGet() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	items := createNExecution(k, ctx, 10)
	for _, item := range items {
		require.Equal(item, k.GetExecution(ctx, item.ID))
	}
}

// TODO verify and add more test cases
func (suite *IntegrationTestSuite) TestExecutionsGetByItem() {
	numExecs := 10
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	itemExecs := createNExecutionForSingleItem(k, ctx, numExecs)
	itemCookbookID := itemExecs[0].CookbookID
	itemItemID := itemExecs[0].ItemOutputIDs[0]

	execs, _ := k.GetAllExecutionByItem(ctx, itemCookbookID, itemItemID)
	require.Equal(numExecs, len(itemExecs))
	require.Equal(numExecs, len(execs))
	for i, exec := range execs {
		require.Equal(itemCookbookID, exec.CookbookID)
		require.Equal(itemExecs[i].ID, exec.ID)
	}
}

// TODO verify and add more test cases
func (suite *IntegrationTestSuite) TestExecutionsGetByRecipe() {
	numExecs := 10
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	itemExecs := createNExecutionForSingleItem(k, ctx, numExecs)
	itemCookbookID := itemExecs[0].CookbookID
	recipeID := itemExecs[0].RecipeID

	execs, _ := k.GetAllExecutionByRecipe(ctx, itemCookbookID, recipeID)
	require.Equal(numExecs, len(itemExecs))
	require.Equal(numExecs, len(execs))
	for i, exec := range execs {
		require.Equal(itemCookbookID, exec.CookbookID)
		require.Equal(itemExecs[i].ID, exec.ID)
	}
}

func (suite *IntegrationTestSuite) TestExecutionExist() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	items := createNExecution(k, ctx, 10)
	for _, item := range items {
		require.True(k.HasExecution(ctx, item.ID))
	}
}

func (suite *IntegrationTestSuite) TestActualizeExecution() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	pending := createNPendingExecution(k, ctx, 1)
	k.ActualizeExecution(ctx, pending[0])
	require.Empty(k.GetPendingExecution(ctx, pending[0].ID))
	require.Equal(pending[0], k.GetExecution(ctx, pending[0].ID))
}

func (suite *IntegrationTestSuite) TestExecutionGetAll() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	execs := createNExecution(k, ctx, 10)
	require.Equal(execs, k.GetAllExecution(ctx))
}

func (suite *IntegrationTestSuite) TestExecutionCount() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	// actualize 10 executions
	numExecs := 10
	pending := createNPendingExecution(k, ctx, numExecs)
	for i := range pending {
		k.ActualizeExecution(ctx, pending[i])
		require.Empty(k.GetPendingExecution(ctx, pending[i].ID))
	}

	count := uint64(numExecs)
	keeperCount := k.GetExecutionCount(ctx)
	require.Equal(count, keeperCount)
}
