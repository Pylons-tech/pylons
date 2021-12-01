package types

const (
	DefaultSizeLimitBytes = 1024
	DefaultFeePerBytes    = 10
)

func CalculateTxSizeFee(obj []byte, sizeLimitBytes, feePerByte int) int {
	fee := 0

	sizeOverBytes := len(obj) - sizeLimitBytes
	if sizeOverBytes > 0 {
		fee = sizeOverBytes * feePerByte
	}

	return fee
}
