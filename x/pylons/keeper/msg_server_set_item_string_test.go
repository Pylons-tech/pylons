package keeper_test

import (
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

func (suite *IntegrationTestSuite) TestItemMsgServerSetStringField() {
	k := suite.k
	bk := suite.bankKeeper
	ctx := suite.ctx
	require := suite.Require()

	numTests := 5

	srv := keeper.NewMsgServerImpl(k)
	wctx := sdk.WrapSDKContext(ctx)

	creator := v1beta1.GenTestBech32FromString("test")
	updateFee := k.UpdateItemStringFee(ctx)
	// need enough balance to update num_tests items
	updateFee.Amount = updateFee.Amount.Mul(sdk.NewInt(int64(numTests)))
	coinsWithUpdateFee := sdk.NewCoins(updateFee)

	creatorAddr, err := sdk.AccAddressFromBech32(creator)
	require.NoError(err)

	err = k.MintCoinsToAddr(ctx, creatorAddr, coinsWithUpdateFee)
	require.NoError(err)

	for i := 0; i < numTests; i++ {
		expectedString := "test"
		idx := fmt.Sprintf("%d", i)
		cookbook := &v1beta1.MsgCreateCookbook{
			Creator:      creator,
			Id:           idx,
			Name:         "testCookbookName",
			Description:  "descdescdescdescdescdescdescdesc",
			Developer:    "",
			Version:      "v0.0.1",
			SupportEmail: "test@email.com",
			Enabled:      false,
		}
		// setting cookbook required to provide a valid "scope" for items
		_, err := srv.CreateCookbook(wctx, cookbook)
		require.NoError(err)

		// set dummy item in store
		item := v1beta1.Item{
			CookbookId: idx,
			Id:         idx,
			Owner:      creator,
			MutableStrings: []v1beta1.StringKeyValue{
				{Key: expectedString, Value: expectedString},
			},
		}
		k.SetItem(ctx, item)
		// update item by setting the MutableString value to ""
		updateItemStringMsg := &v1beta1.MsgSetItemString{
			Creator:    creator,
			CookbookId: idx,
			Id:         idx,
			Field:      expectedString,
			Value:      "new string",
		}
		_, err = srv.SetItemString(wctx, updateItemStringMsg)
		require.NoError(err)

		// get item
		rst, found := k.GetItem(ctx, item.CookbookId, item.Id)
		require.True(found)
		require.NotEqual(expectedString, rst.MutableStrings[0].Value)
		expectedString = "new string"
		require.Equal(expectedString, rst.MutableStrings[0].Value)
	}
	// check payment
	balance := bk.SpendableCoins(ctx, k.FeeCollectorAddress())
	require.True(balance.IsEqual(coinsWithUpdateFee))
}
