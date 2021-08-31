package keeper_test

import (
	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	bankTypes "github.com/cosmos/cosmos-sdk/x/bank/types"
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
		CostPerBlock: sdk.Coin{Denom: types.PylonsCoinDenom, Amount: sdk.NewInt(1)},
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

	// set initial supply to be not nil, any value will do
	supply := bankTypes.NewSupply(amountToPay)
	bk.SetSupply(ctx, supply)
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

	// verify payment and execution completion
	require.True(k.HasExecution(ctx, resp.ID))
	balance := bk.SpendableCoins(ctx, k.FeeCollectorAddress())
	require.True(balance.IsEqual(amountToPay))
}