package types

import (
	"encoding/json"
	"fmt"
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
			err = json.Unmarshal(data, &serializedEntries)
			require.True(t, err == nil)
			require.EqualValues(t, fmt.Sprintf("%v", entries), fmt.Sprintf("%v", serializedEntries))
		})
	}
}
