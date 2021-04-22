package types

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestIntWeightTable_NoRandomization(t *testing.T) {
	iwt := IntWeightTable{
		WeightRanges: []IntWeightRange{
			{
				Lower:  100,
				Upper:  100,
				Weight: 1,
			},
		},
	}
	iwtGen, err := iwt.Generate()
	require.NoError(t, err)
	require.True(t, iwtGen == 100)
}
