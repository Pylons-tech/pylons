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

func TestItemMsgServerCreate(t *testing.T) {
	keeper, ctx := setupKeeper(t)
	srv := NewMsgServerImpl(*keeper)
	wctx := sdk.WrapSDKContext(ctx)
	creator := "A"
	for i := 0; i < 5; i++ {
		idx := fmt.Sprintf("%d", i)
		expected := &types.MsgCreateItem{Creator: creator, ID: idx}
		_, err := srv.CreateItem(wctx, expected)
		require.NoError(t, err)
		rst, found := keeper.GetItem(ctx, expected.ID)
		require.True(t, found)
		assert.Equal(t, expected.Creator, rst.Creator)
	}
}

func TestItemMsgServerUpdate(t *testing.T) {
	creator := "A"
	index := "any"

	for _, tc := range []struct {
		desc    string
		request *types.MsgUpdateItem
		err     error
	}{
		{
			desc:    "Completed",
			request: &types.MsgUpdateItem{Creator: creator, ID: index},
		},
		{
			desc:    "Unauthorized",
			request: &types.MsgUpdateItem{Creator: "B", ID: index},
			err:     sdkerrors.ErrUnauthorized,
		},
		{
			desc:    "KeyNotFound",
			request: &types.MsgUpdateItem{Creator: creator, ID: "missing"},
			err:     sdkerrors.ErrKeyNotFound,
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			keeper, ctx := setupKeeper(t)
			srv := NewMsgServerImpl(*keeper)
			wctx := sdk.WrapSDKContext(ctx)
			expected := &types.MsgCreateItem{Creator: creator, ID: index}
			_, err := srv.CreateItem(wctx, expected)
			require.NoError(t, err)

			_, err = srv.UpdateItem(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, err)
				rst, found := keeper.GetItem(ctx, expected.ID)
				require.True(t, found)
				assert.Equal(t, expected.Creator, rst.Creator)
			}
		})
	}
}

func TestItemMsgServerDelete(t *testing.T) {
	creator := "A"
	id := "any"

	for _, tc := range []struct {
		desc    string
		request *types.MsgDeleteItem
		err     error
	}{
		{
			desc:    "Completed",
			request: &types.MsgDeleteItem{Creator: creator, ID: id},
		},
		{
			desc:    "Unauthorized",
			request: &types.MsgDeleteItem{Creator: "B", ID: id},
			err:     sdkerrors.ErrUnauthorized,
		},
		{
			desc:    "KeyNotFound",
			request: &types.MsgDeleteItem{Creator: creator, ID: "missing"},
			err:     sdkerrors.ErrKeyNotFound,
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			keeper, ctx := setupKeeper(t)
			srv := NewMsgServerImpl(*keeper)
			wctx := sdk.WrapSDKContext(ctx)

			_, err := srv.CreateItem(wctx, &types.MsgCreateItem{Creator: creator, ID: id})
			require.NoError(t, err)
			_, err = srv.DeleteItem(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, err)
				_, found := keeper.GetItem(ctx, tc.request.ID)
				require.False(t, found)
			}
		})
	}
}
