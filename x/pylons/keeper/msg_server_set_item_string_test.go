package keeper

import (
	"fmt"
	"testing"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func TestItemMsgServerSetStringField(t *testing.T) {
	keeper, ctx := setupKeeper(t)
	srv := NewMsgServerImpl(*keeper)
	wctx := sdk.WrapSDKContext(ctx)
	creator := "A"
	for i := 0; i < 5; i++ {
		expectedString := "test"
		idx := fmt.Sprintf("%d", i)
		cookbook := &types.MsgCreateCookbook{Creator: creator, ID: idx}
		_, err := srv.CreateCookbook(wctx, cookbook)
		require.NoError(t, err)
		recipe := &types.MsgCreateRecipe{Creator: creator, CookbookID: idx, ID: idx}
		_, err = srv.CreateRecipe(wctx, recipe)
		require.NoError(t, err)

		// set dummy item in store
		item := types.Item{
			CookbookID: idx,
			RecipeID:   idx,
			ID:         idx,
			MutableStrings: []types.StringKeyValue{
				{Key: expectedString, Value: expectedString},
			},
		}
		keeper.SetItem(ctx, item)
		// update item by setting the MutableString value to ""
		updateItemStringMsg := &types.MsgSetItemString{
			Creator:    creator,
			CookbookID: idx,
			RecipeID:   idx,
			ID:         idx,
			Field:      expectedString,
			Value:      "",
		}
		_, err = srv.SetItemString(wctx, updateItemStringMsg)
		require.NoError(t, err)

		// get item
		rst, found := keeper.GetItem(ctx, item.CookbookID, item.RecipeID, item.ID)
		require.True(t, found)
		assert.NotEqual(t, expectedString, rst.MutableStrings[0].Value)
		expectedString = ""
		assert.Equal(t, expectedString, rst.MutableStrings[0].Value)
	}
}
