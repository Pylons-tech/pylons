package keeper_test

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
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

	creator := v1beta1.GenTestBech32FromString("A")
	index := "any"

	expected := &v1beta1.MsgCreateCookbook{
		Creator:      creator,
		Id:           index,
		Name:         "originalNameOriginalName",
		Description:  "descdescdescdescdescdescdescdescdesc",
		Developer:    "",
		Version:      "v0.0.1",
		SupportEmail: "test@email.com",
		Enabled:      false,
	}
	_, err := srv.CreateCookbook(wctx, expected)
	require.NoError(err)

	// now we have a network with a cookbook
	recipient := v1beta1.GenTestBech32FromString("B")

	for _, tc := range []struct {
		desc    string
		request *v1beta1.MsgTransferCookbook
		err     error
	}{
		{
			desc: "Cookbook not owned",
			request: &v1beta1.MsgTransferCookbook{
				Creator:   recipient,
				Id:        index,
				Recipient: recipient,
			},
			err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Completed",
			request: &v1beta1.MsgTransferCookbook{
				Creator:   creator,
				Id:        index,
				Recipient: recipient,
			},
			err: nil,
		},
		{
			desc: "Invalid Cookbook ID",
			request: &v1beta1.MsgTransferCookbook{
				Creator:   creator,
				Id:        "Invalid ID",
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
				rst, found := k.GetCookbook(ctx, expected.Id)
				require.True(found)
				require.Equal(tc.request.Recipient, rst.Creator)
			}
		})
	}
}
