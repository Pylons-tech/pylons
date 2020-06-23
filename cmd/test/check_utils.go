package inttest

import (
	"strings"

	testing "github.com/Pylons-tech/pylons_sdk/cmd/fixtures_test/evtesting"
	inttestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test"
)

// TxResultStatusMessageCheck check result status and message
func TxResultStatusMessageCheck(txhash, status, message, targetStatus, targetMessage string, t *testing.T) {
	t.WithFields(testing.Fields{
		"txhash":          txhash,
		"original_status": status,
		"target_status":   targetStatus,
	}).MustTrue(status == targetStatus, "transaction result status is different from expected")
	t.WithFields(testing.Fields{
		"txhash":           txhash,
		"original_message": message,
		"target_message":   targetMessage,
	}).MustTrue(message == targetMessage, "transaction result message is different from expected")
}

// TxResBytesUnmarshalErrorCheck check unmarshal error
func TxResBytesUnmarshalErrorCheck(txhash string, err error, txHandleResBytes []byte, t *testing.T) {
	t.WithFields(testing.Fields{
		"txhash":          txhash,
		"tx_result_bytes": string(txHandleResBytes),
	}).MustNil(err, "error unmarshaling transaction result")
}

// GetTxHandleResult check error on tx by hash and return handle result
func GetTxHandleResult(txhash string, t *testing.T) []byte {
	txHandleResBytes, err := inttestSDK.WaitAndGetTxData(txhash, 3, t)
	t.WithFields(testing.Fields{
		"txhash":          txhash,
		"tx_result_bytes": string(txHandleResBytes),
	}).MustNil(err, "error getting transaction data")
	return txHandleResBytes
}

// TxBroadcastErrorCheck check error on tx broadcast
func TxBroadcastErrorCheck(txhash string, err error, t *testing.T) {
	t.WithFields(testing.Fields{
		"txhash": txhash,
		"error":  err,
	}).Fatal("unexpected transaction broadcast error")
}

// TxBroadcastErrorExpected check error on tx broadcast
func TxBroadcastErrorExpected(txhash string, err error, desiredError string, t *testing.T) {
	if desiredError != "" {
		t.WithFields(testing.Fields{
			"txhash":        txhash,
			"error":         err,
			"desired_error": desiredError,
		}).MustTrue(strings.Contains(err.Error(), desiredError))
	} else {
		TxBroadcastErrorCheck(txhash, err, t)
	}
}
