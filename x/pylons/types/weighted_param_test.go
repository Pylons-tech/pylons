package types

import (
	"encoding/json"
	"reflect"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestWeightedParamListSerialize(t *testing.T) {
	entries := GenEntries("chair", "Raichu")

	cases := map[string]struct {
	}{
		"basic flow test": {},
	}
	for testName, _ := range cases {
		t.Run(testName, func(t *testing.T) {
			data, err := json.Marshal(entries)
			// t.Errorf("TestWeightedParamListSerialize1 LOG_entries:: %+v", entries)
			// t.Errorf("TestWeightedParamListSerialize1 LOG_err:: %+v", err)
			require.True(t, err == nil)
			var serializedEntries WeightedParamList
			err2 := json.Unmarshal(data, &serializedEntries)
			require.True(t, err2 == nil)
			// t.Errorf("TestWeightedParamListSerialize1 LOG_serializedEntries:: %+v", serializedEntries)
			// t.Errorf("TestWeightedParamListSerialize1 LOG_err2:: %+v", err2)
			require.True(t, reflect.DeepEqual(entries, serializedEntries))

			// data, err := entries.MarshalJSON()
			// t.Errorf("TestWeightedParamListSerialize LOG_entries:: %+v", entries)
			// t.Errorf("TestWeightedParamListSerialize LOG_err:: %+v", err)
			// require.True(t, err == nil)
			// var serializedEntries WeightedParamList
			// err2 := serializedEntries.UnmarshalJSON(data)
			// t.Errorf("TestWeightedParamListSerialize LOG_serializedEntries:: %+v", serializedEntries)
			// t.Errorf("TestWeightedParamListSerialize LOG_err2:: %+v", err2)
		})
	}
}
