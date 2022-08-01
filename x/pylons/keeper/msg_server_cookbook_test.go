package keeper_test

import (
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

func (suite *IntegrationTestSuite) TestCookbookMsgServerCreate() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	srv := keeper.NewMsgServerImpl(k)
	wctx := sdk.WrapSDKContext(ctx)
	creator := "TestCreator"
	desc := "TestDescriptionTestDescription"
	index := "testing"

	anchorMsg := &v1beta1.MsgCreateCookbook{
		Creator:      creator,
		Id:           index,
		Name:         desc,
		Description:  desc,
		Developer:    desc,
		Version:      "v0.0.1",
		SupportEmail: "test@email.com",
		Enabled:      false,
	}
	for _, tc := range []struct {
		desc  string
		msgs  []v1beta1.MsgCreateCookbook
		valid bool
	}{
		{
			desc: "Invalid request: ID already set",
			msgs: []v1beta1.MsgCreateCookbook{
				*anchorMsg,
				{
					Creator:      creator,
					Id:           index,
					Name:         desc,
					Description:  desc,
					Developer:    desc,
					Version:      "v0.0.1",
					SupportEmail: "test@email.com",
					Enabled:      false,
				},
			},
			valid: false,
		},
		{
			desc: "Valid",
			msgs: []v1beta1.MsgCreateCookbook{
				*anchorMsg,
				{
					Creator:      creator,
					Id:           "validcase",
					Name:         desc,
					Description:  desc,
					Developer:    desc,
					Version:      "v0.0.1",
					SupportEmail: "test@email.com",
					Enabled:      false,
				},
			},
			valid: true,
		},
	} {
		suite.Run(fmt.Sprintf("Case %s", tc.desc), func() {
			var err error
			for _, msg := range tc.msgs {
				_, err = srv.CreateCookbook(wctx, &msg)
			}
			if tc.valid {
				suite.Require().NoError(err)
				for _, msg := range tc.msgs {
					rst, found := k.GetCookbook(ctx, msg.Id)
					require.True(found)
					require.Equal(creator, rst.Creator)
					require.Equal(desc, rst.Description)
				}

			} else {
				suite.Require().Error(err)
			}
		})
	}
}

func (suite *IntegrationTestSuite) TestCookbookMsgServerUpdate() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	wctx := sdk.WrapSDKContext(ctx)
	srv := keeper.NewMsgServerImpl(k)

	creator := "A"
	index := "any"
	name := "testNameTestName"
	description := "testDescriptionTestDescriptionTestDescription"
	version := "v1.0.0"
	email := "test@email.com"

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

	for _, tc := range []struct {
		desc    string
		request *v1beta1.MsgUpdateCookbook
		err     error
	}{
		{
			desc: "Completed",
			request: &v1beta1.MsgUpdateCookbook{
				Creator:      creator,
				Id:           index,
				Name:         name,
				Description:  description,
				Developer:    "",
				Version:      version,
				SupportEmail: email,
				Enabled:      false,
			},
			err: nil,
		},
		{
			desc: "Unauthorized",
			request: &v1beta1.MsgUpdateCookbook{
				Creator:      "B",
				Id:           index,
				Name:         name,
				Description:  description,
				Developer:    "",
				Version:      version,
				SupportEmail: email,
				Enabled:      false,
			}, err: sdkerrors.ErrUnauthorized,
		},
		{
			desc: "KeyNotFound",
			request: &v1beta1.MsgUpdateCookbook{
				Creator:      creator,
				Id:           "not-found",
				Name:         name,
				Description:  description,
				Developer:    "",
				Version:      version,
				SupportEmail: email,
				Enabled:      false,
			}, err: sdkerrors.ErrKeyNotFound,
		},
	} {
		tc := tc
		suite.Run(tc.desc, func() {
			_, err = srv.UpdateCookbook(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(err, tc.err)
			} else {
				require.NoError(err)
				rst, found := k.GetCookbook(ctx, expected.Id)
				require.True(found)
				require.Equal(expected.Creator, rst.Creator)
			}
		})
	}
}
