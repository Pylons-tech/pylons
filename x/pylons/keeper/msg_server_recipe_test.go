package keeper

import (
	"fmt"
	"testing"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func TestRecipeMsgServerCreate(t *testing.T) {
	keeper, ctx := setupKeeper(t)
	srv := NewMsgServerImpl(keeper)
	wctx := sdk.WrapSDKContext(ctx)
	creator := "A"
	for i := 0; i < 5; i++ {
		idx := fmt.Sprintf("%d", i)
		cookbook := &types.MsgCreateCookbook{Creator: creator, ID: idx}
		_, err := srv.CreateCookbook(wctx, cookbook)
		require.NoError(t, err)
		expected := &types.MsgCreateRecipe{Creator: creator, CookbookID: idx, ID: idx}
		_, err = srv.CreateRecipe(wctx, expected)
		require.NoError(t, err)
		rst, found := keeper.GetRecipe(ctx, expected.CookbookID, expected.ID)
		require.True(t, found)
		assert.Equal(t, expected.ID, rst.ID)
	}
}

func TestRecipeMsgServerUpdate(t *testing.T) {
	creator := "A"
	index := "any"

	for _, tc := range []struct {
		desc    string
		request *types.MsgUpdateRecipe
		err     error
	}{
		{
			desc:    "Completed",
			request: &types.MsgUpdateRecipe{Creator: creator, CookbookID: index, ID: index},
		},
		{
			desc:    "Unauthorized",
			request: &types.MsgUpdateRecipe{Creator: "B", CookbookID: index, ID: index},
			err:     sdkerrors.ErrUnauthorized,
		},
		{
			desc:    "KeyNotFound",
			request: &types.MsgUpdateRecipe{Creator: creator, CookbookID: "missing", ID: "missing"},
			err:     sdkerrors.ErrKeyNotFound,
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			keeper, ctx := setupKeeper(t)
			srv := NewMsgServerImpl(keeper)
			wctx := sdk.WrapSDKContext(ctx)
			cookbook := &types.MsgCreateCookbook{Creator: creator, ID: index}
			_, err := srv.CreateCookbook(wctx, cookbook)
			require.NoError(t, err)
			expected := &types.MsgCreateRecipe{Creator: creator, CookbookID: index, ID: index}
			_, err = srv.CreateRecipe(wctx, expected)
			require.NoError(t, err)

			_, err = srv.UpdateRecipe(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, err)
				rst, found := keeper.GetRecipe(ctx, expected.CookbookID, expected.ID)
				require.True(t, found)
				assert.Equal(t, expected.ID, rst.ID)
			}
		})
	}
}
