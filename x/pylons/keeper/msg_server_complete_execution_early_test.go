package keeper_test

import (
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (suite *IntegrationTestSuite) TestCompleteExecutionEarly() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()
	bk := suite.bankKeeper

	srv := keeper.NewMsgServerImpl(k)
	wctx := sdk.WrapSDKContext(ctx)

	amountToPay := sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(10)))
	creator := types.GenTestBech32FromString("test")
	cookbookMsg := &types.MsgCreateCookbook{
		Creator:      creator,
		ID:           "testCookbookID",
		Name:         "testCookbookName",
		Description:  "descdescdescdescdescdesc",
		Version:      "v0.0.1",
		SupportEmail: "test@email.com",
		CostPerBlock: sdk.Coin{Denom: types.PylonsCoinDenom, Amount: sdk.OneInt()},
		Enabled:      true,
	}
	_, err := srv.CreateCookbook(wctx, cookbookMsg)
	require.NoError(err)
	recipeMsg := &types.MsgCreateRecipe{
		Creator:       creator,
		CookbookID:    "testCookbookID",
		ID:            "testRecipeID",
		Name:          "recipeName",
		Description:   "descdescdescdescdescdesc",
		Version:       "v0.0.1",
		BlockInterval: amountToPay.AmountOf(types.PylonsCoinDenom).Int64(),
		Enabled:       true,
	}
	_, err = srv.CreateRecipe(wctx, recipeMsg)
	require.NoError(err)
	recipe, found := k.GetRecipe(ctx, recipeMsg.CookbookID, recipeMsg.ID)
	require.True(found)
	// create only one pendingExecution
	pendingExecution := createNPendingExecutionForSingleRecipe(k, ctx, 1, recipe)[0]

	// give coins to requester
	requesterAddr, err := sdk.AccAddressFromBech32(pendingExecution.Creator)
	require.NoError(err)
	err = k.MintCoinsToAddr(ctx, requesterAddr, amountToPay)
	require.NoError(err)

	// submit early execution request
	completeEarly := &types.MsgCompleteExecutionEarly{
		Creator: pendingExecution.Creator,
		ID:      pendingExecution.ID,
	}
	resp, err := srv.CompleteExecutionEarly(wctx, completeEarly)
	require.NoError(err)

	// manually trigger complete execution - simulate endBlocker
	pendingExecution = k.GetPendingExecution(ctx, resp.ID)
	execution, _, _, err := k.CompletePendingExecution(ctx, pendingExecution)
	require.NoError(err)
	k.ActualizeExecution(ctx, execution)

	// verify execution completion and that requester has no balance left
	require.True(k.HasExecution(ctx, resp.ID))
	balance := bk.SpendableCoins(ctx, requesterAddr)
	require.Nil(balance)
}
