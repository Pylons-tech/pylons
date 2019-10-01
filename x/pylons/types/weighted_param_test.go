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
			require.True(t, err == nil)
			var serializedEntries WeightedParamList
			err2 := json.Unmarshal(data, &serializedEntries)
			require.True(t, err2 == nil)
			require.True(t, reflect.DeepEqual(entries, serializedEntries))
		})
	}
}
