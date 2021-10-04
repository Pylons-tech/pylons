package keeper_test

import (
	sdk "github.com/cosmos/cosmos-sdk/types"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (suite *IntegrationTestSuite) TestTradeMsgServerCreateSimple() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	wctx := sdk.WrapSDKContext(ctx)
	srv := keeper.NewMsgServerImpl(k)

	creator := types.GenTestBech32FromString("creator")
	for i := 0; i < 5; i++ {
		resp, err := srv.CreateTrade(wctx, &types.MsgCreateTrade{
			Creator:     creator,
			CoinInput:   sdk.Coin{Denom: "test", Amount: sdk.NewInt(0)},
			ItemInputs:  nil,
			CoinOutput:  sdk.Coin{Denom: "test", Amount: sdk.NewInt(0)},
			ItemOutputs: nil,
			ExtraInfo:   "",
		})
		require.NoError(err)
		require.Equal(i, int(resp.ID))
	}
}

func (suite *IntegrationTestSuite) TestTradeMsgServerCreateInvalidCoinInputs() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	wctx := sdk.WrapSDKContext(ctx)
	srv := keeper.NewMsgServerImpl(k)

	numTests := 5
	items := createNItem(k, ctx, numTests, true)

	for i := 0; i < 5; i++ {
		_, err := srv.CreateTrade(wctx, &types.MsgCreateTrade{
			Creator:     items[i].Owner,
			CoinInput:   sdk.NewCoin("test", sdk.NewInt(1)),
			ItemInputs:  nil,
			CoinOutput:  sdk.Coin{},
			ItemOutputs: []types.ItemRef{{CookbookID: items[i].CookbookID, ItemID: items[i].ID}},
			ExtraInfo:   "extraInfo",
		})
		require.ErrorIs(err, sdkerrors.ErrInvalidCoins)
	}
}

func (suite *IntegrationTestSuite) TestTradeMsgServerCancel() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	wctx := sdk.WrapSDKContext(ctx)
	srv := keeper.NewMsgServerImpl(k)
	creator := types.GenTestBech32FromString("creator")

	for _, tc := range []struct {
		desc    string
		request *types.MsgCancelTrade
		err     error
	}{
		{
			desc:    "Completed",
			request: &types.MsgCancelTrade{Creator: creator, ID: 0},
		},
		{
			desc:    "Unauthorized",
			request: &types.MsgCancelTrade{Creator: "B", ID: 1},
			err:     sdkerrors.ErrUnauthorized,
		},
		{
			desc:    "KeyNotFound",
			request: &types.MsgCancelTrade{Creator: creator, ID: 10},
			err:     sdkerrors.ErrKeyNotFound,
		},
	} {
		tc := tc
		suite.Run(tc.desc, func() {
			_, err := srv.CreateTrade(wctx, &types.MsgCreateTrade{
				Creator:     creator,
				CoinInput:   sdk.Coin{Denom: "test", Amount: sdk.NewInt(0)},
				ItemInputs:  nil,
				CoinOutput:  sdk.Coin{Denom: "test", Amount: sdk.NewInt(0)},
				ItemOutputs: nil,
				ExtraInfo:   "",
			})
			require.NoError(err)
			_, err = srv.CancelTrade(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(err, tc.err)
			} else {
				require.NoError(err)
			}
		})
	}
}
