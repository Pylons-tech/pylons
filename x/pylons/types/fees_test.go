package types

import (
	"testing"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestCalculateTxSizeFee(t *testing.T) {
	obj1 := make([]byte, 10)
	fee := CalculateTxSizeFee(obj1, 0, sdk.Coin{Denom: "test", Amount: sdk.NewInt(10)})
	require.Equal(t, fee.Amount, sdk.NewInt(10*10))

	// fee return will always be 0 for negative inputs
	fee = CalculateTxSizeFee(obj1, -1, sdk.Coin{Denom: "test", Amount: sdk.NewInt(-10)})
	require.Equal(t, fee.Amount, sdk.ZeroInt())
	fee = CalculateTxSizeFee(obj1, 10, sdk.Coin{Denom: "test", Amount: sdk.NewInt(-10)})
	require.Equal(t, fee.Amount, sdk.ZeroInt())
	fee = CalculateTxSizeFee(obj1, -1, sdk.Coin{Denom: "test", Amount: sdk.NewInt(-10)})
	require.Equal(t, fee.Amount, sdk.ZeroInt())

	fee = CalculateTxSizeFee(obj1, 5, sdk.Coin{Denom: "test", Amount: sdk.NewInt(10)})
	require.Equal(t, fee.Amount, sdk.NewInt(5*10))
}
