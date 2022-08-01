package v1beta1

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestIntWeightTable_NoRandomization(t *testing.T) {
	iwt := IntWeightTable{
		{
			Lower:  100,
			Upper:  100,
			Weight: 1,
		},
	}
	iwtGen, err := iwt.Generate()
	require.NoError(t, err)
	require.True(t, iwtGen == 100)
}
