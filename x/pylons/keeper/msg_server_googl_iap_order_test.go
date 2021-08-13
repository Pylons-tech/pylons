package keeper

import (
	"testing"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

    "github.com/Pylons-tech/pylons/x/pylons/types"
)

func TestGooglIAPOrderMsgServerCreate(t *testing.T) {
	srv, ctx := setupMsgServer(t)
	creator := "A"
	for i := 0; i < 5; i++ {
		resp, err := srv.CreateGooglIAPOrder(ctx, &types.MsgCreateGooglIAPOrder{Creator: creator})
		require.NoError(t, err)
		assert.Equal(t, i, int(resp.Id))
	}
}

func TestGooglIAPOrderMsgServerUpdate(t *testing.T) {
	creator := "A"

	for _, tc := range []struct {
		desc    string
		request *types.MsgUpdateGooglIAPOrder
		err     error
	}{
		{
			desc:    "Completed",
			request: &types.MsgUpdateGooglIAPOrder{Creator: creator},
		},
		{
			desc:    "Unauthorized",
			request: &types.MsgUpdateGooglIAPOrder{Creator: "B"},
			err:     sdkerrors.ErrUnauthorized,
		},
		{
			desc:    "Unauthorized",
			request: &types.MsgUpdateGooglIAPOrder{Creator: creator, Id: 10},
			err:     sdkerrors.ErrKeyNotFound,
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			srv, ctx := setupMsgServer(t)
			_, err := srv.CreateGooglIAPOrder(ctx, &types.MsgCreateGooglIAPOrder{Creator: creator})
			require.NoError(t, err)

			_, err = srv.UpdateGooglIAPOrder(ctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, err)
			}
		})
	}
}

func TestGooglIAPOrderMsgServerDelete(t *testing.T) {
	creator := "A"

	for _, tc := range []struct {
		desc    string
		request *types.MsgDeleteGooglIAPOrder
		err     error
	}{
		{
			desc:    "Completed",
			request: &types.MsgDeleteGooglIAPOrder{Creator: creator},
		},
		{
			desc:    "Unauthorized",
			request: &types.MsgDeleteGooglIAPOrder{Creator: "B"},
			err:     sdkerrors.ErrUnauthorized,
		},
		{
			desc:    "KeyNotFound",
			request: &types.MsgDeleteGooglIAPOrder{Creator: creator, Id: 10},
			err:     sdkerrors.ErrKeyNotFound,
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			srv, ctx := setupMsgServer(t)

			_, err := srv.CreateGooglIAPOrder(ctx, &types.MsgCreateGooglIAPOrder{Creator: creator})
			require.NoError(t, err)
			_, err = srv.DeleteGooglIAPOrder(ctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, err)
			}
		})
	}
}
