package keeper_test

import (
	"fmt"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func TestItemMsgServerSetStringField(t *testing.T) {
	k, ctx := setupKeeper(t)
	srv := keeper.NewMsgServerImpl(k)
	wctx := sdk.WrapSDKContext(ctx)
	creator := "A"
	for i := 0; i < 5; i++ {
		expectedString := "test"
		idx := fmt.Sprintf("%d", i)
		cookbook := &types.MsgCreateCookbook{Creator: creator, ID: idx}
		_, err := srv.CreateCookbook(wctx, cookbook)
		require.NoError(t, err)

		// set dummy item in store
		item := types.Item{
			CookbookID: idx,
			ID:         idx,
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
		require.NoError(t, err)

		// get item
		rst, found := k.GetItem(ctx, item.CookbookID, item.ID)
		require.True(t, found)
		assert.NotEqual(t, expectedString, rst.MutableStrings[0].Value)
		expectedString = ""
		assert.Equal(t, expectedString, rst.MutableStrings[0].Value)
	}
}
