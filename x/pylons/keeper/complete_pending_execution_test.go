package keeper_test

import (
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (suite *IntegrationTestSuite) TestCompletePendingExecution() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()
	bk := suite.bankKeeper
	ak := suite.accountKeeper

	srv := keeper.NewMsgServerImpl(k)
	wctx := sdk.WrapSDKContext(ctx)

	amountToPay := sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(100)))
	creator := types.GenTestBech32FromString("test")
	executor := types.GenTestBech32FromString("executor")
	feeCollectorAddr := ak.GetModuleAddress(types.FeeCollectorName)

	types.UpdateAppCheckFlagTest(types.FlagTrue)

	srv.CreateAccount(wctx, &types.MsgCreateAccount{
		Creator:  executor,
		Username: "Executor",
	})

	types.UpdateAppCheckFlagTest(types.FlagFalse)
	cookbookMsg := &types.MsgCreateCookbook{
		Creator:      creator,
		Id:           "testCookbookID",
		Name:         "testCookbookName",
		Description:  "descdescdescdescdescdesc",
		Version:      "v0.0.1",
		SupportEmail: "test@email.com",
		Enabled:      true,
	}
	_, err := srv.CreateCookbook(sdk.WrapSDKContext(suite.ctx), cookbookMsg)
	require.NoError(err)
	recipeMsg := &types.MsgCreateRecipe{
		Creator:       creator,
		CookbookId:    "testCookbookID",
		Id:            "testRecipeID",
		Name:          "recipeName",
		Description:   "descdescdescdescdescdesc",
		Version:       "v0.0.1",
		BlockInterval: 10,
		CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.ZeroInt()},
		CoinInputs:    []types.CoinInput{{Coins: amountToPay}},
		Enabled:       true,
	}
	_, err = srv.CreateRecipe(sdk.WrapSDKContext(suite.ctx), recipeMsg)
	require.NoError(err)

	// create only one pendingExecution
	msgExecution := &types.MsgExecuteRecipe{
		Creator:         executor,
		CookbookId:      "testCookbookID",
		RecipeId:        "testRecipeID",
		CoinInputsIndex: 0,
		ItemIds:         nil,
	}

	// give coins to requester
	suite.FundAccount(suite.ctx, sdk.MustAccAddressFromBech32(executor), amountToPay)

	resp, err := srv.ExecuteRecipe(sdk.WrapSDKContext(suite.ctx), msgExecution)
	require.NoError(err)

	// manually trigger complete execution - simulate endBlocker
	pendingExecution := k.GetPendingExecution(ctx, resp.Id)
	execution, _, _, err := k.CompletePendingExecution(suite.ctx, pendingExecution)
	require.NoError(err)
	k.ActualizeExecution(ctx, execution)

	// verify execution completion and that requester has no balance left,
	// also pay and fee are transfered to cookbook owner and fee collector module
	require.True(k.HasExecution(ctx, resp.Id))
	executorBalance := bk.SpendableCoins(ctx, sdk.MustAccAddressFromBech32(executor))
	creatorBalance := bk.SpendableCoins(ctx, sdk.MustAccAddressFromBech32(creator))
	feeCollectorBalance := bk.SpendableCoins(ctx, feeCollectorAddr)

	require.Nil(executorBalance)
	// should be 100 * 0.1 = 10
	require.Equal(feeCollectorBalance, sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(10))))
	// should be 100 - 10 = 90
	require.Equal(creatorBalance, sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(90))))
}
