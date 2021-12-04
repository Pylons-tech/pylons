package types

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestCalculateTxSizeFee(t *testing.T) {
	obj1 := make([]byte, 10)
	fee := CalculateTxSizeFee(obj1, 0, 10)
	require.Equal(t, fee, 10*10)

	// fee return will always be 0 for negative inputs
	fee = CalculateTxSizeFee(obj1, -1, 10)
	require.Equal(t, fee, 0)
	fee = CalculateTxSizeFee(obj1, 10, -10)
	require.Equal(t, fee, 0)
	fee = CalculateTxSizeFee(obj1, -1, -10)
	require.Equal(t, fee, 0)

	fee = CalculateTxSizeFee(obj1, 5, 10)
	require.Equal(t, fee, 5*10)
}
