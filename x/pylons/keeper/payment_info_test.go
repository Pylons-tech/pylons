package keeper_test

func (suite *IntegrationTestSuite) TestPaymentInfoGet() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()
	items := createNPaymentInfo(k, ctx, 10)
	for _, item := range items {
		rst, found := k.GetPaymentInfo(ctx, item.PurchaseId)
		require.True(found)
		require.Equal(item, rst)
	}
}

func (suite *IntegrationTestSuite) TestPaymentInfoGetAll() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()
	items := createNPaymentInfo(k, ctx, 10)
	require.Equal(items, k.GetAllPaymentInfo(ctx))
}
