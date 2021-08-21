package keeper_test

import (
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (suite *IntegrationTestSuite) TestCookbookMsgServerCreate() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	srv := keeper.NewMsgServerImpl(k)
	wctx := sdk.WrapSDKContext(ctx)
	creator := "TestCreator"
	desc := "TestDescriptionTestDescription"
	for i := 0; i < 5; i++ {
		idx := fmt.Sprintf("%d", i)
		expected := &types.MsgCreateCookbook{
			Creator:      creator,
			ID:           idx,
			Name:         desc,
			Description:  desc,
			Developer:    desc,
			Version:      "v0.0.1",
			SupportEmail: "test@email.com",
			CostPerBlock: sdk.Coin{},
			Enabled:      false,
		}
		_, err := srv.CreateCookbook(wctx, expected)
		require.NoError(err)
	}

	for i := 0; i < 5; i++ {
		idx := fmt.Sprintf("%d", i)
		rst, found := k.GetCookbook(ctx, idx)
		require.True(found)
		require.Equal(creator, rst.Creator)
		require.Equal(desc, rst.Description)
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

	expected := &types.MsgCreateCookbook{
		Creator:      creator,
		ID:           index,
		Name:         "originalNameOriginalName",
		Description:  "descdescdescdescdescdescdescdescdesc",
		Developer:    "",
		Version:      "v0.0.1",
		SupportEmail: "test@email.com",
		CostPerBlock: sdk.Coin{Denom: "test", Amount: sdk.NewInt(0)},
		Enabled:      false,
	}
	_, err := srv.CreateCookbook(wctx, expected)
	require.NoError(err)

	for _, tc := range []struct {
		desc    string
		request *types.MsgUpdateCookbook
		err     error
	}{
		{
			desc: "Completed",
			request: &types.MsgUpdateCookbook{
				Creator:      creator,
				ID:           index,
				Name:         name,
				Description:  description,
				Developer:    "",
				Version:      version,
				SupportEmail: email,
				CostPerBlock: sdk.Coin{Denom: "test", Amount: sdk.NewInt(0)},
				Enabled:      false,
			},
			err: nil,
		},
		{
			desc: "Unauthorized",
			request: &types.MsgUpdateCookbook{
				Creator:      "B",
				ID:           index,
				Name:         name,
				Description:  description,
				Developer:    "",
				Version:      version,
				SupportEmail: email,
				CostPerBlock: sdk.Coin{Denom: "test", Amount: sdk.NewInt(0)},
				Enabled:      false,
			}, err: sdkerrors.ErrUnauthorized,
		},
		{
			desc: "KeyNotFound",
			request: &types.MsgUpdateCookbook{
				Creator:      creator,
				ID:           "not-found",
				Name:         name,
				Description:  description,
				Developer:    "",
				Version:      version,
				SupportEmail: email,
				CostPerBlock: sdk.Coin{Denom: "test", Amount: sdk.NewInt(0)},
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
				rst, found := k.GetCookbook(ctx, expected.ID)
				require.True(found)
				require.Equal(expected.Creator, rst.Creator)
			}
		})
	}
}
