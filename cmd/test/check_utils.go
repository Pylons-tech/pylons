package inttest

import (
	"strings"

	"github.com/Pylons-tech/pylons_sdk/x/pylons/config"
	testing "github.com/Pylons-tech/pylons_sdk/cmd/evtesting"
	inttestSDK "github.com/Pylons-tech/pylons_sdk/cmd/test_utils"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/x/auth/types"
	banktypes "github.com/cosmos/cosmos-sdk/x/bank/types"
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

// GetTxHandleError check error on tx by hash and return handle result
func GetTxHandleError(txhash string, t *testing.T) []byte {
	txHandleErrorBytes, err := inttestSDK.WaitAndGetTxError(txhash, 3, t)
	t.WithFields(testing.Fields{
		"txhash":         txhash,
		"tx_error_bytes": string(txHandleErrorBytes),
	}).MustNil(err, "error getting transaction error")
	return txHandleErrorBytes
}

// TxBroadcastErrorCheck check error on tx broadcast
func TxBroadcastErrorCheck(txhash string, err error, t *testing.T) {
	t.WithFields(testing.Fields{
		"txhash": txhash,
	}).MustNil(err, "unexpected transaction broadcast error")
}

// TxBroadcastErrorExpected check error on tx broadcast
func TxBroadcastErrorExpected(txhash string, err error, desiredError string, t *testing.T) {
	if desiredError != "" {
		t.WithFields(testing.Fields{
			"txhash":        txhash,
			"error":         err,
			"desired_error": desiredError,
		}).MustTrue(strings.Contains(err.Error(), desiredError), "error is different from expected")
	} else {
		TxBroadcastErrorCheck(txhash, err, t)
	}
}

// WaitOneBlockWithErrorCheck wait for a block with error checking
func WaitOneBlockWithErrorCheck(t *testing.T) {
	err := inttestSDK.WaitForNextBlock()
	t.MustNil(err, "error waiting for next block")
}

// GetAccountAddressAndInfo returns SDK address and account info from key
func GetAccountAddressAndInfo(key string, t *testing.T) (sdk.AccAddress, types.AccountI) {
	address := inttestSDK.GetAccountAddr(key, t)
	sdkAddress, err := sdk.AccAddressFromBech32(address)
	t.MustNil(err, "error converting string address to AccAddress struct")
	return sdkAddress, inttestSDK.GetAccountInfoFromAddr(sdkAddress.String(), t)
}

// GetPylonsLLCAddressAndInfo returns Pylons LLC SDK address and account info from key
func GetPylonsLLCAddressAndInfo(t *testing.T) (sdk.Address, types.AccountI) {
	pylonsLLCAddress, err := sdk.AccAddressFromBech32(config.Config.Validators.PylonsLLC)
	t.MustNil(err, "error converting string address to AccAddress struct")
	return pylonsLLCAddress, inttestSDK.GetAccountInfoFromAddr(pylonsLLCAddress.String(), t)
}

// GetPylonsLLCAddressAndInfo returns Pylons LLC SDK address and account info from key
func GetPylonsLLCAddressAndBalance(t *testing.T) (sdk.Address, banktypes.Balance) {
	pylonsLLCAddress, err := sdk.AccAddressFromBech32(config.Config.Validators.PylonsLLC)
	t.MustNil(err, "error converting string address to AccAddress struct")
	return pylonsLLCAddress, inttestSDK.GetAccountBalanceFromAddr(pylonsLLCAddress.String(), t)
}

// GetSDKAddressFromKey returns SDK address from key
func GetSDKAddressFromKey(key string, t *testing.T) sdk.AccAddress {
	address := inttestSDK.GetAccountAddr(key, t)
	sdkAddr, err := sdk.AccAddressFromBech32(address)
	t.MustNil(err, "error converting string address to AccAddress struct")
	return sdkAddr
}
