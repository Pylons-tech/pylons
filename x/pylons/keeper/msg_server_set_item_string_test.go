package keeper_test

import (
	"fmt"

	bankTypes "github.com/cosmos/cosmos-sdk/x/bank/types"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (suite *IntegrationTestSuite) TestItemMsgServerSetStringField() {
	k := suite.k
	bk := suite.bankKeeper
	ctx := suite.ctx
	require := suite.Require()

	num_tests := 5

	srv := keeper.NewMsgServerImpl(k)
	wctx := sdk.WrapSDKContext(ctx)

	creator := types.GenTestBech32FromString("test")
	updateFee := k.UpdateItemStringFee(ctx)
	// need enough balance to update num_tests items
	updateFee.Amount = updateFee.Amount.Mul(sdk.NewInt(int64(num_tests)))
	coinsWithUpdateFee := sdk.NewCoins(updateFee)

	creatorAddr, err := sdk.AccAddressFromBech32(creator)
	require.NoError(err)

	// set initial supply to be not nil - we use already available updateFee since any arbitrary value will do
	supply := bankTypes.NewSupply(coinsWithUpdateFee)
	bk.SetSupply(ctx, supply)

	err = k.MintCoinsToAddr(ctx, creatorAddr, coinsWithUpdateFee)
	require.NoError(err)

	for i := 0; i < num_tests; i++ {
		expectedString := "test"
		idx := fmt.Sprintf("%d", i)
		cookbook := &types.MsgCreateCookbook{
			Creator:      creator,
			ID:           idx,
			Name:         "testCookbookName",
			Description:  "descdescdescdescdescdescdescdesc",
			Developer:    "",
			Version:      "v0.0.1",
			SupportEmail: "test@email.com",
			CostPerBlock: sdk.Coin{Denom: "test", Amount: sdk.NewInt(0)},
			Enabled:      false,
		}
		// setting cookbook required to provide a valid "scope" for items
		_, err := srv.CreateCookbook(wctx, cookbook)
		require.NoError(err)

		// set dummy item in store
		item := types.Item{
			CookbookID: idx,
			ID:         idx,
			Owner:      creator,
			MutableStrings: []types.StringKeyValue{
				{Key: expectedString, Value: expectedString},
			},
		}
		k.SetItem(ctx, item)
		// update item by setting the MutableString value to ""
		updateItemStringMsg := &types.MsgSetItemString{
			Creator:    creator,
			CookbookID: idx,
			ID:         idx,
			Field:      expectedString,
			Value:      "new string",
		}
		_, err = srv.SetItemString(wctx, updateItemStringMsg)
		require.NoError(err)

		// get item
		rst, found := k.GetItem(ctx, item.CookbookID, item.ID)
		require.True(found)
		require.NotEqual(expectedString, rst.MutableStrings[0].Value)
		expectedString = "new string"
		require.Equal(expectedString, rst.MutableStrings[0].Value)
	}
	// check payment
	balance := bk.SpendableCoins(ctx, k.FeeCollectorAddress())
	require.True(balance.IsEqual(coinsWithUpdateFee))
}
