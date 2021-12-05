package types

import sdk "github.com/cosmos/cosmos-sdk/types"

func CalculateTxSizeFee(obj []byte, sizeLimitBytes int, feePerByte sdk.Coin) sdk.Coin {
	fee := sdk.ZeroInt()

	if sizeLimitBytes < 0 || feePerByte.Amount.IsNegative() {
		return sdk.NewCoin(feePerByte.Denom, sdk.ZeroInt())
	}

	sizeOverBytes := len(obj) - sizeLimitBytes
	if sizeOverBytes > 0 {
		fee = feePerByte.Amount.Mul(sdk.NewIntFromUint64(uint64(sizeOverBytes)))
	}

	return sdk.NewCoin(feePerByte.Denom, fee)
}
