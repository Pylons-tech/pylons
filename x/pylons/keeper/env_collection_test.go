package keeper_test

import (
	"reflect"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

func (suite *IntegrationTestSuite) TestNewCelEnvCollectionFromItem() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	tests := []struct {
		desc     string
		recipeID string
		tradeID  string
		item     v1beta1.Item
		expected map[string]interface{}
		err      error
	}{
		{
			desc:     "Valid Item",
			recipeID: "recipeId1",
			tradeID:  "tradeId1",
			item: v1beta1.Item{
				Doubles: []v1beta1.DoubleKeyValue{
					{
						Key:   "XP",
						Value: sdk.OneDec(),
					},
					{
						Key:   "MP",
						Value: sdk.NewDec(4),
					},
				},
				Longs: []v1beta1.LongKeyValue{
					{
						Key:   "level",
						Value: 1,
					},
				},
				Strings: []v1beta1.StringKeyValue{
					{
						Key:   "entityType",
						Value: "character",
					},
				},
			},
			expected: map[string]interface{}{
				"XP":              float64(1),
				"entityType":      "character",
				"itemID":          "",
				"MP":              float64(4),
				"lastBlockHeight": int64(0),
				"lastUpdate":      int64(0),
				"level":           int64(1),
				"owner":           "",
				"recipeID":        "recipeId1",
				"tradeID":         "tradeId1",
			},
			err: nil,
		},
	}
	for _, tc := range tests {
		suite.Run(tc.desc, func() {
			item := tc.item
			celColl, err := k.NewCelEnvCollectionFromItem(ctx, tc.recipeID, tc.tradeID, item)
			variables := celColl.GetVariables()
			if tc.err != nil {
				require.ErrorIs(err, tc.err)
			} else {
				require.NoError(err)
				fields := reflect.ValueOf(variables).MapKeys()
				for _, f := range fields {
					fieldName := f.Interface().(string)
					require.NotNil(variables[fieldName], "%s shouldn't be nil", fieldName)
					require.NotNil(tc.expected[fieldName], "%s shouldn't be nil", fieldName)
					require.Equal(variables[fieldName], tc.expected[fieldName], "values of fields %s are not equal", fieldName)
				}
			}
		})
	}
}

func (suite *IntegrationTestSuite) TestNewCelEnvCollectionFromRecipe() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	tests := []struct {
		desc      string
		execution v1beta1.Execution
		recipe    v1beta1.Recipe
		item      v1beta1.Item
		expected  map[string]interface{}
		err       error
	}{
		{
			desc: "Testing an ItemRecord not found in store",
			execution: v1beta1.Execution{
				Id: "NotFound1",
				ItemInputs: []v1beta1.ItemRecord{
					{
						Strings: []v1beta1.StringKeyValue{
							{
								Key:   "entityType",
								Value: "character",
							},
						},
					},
				},
			},
			err: sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "itemRecord item not found in store"),
		},
		{
			desc: "Valid Test",
			execution: v1beta1.Execution{
				Creator:       v1beta1.GenTestBech32FromString("test1"),
				Id:            "execution1",
				RecipeId:      "recipe1",
				CookbookId:    "cookbook1",
				RecipeVersion: "v1.1.1",
				NodeVersion:   0,
				BlockHeight:   0,
				ItemInputs: []v1beta1.ItemRecord{
					{
						Id:      "item1",
						Doubles: nil,
						Longs:   nil,
						Strings: nil,
					},
				},
				CoinInputs:          nil,
				CoinOutputs:         nil,
				ItemOutputIds:       nil,
				ItemModifyOutputIds: nil,
			},
			recipe: v1beta1.Recipe{
				CookbookId:  "cookbook1",
				Id:          "recipe1",
				NodeVersion: 0,
				Name:        "Test Recipe",
				Description: "",
				Version:     "v1.1.1",
				CoinInputs:  nil,
				ItemInputs: []v1beta1.ItemInput{
					{
						Id:      "item1",
						Doubles: nil,
						Longs:   nil,
						Strings: nil,
					},
				},
				Entries:       v1beta1.EntriesList{},
				Outputs:       nil,
				BlockInterval: 0,
				CostPerBlock: sdk.Coin{
					Denom:  "testCoin",
					Amount: sdk.NewInt(1),
				},
				Enabled:   true,
				ExtraInfo: "",
			},
			item: v1beta1.Item{
				Owner:       v1beta1.GenTestBech32FromString("test1"),
				CookbookId:  "cookbook1",
				Id:          "item1",
				NodeVersion: 0,
				Doubles: []v1beta1.DoubleKeyValue{
					{
						Key:   "doubleParam",
						Value: sdk.ZeroDec(),
					},
				},
				Longs: []v1beta1.LongKeyValue{
					{
						Key:   "longParam",
						Value: 0,
					},
				},
				Strings: []v1beta1.StringKeyValue{
					{
						Key:   "entityType",
						Value: "testItem",
					},
				},
				MutableStrings:  nil,
				Tradeable:       false,
				LastUpdate:      0,
				TransferFee:     nil,
				TradePercentage: sdk.Dec{},
			},
			expected: map[string]interface{}{
				"lastUpdate":         int64(0),
				"doubleParam":        float64(0),
				"input0.owner":       "pylo1w3jhxap395kj6tfd95kj6tfd95kj6tfd7up9d8",
				"input0.itemID":      "item1",
				"input0.lastUpdate":  int64(0),
				"item1.owner":        "pylo1w3jhxap395kj6tfd95kj6tfd95kj6tfd7up9d8",
				"lastBlockHeight":    int64(0),
				"itemID":             "item1",
				"input0.doubleParam": float64(0),
				"input0.longParam":   int64(0),
				"input0.entityType":  "testItem",
				"item1.itemID":       "item1",
				"item1.lastUpdate":   int64(0),
				"item1.longParam":    int64(0),
				"recipeID":           "recipe1",
				"entityType":         "testItem",
				"item1.entityType":   "testItem",
				"tradeID":            "",
				"owner":              "pylo1w3jhxap395kj6tfd95kj6tfd95kj6tfd7up9d8",
				"longParam":          int64(0),
				"item1.doubleParam":  float64(0),
			},
		},
	}
	for _, tc := range tests {
		suite.Run(tc.desc, func() {
			if tc.err != nil {
				_, err := k.NewCelEnvCollectionFromRecipe(ctx, tc.execution, tc.recipe)
				require.ErrorIs(tc.err, err)
			} else {
				k.SetRecipe(ctx, tc.recipe)
				k.SetPendingExecution(ctx, tc.execution)
				k.SetItem(ctx, tc.item)
				resp, err := k.NewCelEnvCollectionFromRecipe(ctx, tc.execution, tc.recipe)
				require.NoError(err)
				variables := resp.GetVariables()
				fields := reflect.ValueOf(variables).MapKeys()
				for _, f := range fields {
					fieldName := f.Interface().(string)
					require.NotNil(variables[fieldName], "%s shouldn't be nil", fieldName)
					require.NotNil(tc.expected[fieldName], "%s shouldn't be nil", fieldName)
					require.Equal(variables[fieldName], tc.expected[fieldName], "values of fields %s are not equal", fieldName)
				}
			}
		})
	}
}
