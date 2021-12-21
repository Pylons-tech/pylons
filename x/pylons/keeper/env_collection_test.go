package keeper_test

import (
	"reflect"

	sdk "github.com/cosmos/cosmos-sdk/types"

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
				"XP":float64(1),
				"entityType":"character",
				"itemID":"",
				"MP":float64(4),
				"lastBlockHeight":int64(0),
				"lastUpdate":int64(0),
				"level":int64(1),
				"owner":"",
				"recipeID":"recipeId1",
				"tradeID":"tradeId1",
			},
			err: nil,
		},
	}
	for _, tc := range tests {
		suite.Run(tc.desc, func() {
			item := tc.item
			celColl, err := k.NewCelEnvCollectionFromItem(ctx, tc.recipeID, tc.tradeID, item)
			require.NoError(err)
			variables := celColl.GetVariables()
			if tc.err != nil {
				require.ErrorIs(err, tc.err)
			} else {
				fields := reflect.ValueOf(variables).MapKeys()
				for _,f := range fields {
					fieldName := f.Interface().(string)
					require.NotNil(variables[fieldName],"%s shouldn't be nil", fieldName)
					require.NotNil(tc.expected[fieldName],"%s shouldn't be nil", fieldName)
					require.Equal(variables[fieldName],tc.expected[fieldName],"values of fields %s are not equal",fieldName)
				}
			}
		})
	}
}
