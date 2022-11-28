package keeper_test

import (
	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

func (suite *IntegrationTestSuite) TestAfterEpochEnd() {
	k := suite.k
	sk := suite.stakingKeeper
	ctx := suite.ctx
	require := suite.Require()
	bk := suite.bankKeeper
	ak := suite.accountKeeper

	srv := keeper.NewMsgServerImpl(k)
	wctx := sdk.WrapSDKContext(ctx)

	/*
		* amountToPay := refers to the recipe amount
		* ``
		*	form this amount we will calculate the reward that needs to be distributed to
		*	the delegator of the block
		* ``
		* creator  := create address will be used to create cookbook / recipe
		* executor := will be used to execute recipe, as creator and executor cannot be same
		*
		* upon execution of recipe we have a defined fee,
		* i.e. DefaultRecipeFeePercentage (Set at 0.1 or 10%)
		*
		* feeCollectorAddr := address of you fee collector module
		* this modules receives the fee deducted during recipe execution
		*
		* Pre Req:
		*	1. Create Cookbook
		*	2. Create Recipe
		*	3. Execute Recipe
		*
		*
		* this test case will verify that correct amount of rewards are divided amongst delegator
		*
		* 1. Get `delegator amount percentage` that need to be distributed
		* 2. Calculate delegator reward amount for distributed
		* 3. Get balance of delegator before sending reward
		* 4. Distribute reward amongst delegator
		* 5. Query for balance of delegator again to get update balance after sending rewards
		* 6. Compare balance from step 3 with step 5,
			* 6.1 New balance must be equivalent with the old balance
				plus reward amount calculated in step 2
		*
		* Criteria: In case the balances do not match , i.e. (balance before distribution of reward
		*			+ the reward amount) == balance after distribution
		*
	*/

	amountToPay := sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(100)))
	creator := types.GenTestBech32FromString("test")
	executor := types.GenTestBech32FromString("executor")
	feeCollectorAddr := ak.GetModuleAddress(types.FeeCollectorName)

	// Required to disable app check enforcement to make an account
	types.UpdateAppCheckFlagTest(types.FlagTrue)

	// create an account for the executor as their account in pylons is required
	srv.CreateAccount(wctx, &types.MsgCreateAccount{
		Creator: executor,
	})

	// enable the app check enforcement again
	types.UpdateAppCheckFlagTest(types.FlagFalse)

	// making an instance of cookbook
	cookbookMsg := &types.MsgCreateCookbook{
		Creator:      creator,
		Id:           "testCookbookID",
		Name:         "testCookbookName",
		Description:  "descdescdescdescdescdesc",
		Version:      "v0.0.1",
		SupportEmail: "test@email.com",
		Enabled:      true,
	}
	// creating a cookbook
	_, err := srv.CreateCookbook(sdk.WrapSDKContext(suite.ctx), cookbookMsg)
	// must not throw any error
	require.NoError(err)
	// making an instance of cookbook
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
	// creating a recipe
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

	// fund account of executer to execute recipe
	suite.FundAccount(suite.ctx, sdk.MustAccAddressFromBech32(executor), amountToPay)

	// execute a recipe
	resp, err := srv.ExecuteRecipe(sdk.WrapSDKContext(suite.ctx), msgExecution)
	require.NoError(err)

	// manually trigger complete execution - simulate endBlocker
	pendingExecution := k.GetPendingExecution(ctx, resp.Id)
	execution, _, _, err := k.CompletePendingExecution(suite.ctx, pendingExecution)
	require.NoError(err)
	k.ActualizeExecution(ctx, execution)

	// verify execution completion and that requester has no balance left,
	// also pay and fee are transfered to cookbook owner and fee collector module
	_ = bk.SpendableCoins(ctx, sdk.MustAccAddressFromBech32(executor))
	_ = bk.SpendableCoins(ctx, sdk.MustAccAddressFromBech32(creator))
	_ = bk.SpendableCoins(ctx, feeCollectorAddr)

	// get reward distribution percentages
	distrPercentages := k.GetRewardsDistributionPercentages(ctx, sk)
	// calculate delegator rewards
	delegatorsRewards := k.CalculateDelegatorsRewards(ctx, distrPercentages)
	delegatorMap := map[string]sdk.Coins{}
	balances := sdk.Coins{}
	// checking if delegator rewards are not nil
	if delegatorsRewards != nil {
		// looping through delegators to get their old balance
		for address, amount := range delegatorsRewards {
			// looping through amount type of sdk.coins to get every amount and denom
			for _, val := range amount {
				oldBalance := suite.bankKeeper.GetBalance(ctx, sdk.MustAccAddressFromBech32(address), val.Denom)
				// Appending old balance in balances so we can compare it later on with updated balance
				balances = append(balances, oldBalance.Add(val))
			}
			delegatorMap[address] = balances

		}
		// sending rewards to delegators
		k.SendRewards(ctx, delegatorsRewards)
		for address, updatedAmount := range delegatorMap {
			// looping through updated amount type of sdk.coins to get every amount and denom
			for _, val := range updatedAmount {
				newBalance := suite.bankKeeper.GetBalance(ctx, sdk.MustAccAddressFromBech32(address), val.Denom)
				// Comparing updated Amount with new new Blanace both should  be equal
				require.Equal(val.Amount.Int64(), newBalance.Amount.Int64())
			}

		}

	}
}

// Test Case For After Epoch End Fuction With Case No deligators
func (suite *IntegrationTestSuite) TestAfterEpochEndNoDeligators() {
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
		Creator: executor,
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
	_ = bk.SpendableCoins(ctx, sdk.MustAccAddressFromBech32(executor))
	_ = bk.SpendableCoins(ctx, sdk.MustAccAddressFromBech32(creator))
	_ = bk.SpendableCoins(ctx, feeCollectorAddr)

	delegatorsRewards := k.CalculateDelegatorsRewards(ctx, nil)
	delegatorMap := map[string]sdk.Coins{}
	balances := sdk.Coins{}
	if len(delegatorsRewards) == 0 {
		// In this Case No loop will be executed because we have no deligators to send reward
		// looping through delegators to get their old balance
		for address, amount := range delegatorsRewards {
			// looping through amount type of sdk.coins to get every amount and denom
			for _, val := range amount {
				oldBalance := suite.bankKeeper.GetBalance(ctx, sdk.MustAccAddressFromBech32(address), val.Denom)
				// Appending old balance in balances so we can compare it later on with updated balance
				balances = append(balances, oldBalance.Add(val))
			}
			delegatorMap[address] = balances

		}
		// sending rewards to delegators
		k.SendRewards(ctx, delegatorsRewards)
		for address, updatedAmount := range delegatorMap {
			// looping through updated amount type of sdk.coins to get every amount and denom
			for _, val := range updatedAmount {
				newBalance := suite.bankKeeper.GetBalance(ctx, sdk.MustAccAddressFromBech32(address), val.Denom)
				// Comparing updated Amount with new new Blanace both should  be equal
				require.Equal(val.Amount.Int64(), newBalance.Amount.Int64())
			}

		}

	}
}
