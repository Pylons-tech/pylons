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

func TestCookbookMsgServerCreate(t *testing.T) {
	keeper, ctx := setupKeeper(t)
	srv := NewMsgServerImpl(*keeper)
	wctx := sdk.WrapSDKContext(ctx)
	creator := "A"
	for i := 0; i < 5; i++ {
		idx := fmt.Sprintf("%d", i)
		expected := &types.MsgCreateCookbook{Creator: creator, ID: idx}
		_, err := srv.CreateCookbook(wctx, expected)
		require.NoError(t, err)
		rst, found := keeper.GetCookbook(ctx, expected.ID)
		require.True(t, found)
		assert.Equal(t, expected.Creator, rst.Creator)
	}
}

func TestCookbookMsgServerUpdate(t *testing.T) {
	creator := "A"
	index := "any"

	for _, tc := range []struct {
		desc    string
		request *types.MsgUpdateCookbook
		err     error
	}{
		{
			desc:    "Completed",
			request: &types.MsgUpdateCookbook{Creator: creator, ID: index},
		},
		{
			desc:    "Unauthorized",
			request: &types.MsgUpdateCookbook{Creator: "B", ID: index},
			err:     sdkerrors.ErrUnauthorized,
		},
		{
			desc:    "KeyNotFound",
			request: &types.MsgUpdateCookbook{Creator: creator, ID: "missing"},
			err:     sdkerrors.ErrKeyNotFound,
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			keeper, ctx := setupKeeper(t)
			srv := NewMsgServerImpl(*keeper)
			wctx := sdk.WrapSDKContext(ctx)
			expected := &types.MsgCreateCookbook{Creator: creator, ID: index}
			_, err := srv.CreateCookbook(wctx, expected)
			require.NoError(t, err)

			_, err = srv.UpdateCookbook(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, err)
				rst, found := keeper.GetCookbook(ctx, expected.ID)
				require.True(t, found)
				assert.Equal(t, expected.Creator, rst.Creator)
			}
		})
	}
}
