package keeper_test

import (
	"encoding/base64"
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
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
	v1beta1.UpdateAppCheckFlagTest(v1beta1.FlagTrue)

	_, err := srv.CreateAccount(wctx, &v1beta1.MsgCreateAccount{
		Creator:  v1beta1.TestCreator,
		Username: "test",
	})
	require.NoError(err)

	cookbook := &v1beta1.MsgCreateCookbook{
		Creator:      creator,
		Id:           "",
		Name:         "testCookbookName",
		Description:  "descdescdescdescdescdesc",
		Developer:    "",
		Version:      "v0.0.1",
		SupportEmail: "test@email.com",
		Enabled:      true,
	}

	recipe := &v1beta1.MsgCreateRecipe{
		Creator:       creator,
		CookbookId:    "",
		Id:            "",
		Name:          "testRecipeName",
		Description:   "decdescdescdescdescdescdescdesc",
		Version:       "v0.0.1",
		CoinInputs:    nil,
		ItemInputs:    nil,
		Entries:       v1beta1.EntriesList{},
		Outputs:       nil,
		BlockInterval: 0,
		CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.ZeroInt()},
		Enabled:       true,
		ExtraInfo:     "",
	}
	for index, tc := range []struct {
		decs                  string
		cookbook              v1beta1.MsgCreateCookbook
		unEnabledCookbook     bool
		changeIdCookbook      bool
		recipe                v1beta1.MsgCreateRecipe
		changeIdRecipe        bool
		updateCoinInputs      bool
		updateEntriesRecipe   bool
		execution             v1beta1.MsgExecuteRecipe
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
			execution: v1beta1.MsgExecuteRecipe{
				Creator:         v1beta1.TestCreator,
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
			execution: v1beta1.MsgExecuteRecipe{
				Creator:         v1beta1.TestCreator,
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
			execution: v1beta1.MsgExecuteRecipe{
				Creator:         v1beta1.TestCreator,
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
			execution: v1beta1.MsgExecuteRecipe{
				Creator:         v1beta1.TestCreator,
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
			execution: v1beta1.MsgExecuteRecipe{
				Creator:         v1beta1.TestCreator,
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
			execution: v1beta1.MsgExecuteRecipe{
				Creator:         v1beta1.TestCreator,
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
			execution: v1beta1.MsgExecuteRecipe{
				Creator:         v1beta1.TestCreator,
				CookbookId:      "",
				RecipeId:        "",
				CoinInputsIndex: 0,
				ItemIds:         nil,
				PaymentInfos: []v1beta1.PaymentInfo{
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
			execution: v1beta1.MsgExecuteRecipe{
				Creator:         v1beta1.TestCreator,
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
			execution: v1beta1.MsgExecuteRecipe{
				Creator:         v1beta1.TestCreator,
				CookbookId:      "",
				RecipeId:        "",
				CoinInputsIndex: 0,
				ItemIds:         nil,
				PaymentInfos: []v1beta1.PaymentInfo{{
					PurchaseId:    "test",
					ProcessorName: "TestPayment",
					PayerAddr:     v1beta1.GenTestBech32FromString(v1beta1.TestCreator),
					Amount:        sdk.NewInt(2),
					ProductId:     "testProductId",
					Signature:     genTestPaymentInfoSignature("testPurchaseId", v1beta1.GenTestBech32FromString(v1beta1.TestCreator), "testProductId", sdk.NewInt(2), privKey),
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
			execution: v1beta1.MsgExecuteRecipe{
				Creator:         v1beta1.TestCreator,
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
			execution: v1beta1.MsgExecuteRecipe{
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
			execution: v1beta1.MsgExecuteRecipe{
				Creator:         v1beta1.TestCreator,
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
				tc.recipe.CoinInputs = []v1beta1.CoinInput{{
					Coins: sdk.NewCoins(
						sdk.NewCoin(v1beta1.PylonsCoinDenom, sdk.NewInt(10)),
					),
				}}
			} else {
				tc.recipe.CoinInputs = nil
			}

			// check Update Entries of recipe and setup PaymentInfos
			if tc.updateEntriesRecipe && tc.execution.PaymentInfos != nil {
				params := k.GetParams(suite.ctx)
				params.PaymentProcessors = append(params.PaymentProcessors, v1beta1.PaymentProcessor{
					CoinDenom:            v1beta1.PylonsCoinDenom,
					PubKey:               base64.StdEncoding.EncodeToString(privKey.PubKey().Bytes()),
					ProcessorPercentage:  v1beta1.DefaultProcessorPercentage,
					ValidatorsPercentage: v1beta1.DefaultValidatorsPercentage,
					Name:                 "TestPayment",
				})
				k.SetParams(suite.ctx, params)
			} else if tc.updateEntriesRecipe {
				tc.recipe.Entries.ItemOutputs = []v1beta1.ItemOutput{
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
				v1beta1.UpdateAppCheckFlagTest(v1beta1.FlagFalse)
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

	items := make([]v1beta1.Item, 4)
	owner := v1beta1.GenTestBech32FromString("testedCookbook")
	coin := []sdk.Coin{sdk.NewCoin(v1beta1.PylonsCoinDenom, sdk.OneInt())}

	cookbook := v1beta1.Cookbook{
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
		items[i].Longs = []v1beta1.LongKeyValue{
			{
				Key:   strIndex,
				Value: int64(i),
			},
		}
		items[i].Doubles = []v1beta1.DoubleKeyValue{
			{
				Key:   strIndex,
				Value: sdk.NewDec(int64(i)),
			},
		}
		items[i].Strings = []v1beta1.StringKeyValue{
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
		testedMsg     v1beta1.MsgExecuteRecipe
		inputItemsIds []string
		recipe        v1beta1.Recipe
		expected      []v1beta1.Item
		expectedError error
	}{
		{
			name: "Size Mismatch Error Testing",
			inputItemsIds: []string{
				"dummyInfo",
			},
			recipe: v1beta1.Recipe{
				ItemInputs: []v1beta1.ItemInput{
					{
						Id: "dummyId1",
					},
					{
						Id: "dummyId2",
					},
				},
			},
			creator:       v1beta1.GenTestBech32FromString("test1"),
			expectedError: sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "size mismatch between provided input items and items required by recipe"),
		}, {
			name:    "Expect item with ID not found",
			creator: v1beta1.GenTestBech32FromString("test2"),
			inputItemsIds: []string{
				"nonExistentId",
			},
			recipe: v1beta1.Recipe{
				ItemInputs: []v1beta1.ItemInput{
					{
						Id: "NonExistentId",
					},
				},
			},
			expectedError: sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "item with id %v not found", "nonExistentId"),
		}, {
			name:          "Different Owner",
			creator:       v1beta1.GenTestBech32FromString("notyourkeysnotyouratoms"),
			inputItemsIds: itemStr,
			recipe: v1beta1.Recipe{
				CookbookId: cookbook.Id,
				ItemInputs: mapItems(itemStr),
			},
			expected:      nil,
			expectedError: sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "item with id %s not owned by sender", itemStr[0]),
		}, {
			name:          "Expect Locked Item Error",
			creator:       owner,
			inputItemsIds: itemStr[3:4],
			recipe: v1beta1.Recipe{
				CookbookId: cookbook.Id,
				ItemInputs: []v1beta1.ItemInput{
					{
						Id: "validInput1",
						Doubles: []v1beta1.DoubleInputParam{
							{
								Key:      "3",
								MinValue: sdk.NewDec(3),
								MaxValue: sdk.NewDec(3),
							},
						},
						Longs: []v1beta1.LongInputParam{
							{
								Key:      "3",
								MinValue: 3,
								MaxValue: 3,
							},
						},
						Strings: []v1beta1.StringInputParam{
							{
								Key:   "3",
								Value: "3",
							},
						},
					},
				},
			},
			expectedError: sdkerrors.Wrapf(v1beta1.ErrItemLocked, "item with id %s locked", itemStr[3]),
		}, {
			name:          "Matching Successfull",
			creator:       owner,
			inputItemsIds: itemStr[0:2],
			recipe: v1beta1.Recipe{
				CookbookId: cookbook.Id,
				ItemInputs: []v1beta1.ItemInput{
					{
						Id: "validInput1",
						Doubles: []v1beta1.DoubleInputParam{
							{
								Key:      "0",
								MinValue: sdk.NewDec(0),
								MaxValue: sdk.NewDec(0),
							},
						},
						Longs: []v1beta1.LongInputParam{
							{
								Key:      "0",
								MinValue: 0,
								MaxValue: 0,
							},
						},
						Strings: []v1beta1.StringInputParam{
							{
								Key:   "0",
								Value: "0",
							},
						},
					},
					{
						Id: "validInput2",
						Doubles: []v1beta1.DoubleInputParam{
							{
								Key:      "1",
								MinValue: sdk.NewDec(1),
								MaxValue: sdk.NewDec(1),
							},
						},
						Longs: []v1beta1.LongInputParam{
							{
								Key:      "1",
								MinValue: 1,
								MaxValue: 1,
							},
						},
						Strings: []v1beta1.StringInputParam{
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
			recipe: v1beta1.Recipe{
				CookbookId: cookbook.Id,
				ItemInputs: []v1beta1.ItemInput{
					{
						Id: "UnexistentInput1",
						Doubles: []v1beta1.DoubleInputParam{
							{
								Key:      "11",
								MinValue: sdk.NewDec(11),
								MaxValue: sdk.NewDec(11),
							},
						},
						Longs: []v1beta1.LongInputParam{
							{
								Key:      "11",
								MinValue: 1,
								MaxValue: 1,
							},
						},
						Strings: []v1beta1.StringInputParam{
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

func mapItems(items []string) []v1beta1.ItemInput {
	returnInput := []v1beta1.ItemInput{}
	for i, it := range items {
		input := v1beta1.ItemInput{
			Id: it,
			Strings: []v1beta1.StringInputParam{
				{
					Key:   "strtest",
					Value: fmt.Sprintf("%d", i),
				},
			},
			Doubles: []v1beta1.DoubleInputParam{
				{
					Key:      "dbltest",
					MinValue: sdk.NewDec(1),
					MaxValue: sdk.NewDec(2),
				},
			},
			Longs: []v1beta1.LongInputParam{
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
