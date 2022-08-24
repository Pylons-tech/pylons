package keeper_test

import (
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (suite *IntegrationTestSuite) TestRecipeMsgServerCreate2() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	srv := keeper.NewMsgServerImpl(k)
	wctx := sdk.WrapSDKContext(ctx)

	creator := "testPylon"

	expected := &types.MsgCreateRecipe{
		Creator:       creator,
		CookbookId:    "",
		Id:            "",
		Name:          "testRecipeName",
		Description:   "decdescdescdescdescdescdescdesc",
		Version:       "v0.0.1",
		CoinInputs:    nil,
		ItemInputs:    nil,
		Entries:       types.EntriesList{},
		Outputs:       nil,
		BlockInterval: 0,
		CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.ZeroInt()},
		Enabled:       false,
		ExtraInfo:     "",
	}

	for index, tc := range []struct {
		desc             string
		cookbook         types.MsgCreateCookbook
		request          types.MsgCreateRecipe
		create_Cookbook  bool
		duplicate_Recipe bool
		err              error
	}{
		{
			desc: "Completed",
			cookbook: types.MsgCreateCookbook{
				Creator:      creator,
				Name:         "testCookbookName",
				Description:  "descdescdescdescdescdesc",
				Developer:    "",
				Version:      "v0.0.1",
				SupportEmail: "test@email.com",
				Enabled:      false,
			},
			request: types.MsgCreateRecipe{
				Creator:       creator,
				Name:          "testRecipeName",
				Description:   "decdescdescdescdescdescdescdesc",
				Version:       "v0.0.1",
				CoinInputs:    nil,
				ItemInputs:    nil,
				Entries:       types.EntriesList{},
				Outputs:       nil,
				BlockInterval: 0,
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.ZeroInt()},
				Enabled:       false,
				ExtraInfo:     "",
			},
			create_Cookbook:  true,
			duplicate_Recipe: false,
		},
		{
			desc: "Incorrect Owner",
			cookbook: types.MsgCreateCookbook{
				Creator:      creator,
				Name:         "testCookbookName",
				Description:  "descdescdescdescdescdesc",
				Developer:    "",
				Version:      "v0.0.1",
				SupportEmail: "test@email.com",
				Enabled:      false,
			},
			request: types.MsgCreateRecipe{
				Creator:       "testPylon_1",
				Name:          "testRecipeName",
				Description:   "descdescdescdescdescdesc",
				Version:       "v0.0.1",
				CoinInputs:    nil,
				ItemInputs:    nil,
				Entries:       types.EntriesList{},
				Outputs:       nil,
				BlockInterval: 0,
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.ZeroInt()},
				Enabled:       false,
				ExtraInfo:     "",
			},
			create_Cookbook:  true,
			duplicate_Recipe: false,
			err:              sdkerrors.ErrUnauthorized,
		},
		{
			desc: "Cookbook does not exist",
			request: types.MsgCreateRecipe{
				Creator:       creator,
				Name:          "testRecipeName",
				Description:   "descdescdescdescdescdesc",
				Version:       "v0.0.1",
				CoinInputs:    nil,
				ItemInputs:    nil,
				Entries:       types.EntriesList{},
				Outputs:       nil,
				BlockInterval: 0,
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.ZeroInt()},
				Enabled:       false,
				ExtraInfo:     "",
			},
			create_Cookbook:  false,
			duplicate_Recipe: false,
			err:              sdkerrors.ErrInvalidRequest,
		},
		{
			desc: "Recipe already set",
			cookbook: types.MsgCreateCookbook{
				Creator:      creator,
				Name:         "testCookbookName",
				Description:  "descdescdescdescdescdesc",
				Developer:    "",
				Version:      "v0.0.1",
				SupportEmail: "test@email.com",
				Enabled:      false,
			},
			request: types.MsgCreateRecipe{
				Creator:       creator,
				Name:          "testRecipeName",
				Description:   "descdescdescdescdescdesc",
				Version:       "v0.0.1",
				CoinInputs:    nil,
				ItemInputs:    nil,
				Entries:       types.EntriesList{},
				Outputs:       nil,
				BlockInterval: 0,
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.ZeroInt()},
				Enabled:       false,
				ExtraInfo:     "",
			},
			create_Cookbook:  true,
			duplicate_Recipe: true,
			err:              sdkerrors.ErrInvalidRequest,
		},
	} {
		suite.Run(tc.desc, func() {
			tc.cookbook.Id = fmt.Sprintf("%d", index)
			tc.request.CookbookId = fmt.Sprintf("%d", index)
			tc.request.Id = fmt.Sprintf("%d", index)
			expected.CookbookId = fmt.Sprintf("%d", index)
			expected.Id = fmt.Sprintf("%d", index)

			if tc.create_Cookbook {
				_, err := srv.CreateCookbook(wctx, &tc.cookbook)
				require.NoError(err)
			}
			if tc.duplicate_Recipe {
				_, err := srv.CreateRecipe(wctx, &tc.request)
				require.NoError(err)
			}
			_, err := srv.CreateRecipe(wctx, &tc.request)

			if tc.err != nil {
				require.ErrorIs(err, tc.err)
			} else {
				require.NoError(err)
				rst, found := k.GetRecipe(ctx, expected.CookbookId, expected.Id)
				require.True(found)
				require.Equal(expected.Id, rst.Id)
			}
		})
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
		Id:           index,
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
		CookbookId:    index,
		Id:            index,
		Name:          "testRecipeNameOriginal",
		Description:   "decdescdescdescdescdescdescdesc",
		Version:       "v0.0.1",
		CoinInputs:    nil,
		ItemInputs:    nil,
		Entries:       types.EntriesList{},
		Outputs:       nil,
		BlockInterval: 0,
		CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.ZeroInt()},
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
				CookbookId:    index,
				Id:            index,
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
				CookbookId:    index,
				Id:            index,
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
				CookbookId:    index,
				Id:            index,
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
				CookbookId:    "missing",
				Id:            "missing",
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
				rst, found := k.GetRecipe(ctx, expected.CookbookId, expected.Id)
				require.True(found)
				require.Equal(expected.Id, rst.Id)
			}
		})
	}
}
