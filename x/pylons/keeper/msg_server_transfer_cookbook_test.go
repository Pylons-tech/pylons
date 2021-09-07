package keeper_test

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// create a network w cookbook

// TEST 1
// we transfer cookbook ownership but we don't own
// check if error is proper

// TEST 2
// we transfer cookbook ownership and we own it
// check if the owner is proper

// TEST 3
// we transfer cookbook ownership but the cookbook doesnt exist
// check if error is proper

func (suite *IntegrationTestSuite) TestCookbookMsgServerTransfer() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	wctx := sdk.WrapSDKContext(ctx)
	srv := keeper.NewMsgServerImpl(k)

	creator := types.GenTestBech32FromString("A")
	index := "any"

	expected := &types.MsgCreateCookbook{
		Creator:      creator,
		ID:           index,
		Name:         "originalNameOriginalName",
		Description:  "descdescdescdescdescdescdescdescdesc",
		Developer:    "",
		Version:      "v0.0.1",
		SupportEmail: "test@email.com",
		CostPerBlock: sdk.Coin{Denom: "test", Amount: sdk.ZeroInt()},
		Enabled:      false,
	}
	_, err := srv.CreateCookbook(wctx, expected)
	require.NoError(err)

	// now we have a network with a cookbook
	recipient := types.GenTestBech32FromString("B")

	for _, tc := range []struct {
		desc    string
		request *types.MsgTransferCookbook
		err     error
	}{
		{
			desc: "Cookbook not owned",
			request: &types.MsgTransferCookbook{
				Creator:   recipient,
				ID:        index,
				Recipient: recipient,
			},
			err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Completed",
			request: &types.MsgTransferCookbook{
				Creator:   creator,
				ID:        index,
				Recipient: recipient,
			},
			err: nil,
		},
		{
			desc: "Invalid Cookbook ID",
			request: &types.MsgTransferCookbook{
				Creator:   creator,
				ID:        "Invalid ID",
				Recipient: recipient,
			},
			err: sdkerrors.ErrInvalidRequest,
		},
	} {
		tc := tc
		suite.Run(tc.desc, func() {
			_, err = srv.TransferCookbook(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(err, tc.err)
			} else {
				require.NoError(err)
				rst, found := k.GetCookbook(ctx, expected.ID)
				require.True(found)
				require.Equal(tc.request.Recipient, rst.Creator)
			}
		})
	}
}
