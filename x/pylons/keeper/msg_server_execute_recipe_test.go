package keeper_test

import (
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (suite *IntegrationTestSuite) TestExecuteRecipe() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	srv := keeper.NewMsgServerImpl(k)
	wctx := sdk.WrapSDKContext(ctx)

	creator := "A"
	types.UpdateAppCheckFlagTest(types.FlagTrue)

	_, err := srv.CreateAccount(wctx, &types.MsgCreateAccount{
		Creator:  types.TestCreator,
		Username: "test",
	})
	require.NoError(err)
	for i := 0; i < 5; i++ {
		idx := fmt.Sprintf("%d", i)
		cookbook := &types.MsgCreateCookbook{
			Creator:      creator,
			Id:           idx,
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
			CookbookId:    idx,
			Id:            idx,
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
		rst, found := k.GetRecipe(ctx, recipe.CookbookId, recipe.Id)
		require.True(found)
		require.Equal(recipe.Id, rst.Id)

		execution := &types.MsgExecuteRecipe{
			Creator:         types.TestCreator,
			CookbookId:      idx,
			RecipeId:        idx,
			CoinInputsIndex: 0,
			ItemIds:         nil,
		}
		_, err = srv.ExecuteRecipe(wctx, execution)
		require.NoError(err)

		completed, pending := k.GetAllExecutionByRecipe(ctx, recipe.CookbookId, recipe.Id)
		require.Equal(0, len(completed))
		require.Equal(1, len(pending))
	}
	types.UpdateAppCheckFlagTest(types.FlagFalse)
}

func (suite *IntegrationTestSuite) TestMatchItemInputsForExecution() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	items := make([]types.Item, 4)
	owner := types.GenTestBech32FromString("testedCookbook")
	coin := []sdk.Coin{sdk.NewCoin(types.PylonsCoinDenom, sdk.OneInt())}

	cookbook := types.Cookbook{
		Creator:     owner,
		Id:          "0",
		NodeVersion: 0,
		Name:        "Testing cookbook",
		Enabled:     false,
	}
	k.SetCookbook(ctx, cookbook)

	for i := range items {
		items[i].Owner = owner
		items[i].CookbookId = cookbook.Id
		items[i].TransferFee = coin
		items[i].Tradeable = true
		items[i].TradePercentage = sdk.ZeroDec()
		strIndex := fmt.Sprintf("%d", i)
		items[i].Longs = []types.LongKeyValue{
			{
				Key:   strIndex,
				Value: int64(i),
			},
		}
		items[i].Doubles = []types.DoubleKeyValue{
			{
				Key:   strIndex,
				Value: sdk.NewDec(int64(i)),
			},
		}
		items[i].Strings = []types.StringKeyValue{
			{
				Key:   strIndex,
				Value: strIndex,
			},
		}
		items[i].Id = k.AppendItem(ctx, items[i])
	}

	itemStr := make([]string, len(items))

	for i, it := range items {
		itemStr[i] = it.Id
	}

	// Lock item 3 test the error
	k.LockItemForExecution(ctx, items[3])

	tests := []struct {
		name          string
		creator       string
		testedMsg     types.MsgExecuteRecipe
		inputItemsIds []string
		recipe        types.Recipe
		expected      []types.Item
		expectedError error
	}{
		{
			name: "Size Mismatch Error Testing",
			inputItemsIds: []string{
				"dummyInfo",
			},
			recipe: types.Recipe{
				ItemInputs: []types.ItemInput{
					{
						Id: "dummyId1",
					},
					{
						Id: "dummyId2",
					},
				},
			},
			creator:       types.GenTestBech32FromString("test1"),
			expectedError: sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "size mismatch between provided input items and items required by recipe"),
		}, {
			name:    "Expect item with ID not found",
			creator: types.GenTestBech32FromString("test2"),
			inputItemsIds: []string{
				"nonExistentId",
			},
			recipe: types.Recipe{
				ItemInputs: []types.ItemInput{
					{
						Id: "NonExistentId",
					},
				},
			},
			expectedError: sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "item with id %v not found", "nonExistentId"),
		}, {
			name:          "Different Owner",
			creator:       types.GenTestBech32FromString("notyourkeysnotyouratoms"),
			inputItemsIds: itemStr,
			recipe: types.Recipe{
				CookbookId: cookbook.Id,
				ItemInputs: mapItems(itemStr),
			},
			expected:      nil,
			expectedError: sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "item with id %s not owned by sender", itemStr[0]),
		}, {
			name:          "Expect Locked Item Error",
			creator:       owner,
			inputItemsIds: itemStr[3:4],
			recipe: types.Recipe{
				CookbookId: cookbook.Id,
				ItemInputs: []types.ItemInput{
					{
						Id: "validInput1",
						Doubles: []types.DoubleInputParam{
							{
								Key:      "3",
								MinValue: sdk.NewDec(3),
								MaxValue: sdk.NewDec(3),
							},
						},
						Longs: []types.LongInputParam{
							{
								Key:      "3",
								MinValue: 3,
								MaxValue: 3,
							},
						},
						Strings: []types.StringInputParam{
							{
								Key:   "3",
								Value: "3",
							},
						},
					},
				},
			},
			expectedError: sdkerrors.Wrapf(types.ErrItemLocked, "item with id %s locked", itemStr[3]),
		}, {
			name:          "Matching Successfull",
			creator:       owner,
			inputItemsIds: itemStr[0:2],
			recipe: types.Recipe{
				CookbookId: cookbook.Id,
				ItemInputs: []types.ItemInput{
					{
						Id: "validInput1",
						Doubles: []types.DoubleInputParam{
							{
								Key:      "0",
								MinValue: sdk.NewDec(0),
								MaxValue: sdk.NewDec(0),
							},
						},
						Longs: []types.LongInputParam{
							{
								Key:      "0",
								MinValue: 0,
								MaxValue: 0,
							},
						},
						Strings: []types.StringInputParam{
							{
								Key:   "0",
								Value: "0",
							},
						},
					},
					{
						Id: "validInput2",
						Doubles: []types.DoubleInputParam{
							{
								Key:      "1",
								MinValue: sdk.NewDec(1),
								MaxValue: sdk.NewDec(1),
							},
						},
						Longs: []types.LongInputParam{
							{
								Key:      "1",
								MinValue: 1,
								MaxValue: 1,
							},
						},
						Strings: []types.StringInputParam{
							{
								Key:   "1",
								Value: "1",
							},
						},
					},
				},
			},
			expected: items[0:2],
		}, {
			name:          "No Match Found",
			creator:       owner,
			inputItemsIds: itemStr[0:1],
			recipe: types.Recipe{
				CookbookId: cookbook.Id,
				ItemInputs: []types.ItemInput{
					{
						Id: "UnexistentInput1",
						Doubles: []types.DoubleInputParam{
							{
								Key:      "11",
								MinValue: sdk.NewDec(11),
								MaxValue: sdk.NewDec(11),
							},
						},
						Longs: []types.LongInputParam{
							{
								Key:      "11",
								MinValue: 1,
								MaxValue: 1,
							},
						},
						Strings: []types.StringInputParam{
							{
								Key:   "11",
								Value: "11",
							},
						},
					},
				},
			},
			expectedError: sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "cannot find match for recipe input item "),
		},
	}
	for _, tc := range tests {
		suite.Run(tc.name, func() {
			listOfItems, err := k.MatchItemInputsForExecution(ctx, tc.creator, tc.inputItemsIds, tc.recipe)
			if err != nil {
				require.Equal(err.Error(), tc.expectedError.Error())
			} else {
				require.ElementsMatch(listOfItems, tc.expected)
			}
		})
	}
}

func mapItems(items []string) []types.ItemInput {
	returnInput := []types.ItemInput{}
	for i, it := range items {
		input := types.ItemInput{
			Id: it,
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
