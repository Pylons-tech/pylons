package keeper_test

import (
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

func (suite *IntegrationTestSuite) TestCompleteExecutionEarly() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()
	bk := suite.bankKeeper

	srv := keeper.NewMsgServerImpl(k)
	wctx := sdk.WrapSDKContext(ctx)

	amountToPay := sdk.NewCoins(sdk.NewCoin(v1beta1.PylonsCoinDenom, sdk.NewInt(10)))
	creator := v1beta1.GenTestBech32FromString("test")

	trashStr := v1beta1.GenTestBech32FromString("trash")
	trashAddress := sdk.MustAccAddressFromBech32(trashStr)

	cookbookMsg := &v1beta1.MsgCreateCookbook{
		Creator:      creator,
		Id:           "testCookbookID",
		Name:         "testCookbookName",
		Description:  "descdescdescdescdescdesc",
		Version:      "v0.0.1",
		SupportEmail: "test@email.com",
		Enabled:      true,
	}
	_, err := srv.CreateCookbook(wctx, cookbookMsg)
	require.NoError(err)
	recipeMsg := &v1beta1.MsgCreateRecipe{
		Creator:       creator,
		CookbookId:    "testCookbookID",
		Id:            "testRecipeID",
		Name:          "recipeName",
		Description:   "descdescdescdescdescdesc",
		Version:       "v0.0.1",
		BlockInterval: amountToPay.AmountOf(v1beta1.PylonsCoinDenom).Int64(),
		CostPerBlock:  sdk.Coin{Denom: v1beta1.PylonsCoinDenom, Amount: sdk.OneInt()},
		Enabled:       true,
	}
	_, err = srv.CreateRecipe(wctx, recipeMsg)
	require.NoError(err)
	recipe, found := k.GetRecipe(ctx, recipeMsg.CookbookId, recipeMsg.Id)
	require.True(found)
	// create only one pendingExecution
	pendingExecution := createNPendingExecutionForSingleRecipe(k, ctx, 1, recipe)[0]

	for _, tc := range []struct {
		desc         string
		Id           string
		amountMinted sdk.Coins
		valid        bool
	}{
		{
			desc:         "Cannot find a pending execution with ID given",
			Id:           "2",
			amountMinted: sdk.NewCoins(sdk.NewCoin(v1beta1.PylonsCoinDenom, sdk.NewInt(10))),
			valid:        false,
		},
		{
			desc:         "Amout coint of requester is not enough",
			Id:           pendingExecution.Id,
			amountMinted: sdk.NewCoins(sdk.NewCoin(v1beta1.PylonsCoinDenom, sdk.NewInt(0))),
			valid:        false,
		},
		{
			desc:         "Valid",
			Id:           pendingExecution.Id,
			amountMinted: sdk.NewCoins(sdk.NewCoin(v1beta1.PylonsCoinDenom, sdk.NewInt(10))),
			valid:        true,
		},
	} {
		suite.Run(fmt.Sprintf("Case %s", tc.desc), func() {
			// give coins to requester
			requesterAddr, err := sdk.AccAddressFromBech32(pendingExecution.Creator)
			require.NoError(err)

			if bk.SpendableCoins(ctx, requesterAddr) != nil {
				suite.pylonsApp.BankKeeper.SendCoins(ctx, requesterAddr, trashAddress, bk.SpendableCoins(ctx, requesterAddr))
			}
			err = k.MintCoinsToAddr(ctx, requesterAddr, tc.amountMinted)
			require.NoError(err)

			// submit early execution request
			completeEarly := &v1beta1.MsgCompleteExecutionEarly{
				Creator: pendingExecution.Creator,
				Id:      tc.Id,
			}
			resp, err := srv.CompleteExecutionEarly(wctx, completeEarly)
			if tc.valid {
				require.NoError(err)
				pendingExecution = k.GetPendingExecution(ctx, resp.Id)
				execution, _, _, err := k.CompletePendingExecution(ctx, pendingExecution)
				require.NoError(err)
				k.ActualizeExecution(ctx, execution)

				// verify execution completion and that requester has no balance left
				require.True(k.HasExecution(ctx, resp.Id))
				balance := bk.SpendableCoins(ctx, requesterAddr)
				require.Nil(balance)
			} else {
				suite.Require().Error(err)
			}
		})
	}
}
