package keeper_test

import (
	"encoding/base64"
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/crypto/keys/ed25519"
)

func (suite *IntegrationTestSuite) TestExecuteRecipe2() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	srv := keeper.NewMsgServerImpl(k)
	wctx := sdk.WrapSDKContext(ctx)

	privKey := ed25519.GenPrivKey()
	creator := "testPylon"
	types.UpdateAppCheckFlagTest(types.FlagTrue)

	_, err := srv.CreateAccount(wctx, &types.MsgCreateAccount{
		Creator:  types.TestCreator,
		Username: "test",
	})
	require.NoError(err)

	cookbook := &types.MsgCreateCookbook{
		Creator:      creator,
		Id:           "",
		Name:         "testCookbookName",
		Description:  "descdescdescdescdescdesc",
		Developer:    "",
		Version:      "v0.0.1",
		SupportEmail: "test@email.com",
		Enabled:      true,
	}

	recipe := &types.MsgCreateRecipe{
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
		Enabled:       true,
		ExtraInfo:     "",
	}
	for index, tc := range []struct {
		decs                  string
		cookbook              types.MsgCreateCookbook
		unEnabledCookbook     bool
		changeIdCookbook      bool
		recipe                types.MsgCreateRecipe
		changeIdRecipe        bool
		updateCoinInputs      bool
		updateEntriesRecipe   bool
		execution             types.MsgExecuteRecipe
		changeExcutionCreator bool
		valid                 bool
	}{
		{
			decs:                "Main cookbook not found",
			cookbook:            *cookbook,
			unEnabledCookbook:   false,
			changeIdCookbook:    true,
			recipe:              *recipe,
			changeIdRecipe:      false,
			updateCoinInputs:    false,
			updateEntriesRecipe: false,
			execution: types.MsgExecuteRecipe{
				Creator:         types.TestCreator,
				CookbookId:      "",
				RecipeId:        "",
				CoinInputsIndex: 0,
				ItemIds:         nil,
			},
			changeExcutionCreator: false,
			valid:                 false,
		},
		{
			decs:                "Requested recipe not found",
			cookbook:            *cookbook,
			unEnabledCookbook:   false,
			changeIdCookbook:    false,
			recipe:              *recipe,
			changeIdRecipe:      true,
			updateCoinInputs:    false,
			updateEntriesRecipe: false,
			execution: types.MsgExecuteRecipe{
				Creator:         types.TestCreator,
				CookbookId:      "",
				RecipeId:        "",
				CoinInputsIndex: 0,
				ItemIds:         nil,
			},
			changeExcutionCreator: false,
			valid:                 false,
		},
		{
			decs:                "Recipe Executor Cannot Be Same As Creator",
			cookbook:            *cookbook,
			unEnabledCookbook:   false,
			changeIdCookbook:    false,
			recipe:              *recipe,
			changeIdRecipe:      false,
			updateCoinInputs:    false,
			updateEntriesRecipe: false,
			execution: types.MsgExecuteRecipe{
				Creator:         types.TestCreator,
				CookbookId:      "",
				RecipeId:        "",
				CoinInputsIndex: 0,
				ItemIds:         nil,
			},
			changeExcutionCreator: true,
			valid:                 false,
		},
		{
			decs:                "Recipe or its parent cookbook are disabled",
			cookbook:            *cookbook,
			unEnabledCookbook:   true,
			changeIdCookbook:    false,
			recipe:              *recipe,
			changeIdRecipe:      false,
			updateCoinInputs:    false,
			updateEntriesRecipe: false,
			execution: types.MsgExecuteRecipe{
				Creator:         types.TestCreator,
				CookbookId:      "",
				RecipeId:        "",
				CoinInputsIndex: 0,
				ItemIds:         nil,
			},
			changeExcutionCreator: false,
			valid:                 false,
		},
		{
			decs:                "Don't match ItemInput for Execution",
			cookbook:            *cookbook,
			unEnabledCookbook:   false,
			changeIdCookbook:    false,
			recipe:              *recipe,
			changeIdRecipe:      false,
			updateCoinInputs:    false,
			updateEntriesRecipe: false,
			execution: types.MsgExecuteRecipe{
				Creator:         types.TestCreator,
				CookbookId:      "",
				RecipeId:        "",
				CoinInputsIndex: 0,
				ItemIds:         []string{"1"},
			},
			changeExcutionCreator: false,
			valid:                 false,
		},
		{
			decs:                "Invalid coinInputs index",
			cookbook:            *cookbook,
			unEnabledCookbook:   false,
			changeIdCookbook:    false,
			recipe:              *recipe,
			changeIdRecipe:      false,
			updateCoinInputs:    true,
			updateEntriesRecipe: false,
			execution: types.MsgExecuteRecipe{
				Creator:         types.TestCreator,
				CookbookId:      "",
				RecipeId:        "",
				CoinInputsIndex: 2,
				ItemIds:         nil,
			},
			changeExcutionCreator: false,
			valid:                 false,
		},
		{
			decs:                "Invalid PaymentInfo",
			cookbook:            *cookbook,
			unEnabledCookbook:   false,
			changeIdCookbook:    false,
			recipe:              *recipe,
			changeIdRecipe:      false,
			updateCoinInputs:    false,
			updateEntriesRecipe: false,
			execution: types.MsgExecuteRecipe{
				Creator:         types.TestCreator,
				CookbookId:      "",
				RecipeId:        "",
				CoinInputsIndex: 0,
				ItemIds:         nil,
				PaymentInfos: []types.PaymentInfo{
					{
						PurchaseId:    "1",
						ProcessorName: "test",
						PayerAddr:     "pylon0123",
						Amount:        sdk.OneInt(),
						ProductId:     "1",
						Signature:     "test",
					},
				},
			},
			changeExcutionCreator: false,
			valid:                 false,
		},
		{
			decs:                "Amount minted reached maximum limit",
			cookbook:            *cookbook,
			unEnabledCookbook:   false,
			changeIdCookbook:    false,
			recipe:              *recipe,
			changeIdRecipe:      false,
			updateCoinInputs:    false,
			updateEntriesRecipe: true,
			execution: types.MsgExecuteRecipe{
				Creator:         types.TestCreator,
				CookbookId:      "",
				RecipeId:        "",
				CoinInputsIndex: 0,
				ItemIds:         nil,
			},
			changeExcutionCreator: false,
			valid:                 false,
		},
		{
			decs:                "Process PaymentInfo error",
			cookbook:            *cookbook,
			unEnabledCookbook:   false,
			changeIdCookbook:    false,
			recipe:              *recipe,
			changeIdRecipe:      false,
			updateCoinInputs:    false,
			updateEntriesRecipe: true,
			execution: types.MsgExecuteRecipe{
				Creator:         types.TestCreator,
				CookbookId:      "",
				RecipeId:        "",
				CoinInputsIndex: 0,
				ItemIds:         nil,
				PaymentInfos: []types.PaymentInfo{{
					PurchaseId:    "test",
					ProcessorName: "TestPayment",
					PayerAddr:     types.GenTestBech32FromString(types.TestCreator),
					Amount:        sdk.NewInt(2),
					ProductId:     "testProductId",
					Signature:     genTestPaymentInfoSignature("testPurchaseId", types.GenTestBech32FromString(types.TestCreator), "testProductId", sdk.NewInt(2), privKey),
				}},
			},
			changeExcutionCreator: false,
			valid:                 false,
		},
		{
			decs:                "Error locking coins for execution",
			cookbook:            *cookbook,
			unEnabledCookbook:   false,
			changeIdCookbook:    false,
			recipe:              *recipe,
			changeIdRecipe:      false,
			updateCoinInputs:    true,
			updateEntriesRecipe: false,
			execution: types.MsgExecuteRecipe{
				Creator:         types.TestCreator,
				CookbookId:      "",
				RecipeId:        "",
				CoinInputsIndex: 0,
				ItemIds:         nil,
			},
			changeExcutionCreator: false,
			valid:                 false,
		},
		{
			decs:                "Username not found",
			cookbook:            *cookbook,
			unEnabledCookbook:   false,
			changeIdCookbook:    false,
			recipe:              *recipe,
			changeIdRecipe:      false,
			updateCoinInputs:    false,
			updateEntriesRecipe: false,
			execution: types.MsgExecuteRecipe{
				Creator:         "invalid",
				CookbookId:      "",
				RecipeId:        "",
				CoinInputsIndex: 0,
				ItemIds:         nil,
			},
			changeExcutionCreator: false,
			valid:                 false,
		},
		{
			decs:                "Valid",
			cookbook:            *cookbook,
			unEnabledCookbook:   false,
			changeIdCookbook:    false,
			recipe:              *recipe,
			changeIdRecipe:      false,
			updateCoinInputs:    false,
			updateEntriesRecipe: false,
			execution: types.MsgExecuteRecipe{
				Creator:         types.TestCreator,
				CookbookId:      "",
				RecipeId:        "",
				CoinInputsIndex: 0,
				ItemIds:         nil,
			},
			changeExcutionCreator: false,
			valid:                 true,
		},
	} {
		suite.Run(tc.decs, func() {
			// Start check/config params

			if tc.unEnabledCookbook {
				tc.cookbook.Enabled = false
			} else {
				tc.cookbook.Enabled = true
			}

			tc.cookbook.Id = fmt.Sprintf("%d", index)
			tc.recipe.Id = fmt.Sprintf("%d", index)

			// Check change Id for Cookbook
			if tc.changeIdCookbook {
				tc.execution.CookbookId = fmt.Sprintf("%d", index) + "test"
			} else {
				tc.execution.CookbookId = fmt.Sprintf("%d", index)
			}

			// Check change Id for Receipt
			if tc.changeIdRecipe {
				tc.execution.RecipeId = fmt.Sprintf("%d", index) + "test"
			} else {
				tc.execution.RecipeId = fmt.Sprintf("%d", index)
			}

			tc.recipe.CookbookId = tc.cookbook.Id

			// check Update CoinInputs of recipe
			if tc.updateCoinInputs {
				tc.recipe.CoinInputs = []types.CoinInput{{
					Coins: sdk.NewCoins(
						sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(10)),
					),
				}}
			} else {
				tc.recipe.CoinInputs = nil
			}

			// check Update Entries of recipe and setup PaymentInfos
			if tc.updateEntriesRecipe && tc.execution.PaymentInfos != nil {
				params := k.GetParams(suite.ctx)
				params.PaymentProcessors = append(params.PaymentProcessors, types.PaymentProcessor{
					CoinDenom:            types.PylonsCoinDenom,
					PubKey:               base64.StdEncoding.EncodeToString(privKey.PubKey().Bytes()),
					ProcessorPercentage:  types.DefaultProcessorPercentage,
					ValidatorsPercentage: types.DefaultValidatorsPercentage,
					Name:                 "TestPayment",
				})
				k.SetParams(suite.ctx, params)
			} else if tc.updateEntriesRecipe {
				tc.recipe.Entries.ItemOutputs = []types.ItemOutput{
					{
						Quantity:     10,
						AmountMinted: 10,
					},
				}
			} else {
				tc.recipe.Entries.ItemOutputs = nil
			}

			// check change Execution Creator of execution
			if tc.changeExcutionCreator {
				tc.execution.Creator = creator
			}
			// End check/config params

			// Create Cookbook
			_, err := srv.CreateCookbook(wctx, &tc.cookbook)
			require.NoError(err)

			if tc.changeIdRecipe {
				tc.recipe.Id = tc.recipe.Id + fmt.Sprintf("%d", index)
			}
			// Create Recipe
			_, err = srv.CreateRecipe(wctx, &tc.recipe)
			require.NoError(err)
			rst, found := k.GetRecipe(ctx, tc.recipe.CookbookId, tc.recipe.Id)
			require.True(found)
			require.Equal(tc.recipe.Id, rst.Id)

			// run test cases
			_, err = srv.ExecuteRecipe(wctx, &tc.execution)
			if tc.valid {
				suite.Require().NoError(err)
				completed, pending := k.GetAllExecutionByRecipe(ctx, tc.recipe.CookbookId, tc.recipe.Id)
				require.Equal(0, len(completed))
				require.Equal(1, len(pending))
				types.UpdateAppCheckFlagTest(types.FlagFalse)
			} else {
				suite.Require().Error(err)
			}
		})
	}
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
