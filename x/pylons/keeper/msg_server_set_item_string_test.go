package keeper_test

import (
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (suite *IntegrationTestSuite) TestItemMsgServerSetStringField() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	srv := keeper.NewMsgServerImpl(k)
	wctx := sdk.WrapSDKContext(ctx)

	creator := "A"
	for i := 0; i < 5; i++ {
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
			Value:      "",
		}
		_, err = srv.SetItemString(wctx, updateItemStringMsg)
		require.NoError(err)

		// get item
		rst, found := k.GetItem(ctx, item.CookbookID, item.ID)
		require.True(found)
		require.NotEqual(expectedString, rst.MutableStrings[0].Value)
		expectedString = ""
		require.Equal(expectedString, rst.MutableStrings[0].Value)
	}
}
