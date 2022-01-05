package keeper_test

import (
	"fmt"
	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

func (suite *IntegrationTestSuite) TestExecuteRecipe() {
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
			Enabled:      true,
		}
		_, err := srv.CreateCookbook(wctx, cookbook)
		require.NoError(err)
		recipe := &types.MsgCreateRecipe{
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
			CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.ZeroInt()},
			Enabled:       true,
			ExtraInfo:     "",
		}
		_, err = srv.CreateRecipe(wctx, recipe)
		require.NoError(err)
		rst, found := k.GetRecipe(ctx, recipe.CookbookID, recipe.ID)
		require.True(found)
		require.Equal(recipe.ID, rst.ID)

		execution := &types.MsgExecuteRecipe{
			Creator:         creator,
			CookbookID:      idx,
			RecipeID:        idx,
			CoinInputsIndex: 0,
			ItemIDs:         nil,
		}
		_, err = srv.ExecuteRecipe(wctx, execution)
		require.NoError(err)

		completed, pending := k.GetAllExecutionByRecipe(ctx, recipe.CookbookID, recipe.ID)
		require.Equal(0, len(completed))
		require.Equal(1, len(pending))
	}
}

func (suite *IntegrationTestSuite) TestMatchItemInputsForExecution() {

	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	items := make([]types.Item, 10)
	owner := types.GenTestBech32FromString("testedCookbook")
	coin := []sdk.Coin{sdk.NewCoin(types.PylonsCoinDenom, sdk.OneInt())}

	cookbook := types.Cookbook{
		Creator:     owner,
		ID:          "0",
		NodeVersion: 0,
		Name:        "Testing cookbook",
		Enabled:     false,
	}
	k.SetCookbook(ctx, cookbook)

	for i := range items {
		items[i].Owner = owner
		items[i].CookbookID = cookbook.ID
		items[i].TransferFee = coin
		items[i].Tradeable = true
		items[i].TradePercentage = sdk.ZeroDec()
		items[i].ID = k.AppendItem(ctx, items[i])
	}

	itemStr := make([]string, len(items))

	for i, it := range items {
		itemStr[i] = it.ID
	}

	tests := []struct {
		name          string
		creator       string
		testedMsg     types.MsgExecuteRecipe
		inputItemsIDs []string
		recipe        types.Recipe
		expected      []types.Item
		expectedError error
	}{
		{
			name: "Size Mismatch Error Testing",
			inputItemsIDs: []string{
				"dummyInfo",
			},
			recipe: types.Recipe{
				ItemInputs: []types.ItemInput{
					{
						ID: "dummyId1",
					},
					{
						ID: "dummyId2",
					},
				},
			},
			creator:       types.GenTestBech32FromString("test1"),
			expectedError: sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "size mismatch between provided input items and items required by recipe"),
		}, {
			name:    "Item not found",
			creator: types.GenTestBech32FromString("test2"),
			inputItemsIDs: []string{
				"nonExistentId",
			},
			recipe: types.Recipe{
				ItemInputs: []types.ItemInput{
					{
						ID: "existentId",
					},
				},
			},
			expectedError: sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "item with id %v not found", "nonExistentId"),
		}, {
			name:          "Find no matching",
			creator:       owner,
			inputItemsIDs: itemStr,
			recipe: types.Recipe{
				CookbookID: cookbook.ID,
				ItemInputs: mapItems(itemStr),
			},
			expectedError: sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "cannot find match for recipe input item "),
		}, {
			name:          "Different Owner",
			creator:       types.GenTestBech32FromString("notyourkeysnotyouratoms"),
			inputItemsIDs: itemStr,
			recipe: types.Recipe{
				CookbookID: cookbook.ID,
				ItemInputs: mapItems(itemStr),
			},
			expected:      nil,
			expectedError: sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "item with id %s not owned by sender", itemStr[0]),
		},
	}
	for _, tc := range tests {
		suite.Run(tc.name, func() {
			listOfItems, err := k.MatchItemInputsForExecution(ctx, tc.creator, tc.inputItemsIDs, tc.recipe)
			if err != nil {
				require.Error(tc.expectedError)
			} else {
				for i, item := range listOfItems {
					require.ElementsMatch(item.Doubles, tc.recipe.ItemInputs[i].Doubles)
					require.ElementsMatch(item.Longs, tc.recipe.ItemInputs[i].Longs)
					require.ElementsMatch(item.Strings, tc.recipe.ItemInputs[i].Strings)
				}
			}
		})
	}
}

func mapItems(items []string) []types.ItemInput {
	returnInput := []types.ItemInput{}
	for i, it := range items {
		input := types.ItemInput{
			ID: it,
			Strings: []types.StringInputParam{
				{
					Key:   "strtest",
					Value: fmt.Sprintf("%d", i),
				},
			},
			Doubles: []types.DoubleInputParam{
				{
					Key:      "dbltest",
					MinValue: sdk.NewDec(1),
					MaxValue: sdk.NewDec(2),
				},
			},
			Longs: []types.LongInputParam{
				{
					Key:      "lngtest",
					MinValue: 1,
					MaxValue: 2,
				},
			},
		}
		returnInput = append(returnInput, input)
	}
	return returnInput
}
