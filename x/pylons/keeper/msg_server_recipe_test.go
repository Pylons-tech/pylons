package keeper_test

import (
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (suite *IntegrationTestSuite) TestRecipeMsgServerCreate() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	srv := keeper.NewMsgServerImpl(k)
	wctx := sdk.WrapSDKContext(ctx)

	creator := "A"
	for i := 0; i < 5; i++ {
		idx := fmt.Sprintf("%d", i)
		cookbook := &types.MsgCreateCookbook{
			Creator:      creator,
			ID:           idx,
			Name:         "testCookbookName",
			Description:  "descdescdescdescdescdesc",
			Developer:    "",
			Version:      "v0.0.1",
			SupportEmail: "test@email.com",
			Enabled:      false,
		}
		_, err := srv.CreateCookbook(wctx, cookbook)
		require.NoError(err)
		expected := &types.MsgCreateRecipe{
			Creator:       creator,
			CookbookID:    idx,
			ID:            idx,
			Name:          "testRecipeName",
			Description:   "decdescdescdescdescdescdescdesc",
			Version:       "v0.0.1",
			CoinInputs:    nil,
			ItemInputs:    nil,
			Entries:       types.EntriesList{},
			Outputs:       nil,
			BlockInterval: 0,
			CostPerBlock: sdk.Coin{Denom: "test", Amount: sdk.ZeroInt()},
			Enabled:       false,
			ExtraInfo:     "",
		}
		_, err = srv.CreateRecipe(wctx, expected)
		require.NoError(err)
		rst, found := k.GetRecipe(ctx, expected.CookbookID, expected.ID)
		require.True(found)
		require.Equal(expected.ID, rst.ID)
	}
}

func (suite *IntegrationTestSuite) TestRecipeMsgServerCreateInvalidAlreadyExists() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	srv := keeper.NewMsgServerImpl(k)
	wctx := sdk.WrapSDKContext(ctx)

	creator := "A"
	for i := 0; i < 5; i++ {
		idx := fmt.Sprintf("%d", i)
		cookbook := &types.MsgCreateCookbook{
			Creator:      creator,
			ID:           idx,
			Name:         "testCookbookName",
			Description:  "descdescdescdescdescdesc",
			Developer:    "",
			Version:      "v0.0.1",
			SupportEmail: "test@email.com",
			Enabled:      false,
		}
		_, err := srv.CreateCookbook(wctx, cookbook)
		require.NoError(err)
		expected := &types.MsgCreateRecipe{
			Creator:       creator,
			CookbookID:    idx,
			ID:            idx,
			Name:          "testRecipeName",
			Description:   "descdescdescdescdescdesc",
			Version:       "v0.0.1",
			CoinInputs:    nil,
			ItemInputs:    nil,
			Entries:       types.EntriesList{},
			Outputs:       nil,
			BlockInterval: 0,
			CostPerBlock: sdk.Coin{Denom: "test", Amount: sdk.ZeroInt()},
			Enabled:       false,
			ExtraInfo:     "",
		}
		_, err = srv.CreateRecipe(wctx, expected)
		require.NoError(err)

		_, err = srv.CreateRecipe(wctx, expected)
		require.ErrorIs(err, sdkerrors.ErrInvalidRequest)
	}
}

func (suite *IntegrationTestSuite) TestRecipeMsgServerCreateInvalidCookbookNotOwned() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	srv := keeper.NewMsgServerImpl(k)
	wctx := sdk.WrapSDKContext(ctx)

	creator := "A"
	for i := 0; i < 5; i++ {
		idx := fmt.Sprintf("%d", i)
		cookbook := &types.MsgCreateCookbook{
			Creator:      creator,
			ID:           idx,
			Name:         "testCookbookName",
			Description:  "descdescdescdescdescdesc",
			Developer:    "",
			Version:      "v0.0.1",
			SupportEmail: "test@email.com",
			Enabled:      false,
		}
		_, err := srv.CreateCookbook(wctx, cookbook)
		require.NoError(err)
		expected := &types.MsgCreateRecipe{
			Creator:       "B",
			CookbookID:    idx,
			ID:            idx,
			Name:          "testRecipeName",
			Description:   "descdescdescdescdescdesc",
			Version:       "v0.0.1",
			CoinInputs:    nil,
			ItemInputs:    nil,
			Entries:       types.EntriesList{},
			Outputs:       nil,
			BlockInterval: 0,
			CostPerBlock: sdk.Coin{Denom: "test", Amount: sdk.ZeroInt()},
			Enabled:       false,
			ExtraInfo:     "",
		}
		_, err = srv.CreateRecipe(wctx, expected)
		require.ErrorIs(err, sdkerrors.ErrUnauthorized)
	}
}

func (suite *IntegrationTestSuite) TestRecipeMsgServerCreateInvalidNoCookbook() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	srv := keeper.NewMsgServerImpl(k)
	wctx := sdk.WrapSDKContext(ctx)

	creator := "A"
	for i := 0; i < 5; i++ {
		idx := fmt.Sprintf("%d", i)

		expected := &types.MsgCreateRecipe{
			Creator:       creator,
			CookbookID:    idx,
			ID:            idx,
			Name:          "testRecipeName",
			Description:   "descdescdescdescdescdesc",
			Version:       "v0.0.1",
			CoinInputs:    nil,
			ItemInputs:    nil,
			Entries:       types.EntriesList{},
			Outputs:       nil,
			BlockInterval: 0,
			Enabled:       false,
			ExtraInfo:     "",
		}
		_, err := srv.CreateRecipe(wctx, expected)
		require.ErrorIs(err, sdkerrors.ErrInvalidRequest)
	}
}

func (suite *IntegrationTestSuite) TestRecipeMsgServerUpdate() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	srv := keeper.NewMsgServerImpl(k)
	wctx := sdk.WrapSDKContext(ctx)

	creator := "A"
	index := "any"

	cookbook := &types.MsgCreateCookbook{
		Creator:      creator,
		ID:           index,
		Name:         "testCookbookName",
		Description:  "descdescdescdescdescdesc",
		Developer:    "",
		Version:      "v0.0.1",
		SupportEmail: "test@email.com",
		Enabled:      false,
	}
	_, err := srv.CreateCookbook(wctx, cookbook)
	require.NoError(err)
	expected := &types.MsgCreateRecipe{
		Creator:       creator,
		CookbookID:    index,
		ID:            index,
		Name:          "testRecipeNameOriginal",
		Description:   "decdescdescdescdescdescdescdesc",
		Version:       "v0.0.1",
		CoinInputs:    nil,
		ItemInputs:    nil,
		Entries:       types.EntriesList{},
		Outputs:       nil,
		BlockInterval: 0,
		CostPerBlock: sdk.Coin{Denom: "test", Amount: sdk.ZeroInt()},
		Enabled:       false,
		ExtraInfo:     "",
	}

	_, err = srv.CreateRecipe(wctx, expected)
	require.NoError(err)

	for _, tc := range []struct {
		desc    string
		request *types.MsgUpdateRecipe
		err     error
	}{
		{
			desc: "Completed",
			request: &types.MsgUpdateRecipe{
				Creator:       creator,
				CookbookID:    index,
				ID:            index,
				Name:          "testRecipeNameNew",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.2",
				CoinInputs:    nil,
				ItemInputs:    nil,
				Entries:       types.EntriesList{},
				Outputs:       nil,
				BlockInterval: 0,
				Enabled:       false,
				ExtraInfo:     "",
			},
		},
		{
			desc: "Unauthorized",
			request: &types.MsgUpdateRecipe{
				Creator:       "B",
				CookbookID:    index,
				ID:            index,
				Name:          "testRecipeNameNewNew",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.3",
				CoinInputs:    nil,
				ItemInputs:    nil,
				Entries:       types.EntriesList{},
				Outputs:       nil,
				BlockInterval: 0,
				Enabled:       false,
				ExtraInfo:     "",
			},
			err: sdkerrors.ErrUnauthorized,
		},
		{
			desc: "incorrect version",
			request: &types.MsgUpdateRecipe{
				Creator:       "A",
				CookbookID:    index,
				ID:            index,
				Name:          "testRecipeNameNewNewNew",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CoinInputs:    nil,
				ItemInputs:    nil,
				Entries:       types.EntriesList{},
				Outputs:       nil,
				BlockInterval: 0,
				Enabled:       false,
				ExtraInfo:     "",
			},
			err: sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "KeyNotFound",
			request: &types.MsgUpdateRecipe{
				Creator:       creator,
				CookbookID:    "missing",
				ID:            "missing",
				Name:          "testRecipeNameNewNewNewNew",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.4",
				CoinInputs:    nil,
				ItemInputs:    nil,
				Entries:       types.EntriesList{},
				Outputs:       nil,
				BlockInterval: 0,
				Enabled:       false,
				ExtraInfo:     "",
			},
			err: sdkerrors.ErrKeyNotFound,
		},
	} {
		tc := tc
		suite.Run(tc.desc, func() {
			_, err = srv.UpdateRecipe(wctx, tc.request)
			if tc.err != nil {
				require.ErrorIs(err, tc.err)
			} else {
				require.NoError(err)
				rst, found := k.GetRecipe(ctx, expected.CookbookID, expected.ID)
				require.True(found)
				require.Equal(expected.ID, rst.ID)
			}
		})
	}
}
