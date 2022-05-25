package keeper_test

import (
	"reflect"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (suite *IntegrationTestSuite) TestNewCelEnvCollectionFromItem() {

	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	tests := []struct {
		desc     string
		recipeID string
		tradeID  string
		item     types.Item
		expected map[string]interface{}
		err      error
	}{
		{
			desc:     "Valid Item",
			recipeID: "recipeId1",
			tradeID:  "tradeId1",
			item: types.Item{
				Doubles: []types.DoubleKeyValue{
					{
						Key:   "XP",
						Value: sdk.NewDec(1),
					},
					{
						Key:   "MP",
						Value: sdk.NewDec(4),
					},
				},
				Longs: []types.LongKeyValue{
					{
						Key:   "level",
						Value: 1,
					},
				},
				Strings: []types.StringKeyValue{
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
		execution types.Execution
		recipe    types.Recipe
		item      types.Item
		expected  map[string]interface{}
		err       error
	}{
		{
			desc: "Testing an ItemRecord not found in store",
			execution: types.Execution{
				ID: "NotFound1",
				ItemInputs: []types.ItemRecord{
					{
						Strings: []types.StringKeyValue{
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
			execution: types.Execution{
				Creator:       types.GenTestBech32FromString("test1"),
				ID:            "execution1",
				RecipeID:      "recipe1",
				CookbookID:    "cookbook1",
				RecipeVersion: "v1.1.1",
				NodeVersion:   0,
				BlockHeight:   0,
				ItemInputs: []types.ItemRecord{
					{
						ID:      "item1",
						Doubles: nil,
						Longs:   nil,
						Strings: nil,
					},
				},
				CoinInputs:          nil,
				CoinOutputs:         nil,
				ItemOutputIDs:       nil,
				ItemModifyOutputIDs: nil,
			},
			recipe: types.Recipe{
				CookbookID:  "cookbook1",
				ID:          "recipe1",
				NodeVersion: 0,
				Name:        "Test Recipe",
				Description: "",
				Version:     "v1.1.1",
				CoinInputs:  nil,
				ItemInputs: []types.ItemInput{
					{
						ID:      "item1",
						Doubles: nil,
						Longs:   nil,
						Strings: nil,
					},
				},
				Entries:       types.EntriesList{},
				Outputs:       nil,
				BlockInterval: 0,
				CostPerBlock: sdk.Coin{
					Denom:  "testCoin",
					Amount: sdk.NewInt(1),
				},
				Enabled:   true,
				ExtraInfo: "",
			},
			item: types.Item{
				Owner:       types.GenTestBech32FromString("test1"),
				CookbookID:  "cookbook1",
				ID:          "item1",
				NodeVersion: 0,
				Doubles: []types.DoubleKeyValue{
					{
						Key:   "doubleParam",
						Value: sdk.NewDec(0),
					},
				},
				Longs: []types.LongKeyValue{
					{
						Key:   "longParam",
						Value: 0,
					},
				},
				Strings: []types.StringKeyValue{
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
