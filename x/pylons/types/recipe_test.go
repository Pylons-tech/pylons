package types

import (
	"encoding/json"
	"testing"

	"cosmossdk.io/math"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

// TODO Add tests for RecipeModified, ItemInputsEqual, EntriesListEqual, OutputsEqual from recipe.go

func TestValidateInputDoubles(t *testing.T) {
	valGTone, _ := math.NewIntFromString("1.01")
	valLTone, _ := math.NewIntFromString("0.99")
	for _, tc := range []struct {
		desc string
		obj  []DoubleInputParam
		err  error
	}{
		{desc: "ValidSingle", obj: []DoubleInputParam{
			{Key: "test", MinValue: math.OneInt(), MaxValue: valGTone},
		}},
		{desc: "ValidMultiple", obj: []DoubleInputParam{
			{Key: "test1", MinValue: math.OneInt(), MaxValue: valGTone},
			{Key: "test2", MinValue: math.OneInt(), MaxValue: valGTone},
		}},
		{desc: "InvalidSingle", obj: []DoubleInputParam{
			{Key: "test", MinValue: math.OneInt(), MaxValue: valLTone},
		}, err: ErrInvalidRequestField},
		{desc: "InvalidMultiple", obj: []DoubleInputParam{
			{Key: "test", MinValue: math.OneInt(), MaxValue: valGTone},
			{Key: "test", MinValue: math.OneInt(), MaxValue: valGTone},
		}, err: ErrInvalidRequestField},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			err := ValidateInputDoubles(tc.obj)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, err)
			}
		})
	}
}

func TestValidateInputLongs(t *testing.T) {
	for _, tc := range []struct {
		desc string
		obj  []LongInputParam
		err  error
	}{
		{desc: "ValidSingle1", obj: []LongInputParam{
			{Key: "test", MinValue: 0, MaxValue: 1},
		}},
		{desc: "ValidSingle2", obj: []LongInputParam{
			{Key: "test", MinValue: 0, MaxValue: 0},
		}},
		{desc: "ValidMultiple", obj: []LongInputParam{
			{Key: "test1", MinValue: 0, MaxValue: 1},
			{Key: "test2", MinValue: 1, MaxValue: 10},
		}},
		{desc: "InvalidSingle1", obj: []LongInputParam{
			{Key: "test", MinValue: -1, MaxValue: 2},
		}, err: ErrInvalidRequestField},
		{desc: "InvalidSingle2", obj: []LongInputParam{
			{Key: "test", MinValue: 2, MaxValue: 1},
		}, err: ErrInvalidRequestField},
		{desc: "InvalidMultiple", obj: []LongInputParam{
			{Key: "test", MinValue: 0, MaxValue: 2},
			{Key: "test", MinValue: 1, MaxValue: 2},
		}, err: ErrInvalidRequestField},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			err := ValidateInputLongs(tc.obj)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, err)
			}
		})
	}
}

func TestValidateInputStrings(t *testing.T) {
	for _, tc := range []struct {
		desc string
		obj  []StringInputParam
		err  error
	}{
		{desc: "ValidSingle1", obj: []StringInputParam{
			{Key: "test"},
		}},
		{desc: "ValidMultiple", obj: []StringInputParam{
			{Key: "test1"},
			{Key: "test2"},
		}},
		{desc: "InvalidMultiple", obj: []StringInputParam{
			{Key: "test"},
			{Key: "test"},
		}, err: ErrInvalidRequestField},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			err := ValidateInputStrings(tc.obj)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, err)
			}
		})
	}
}

func TestValidateItemInput(t *testing.T) {
	for _, tc := range []struct {
		desc string
		obj  string
		err  error
	}{
		{desc: "ValidEmpty", obj: "{}"},
		{desc: "Valid", obj: "{conditions: {}}"},
		{desc: "Invalid", obj: "{\"doubles\": [{\"key\": \"test\", \"min_value\": \"1.01\", \"max_value\": \"1\"}]}", err: ErrInvalidRequestField},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			jsonObj := ItemInput{}
			_ = json.Unmarshal([]byte(tc.obj), &jsonObj)
			err := ValidateItemInput(jsonObj)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, err)
			}
		})
	}
}

func TestValidateCoinOutput(t *testing.T) {
	for _, tc := range []struct {
		desc string
		obj  CoinOutput
		err  error
	}{
		{desc: "Valid", obj: CoinOutput{
			Id: "test", Coin: sdk.Coin{Denom: "test", Amount: sdk.OneInt()},
		}},
		{desc: "Invalid1", obj: CoinOutput{
			Id: "test", Coin: sdk.Coin{Denom: "test", Amount: sdk.NewInt(-1)},
		}, err: sdkerrors.ErrInvalidCoins},
		{desc: "Invalid2", obj: CoinOutput{
			Id: "test", Coin: sdk.Coin{},
		}, err: sdkerrors.ErrInvalidCoins},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			err := ValidateCoinOutput(tc.obj, make(map[string]bool, 0))
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, err)
			}
		})
	}
}

func TestValidateDoubles(t *testing.T) {
	valGTone, _ := math.NewIntFromString("1.01")
	valLTone, _ := math.NewIntFromString("0.99")
	for _, tc := range []struct {
		desc string
		obj  []DoubleParam
		err  error
	}{
		{desc: "ValidSingle", obj: []DoubleParam{
			{Key: "test"},
		}},
		{desc: "ValidMultiple", obj: []DoubleParam{
			{Key: "test1", WeightRanges: []DoubleWeightRange{{Lower: math.OneInt(), Upper: valGTone}}},
			{Key: "test2", WeightRanges: []DoubleWeightRange{{Lower: math.OneInt(), Upper: valGTone}}},
		}},
		{desc: "InvalidSingle1", obj: []DoubleParam{
			{Key: "1test"},
		}, err: ErrInvalidRequestField},
		{desc: "InvalidSingle2", obj: []DoubleParam{
			{Key: "2test"},
		}, err: ErrInvalidRequestField},
		{desc: "InvalidSingle3", obj: []DoubleParam{
			{Key: "test", WeightRanges: []DoubleWeightRange{{Lower: math.OneInt(), Upper: valLTone}}},
		}, err: ErrInvalidRequestField},
		{desc: "InvalidMultiple", obj: []DoubleParam{
			{Key: "test", WeightRanges: []DoubleWeightRange{{Lower: math.OneInt(), Upper: valGTone}}},
			{Key: "test", WeightRanges: []DoubleWeightRange{{Lower: math.OneInt(), Upper: valGTone}}},
		}, err: ErrInvalidRequestField},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			err := ValidateDoubles(tc.obj)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, err)
			}
		})
	}
}

func TestValidateLongs(t *testing.T) {
	for _, tc := range []struct {
		desc string
		obj  []LongParam
		err  error
	}{
		{desc: "ValidSingle", obj: []LongParam{
			{Key: "test"},
		}},
		{desc: "ValidMultiple", obj: []LongParam{
			{Key: "test1", WeightRanges: []IntWeightRange{{Lower: 1, Upper: 2}}},
			{Key: "test2", WeightRanges: []IntWeightRange{{Lower: 1, Upper: 2}}},
		}},
		{desc: "InvalidSingle1", obj: []LongParam{
			{Key: "1test"},
		}, err: ErrInvalidRequestField},
		{desc: "InvalidSingle2", obj: []LongParam{
			{Key: "2test"},
		}, err: ErrInvalidRequestField},
		{desc: "InvalidSingle3", obj: []LongParam{
			{Key: "test", WeightRanges: []IntWeightRange{{Lower: 1, Upper: 0}}},
		}, err: ErrInvalidRequestField},
		{desc: "InvalidMultiple", obj: []LongParam{
			{Key: "test", WeightRanges: []IntWeightRange{{Lower: 1, Upper: 2}}},
			{Key: "test", WeightRanges: []IntWeightRange{{Lower: 1, Upper: 2}}},
		}, err: ErrInvalidRequestField},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			err := ValidateLongs(tc.obj)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, err)
			}
		})
	}
}

func TestValidateStrings(t *testing.T) {
	for _, tc := range []struct {
		desc string
		obj  []StringParam
		err  error
	}{
		{desc: "ValidSingle", obj: []StringParam{
			{Key: "test"},
		}},
		{desc: "ValidMultiple", obj: []StringParam{
			{Key: "test1"},
			{Key: "test2"},
		}},
		{desc: "InvalidSingle1", obj: []StringParam{
			{Key: "1test"},
		}, err: ErrInvalidRequestField},
		{desc: "InvalidSingle2", obj: []StringParam{
			{Key: "2test"},
		}, err: ErrInvalidRequestField},
		{desc: "InvalidMultiple", obj: []StringParam{
			{Key: "test"},
			{Key: "test"},
		}, err: ErrInvalidRequestField},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			err := ValidateStrings(tc.obj)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, err)
			}
		})
	}
}

func TestValidateItemOutputs(t *testing.T) {
	for _, tc := range []struct {
		desc string
		obj  string
		err  error
	}{
		{desc: "ValidEmpty", obj: "[]"},
		{desc: "ValidSingle", obj: "[{\"ID\": \"test1\", \"doubles\": [], \"longs\": [], \"strings\": [{\"key\": \"test1\"}], \"mutable_strings\": [],\"trade_percentage\": \"0.01\", \"transfer_fee\": [{\"denom\": \"pylons\", \"amount\": \"0.01\"}]}]"},
		{desc: "ValidSingle1", obj: "[{\"ID\": \"test1\", \"doubles\": [], \"longs\": [], \"strings\": [{\"key\": \"test1\"}], \"mutable_strings\": [],\"trade_percentage\": \"0\", \"transfer_fee\": [{\"denom\": \"pylons\", \"amount\": \"0.01\"}]}]"},
		{desc: "ValidMultiple", obj: "[{\"ID\": \"test1\", \"doubles\": [], \"longs\": [], \"strings\": [{\"key\": \"test1\"}], \"mutable_strings\": [],\"trade_percentage\": \"0.01\", \"transfer_fee\": [{\"denom\": \"pylons\", \"amount\": \"0.01\"}]}, {\"ID\": \"test2\", \"doubles\": [], \"longs\": [{\"key\": \"test2\", \"lower\": 1, \"upper\": 2}], \"strings\": [], \"mutable_strings\": [],\"trade_percentage\": \"0.01\", \"transfer_fee\": [{\"denom\": \"pylons\", \"amount\": \"0.01\"}]}]"},
		{desc: "InvalidSingle1", obj: "[{\"ID\": \"test\", \"doubles\": [], \"longs\": [], \"strings\": [], \"mutable_strings\": [],\"trade_percentage\": \"0.01\", \"transfer_fee\": [{\"denom\": \"\", \"amount\": \"\"}]}]", err: ErrInvalidRequestField},
		{desc: "InvalidtradePercentage", obj: "[{\"ID\": \"test1\", \"doubles\": [], \"longs\": [], \"strings\": [{\"key\": \"test1\"}], \"mutable_strings\": [],\"trade_percentage\": \"-1\", \"transfer_fee\": [{\"denom\": \"pylons\", \"amount\": \"0.01\"}]}]", err: ErrInvalidRequestField},
		{desc: "InvalidtradePercentage1", obj: "[{\"ID\": \"test1\", \"doubles\": [], \"longs\": [], \"strings\": [{\"key\": \"test1\"}], \"mutable_strings\": [],\"trade_percentage\": \"1\", \"transfer_fee\": [{\"denom\": \"pylons\", \"amount\": \"0.01\"}]}]", err: ErrInvalidRequestField},
		{desc: "InValidMultiple", obj: "[{\"ID\": \"test\", \"doubles\": [], \"longs\": [], \"strings\": [{\"key\": \"test\"}], \"mutable_strings\": [],\"trade_percentage\": \"0.01\", \"transfer_fee\": {\"denom\": \"\", \"amount\": \"\"}}, {\"ID\": \"test\", \"doubles\": [], \"longs\": [{\"key\": \"test\", \"lower\": 1, \"upper\": 2}], \"strings\": [], \"mutable_strings\": [],\"trade_percentage\": \"0.01\", \"transfer_fee\": [{\"denom\": \"pylons\", \"amount\": \"0.01\"}]}]", err: ErrInvalidRequestField},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			jsonObj := make([]ItemOutput, 1)
			_ = json.Unmarshal([]byte(tc.obj), &jsonObj)
			idMap := make(map[string]bool)
			err := ValidateItemOutputs(jsonObj, idMap)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, err)
			}
		})
	}
}

func TestValidateItemModifyOutputs(t *testing.T) {
	for _, tc := range []struct {
		desc string
		obj  string
		err  error
	}{
		{desc: "ValidEmpty", obj: "[]"},
		{desc: "ValidSingle", obj: "[{\"ID\": \"test\", \"doubles\": [], \"longs\": [], \"strings\": [],\"trade_percentage\": \"0.01\",  \"transfer_fee\": [{\"denom\": \"pylons\", \"amount\": \"0.01\"}]}]"},
		{desc: "ValidMultiple", obj: "[{\"ID\": \"test1\", \"doubles\": [], \"longs\": [], \"strings\": [{\"key\": \"test1\"}],\"trade_percentage\": \"0.01\",  \"transfer_fee\": [{\"denom\": \"pylons\", \"amount\": \"0.01\"}]}, {\"ID\": \"test2\", \"doubles\": [], \"longs\": [{\"key\": \"test2\", \"lower\": 1, \"upper\": 2}], \"strings\": [],\"trade_percentage\": \"0.01\",  \"transfer_fee\": [{\"denom\": \"pylons\", \"amount\": \"0.01\"}]}]"},
		{desc: "InvalidSingle", obj: "[{\"ID\": \"test\", \"doubles\": [], \"longs\": [], \"strings\": [],\"trade_percentage\": \"0.01\",  \"transfer_fee\": [{\"denom\": \"\", \"amount\": \"0.01\"}]}]", err: ErrInvalidRequestField},
		{desc: "InValidMultiple", obj: "[{\"ID\": \"test\", \"doubles\": [], \"longs\": [], \"strings\": [{\"key\": \"test\"}],\"trade_percentage\": \"0.01\",  \"transfer_fee\": [{\"denom\": \"\", \"amount\": \"0.01\"}]}, {\"ID\": \"test\", \"doubles\": [], \"longs\": [{\"key\": \"test\", \"lower\": 1, \"upper\": 2}], \"strings\": [],\"trade_percentage\": \"0.01\",  \"transfer_fee\": [{\"denom\": \"pylons\", \"amount\": \"0.01\"}]}]", err: ErrInvalidRequestField},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			var jsonObj []ItemModifyOutput
			_ = json.Unmarshal([]byte(tc.obj), &jsonObj)
			err := ValidateItemModifyOutputs(jsonObj, make(map[string]bool, 0))
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, err)
			}
		})
	}
}

func TestValidateOutputs(t *testing.T) {
	idMap := make(map[string]bool, 1)
	idMap["test1"] = true
	idMap["test2"] = true
	for _, tc := range []struct {
		desc string
		obj  WeightedOutputs
		err  error
	}{
		{desc: "Valid", obj: WeightedOutputs{EntryIds: []string{"test1", "test2"}}},
		{desc: "Invalid", obj: WeightedOutputs{EntryIds: []string{"test", "test1"}}, err: ErrInvalidRequestField},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			err := ValidateOutputs(tc.obj, idMap)
			if tc.err != nil {
				require.ErrorIs(t, err, tc.err)
			} else {
				require.NoError(t, err)
			}
		})
	}
}
