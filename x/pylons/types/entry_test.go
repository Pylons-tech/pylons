package types

import (
	"encoding/json"
	"reflect"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestEntriesListSerialize(t *testing.T) {
	entries := GenEntries("chair", "Raichu")

	cases := map[string]struct {
	}{
		"basic flow test": {},
	}
	for testName := range cases {
		t.Run(testName, func(t *testing.T) {
			data, err := json.Marshal(entries)
			require.True(t, err == nil)
			var serializedEntries EntriesList
			err2 := json.Unmarshal(data, &serializedEntries)
			require.True(t, err2 == nil)
			require.True(t, reflect.DeepEqual(entries, serializedEntries))
		})
	}
}
