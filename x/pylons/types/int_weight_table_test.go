package types

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestIntWeightTable_NoRandomization(t *testing.T) {
	iwt := IntWeightTable{
		WeightRanges: []IntWeightRange{
			IntWeightRange{
				Lower:  100,
				Upper:  101,
				Weight: 1,
			},
		},
	}
	require.True(t, iwt.Generate() == 100)
}
