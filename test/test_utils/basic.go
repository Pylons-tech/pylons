package testutils

import (
	"encoding/json"
	"fmt"
	"os"
	"regexp"

	"github.com/Pylons-tech/pylons/app"
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	testing "github.com/Pylons-tech/pylons_sdk/cmd/evtesting"
	"github.com/cosmos/cosmos-sdk/codec"
	codectypes "github.com/cosmos/cosmos-sdk/codec/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	authtypes "github.com/cosmos/cosmos-sdk/x/auth/types"
	banktypes "github.com/cosmos/cosmos-sdk/x/bank/types"
	log "github.com/sirupsen/logrus"
)

var tci keep.TestCoinInput

// CLIOptions is a struct to manage pylonsd options
type CLIOptions struct{}

// CLIOpts is a variable to manage pylonsd options
var CLIOpts CLIOptions

func init() {
	tci = keep.SetupTestCoinInput()
}

// GetTestCoinInput returns test coin input for testing
func GetTestCoinInput() keep.TestCoinInput {
	return tci
}

// GetAminoCdc is a utility function to get amino codec
func GetAminoCdc() *codec.LegacyAmino {
	return app.MakeEncodingConfig().Amino
}

func GetJSONMarshaler() codec.Marshaler {
	return app.MakeEncodingConfig().Marshaler
}

func GetInterfaceRegistry() codectypes.InterfaceRegistry {
	return app.MakeEncodingConfig().InterfaceRegistry
}

func GetTxJSONEncoder() sdk.TxEncoder {
	return app.MakeEncodingConfig().TxConfig.TxJSONEncoder()
}

func GetTxJSONDecoder() sdk.TxDecoder {
	return app.MakeEncodingConfig().TxConfig.TxJSONDecoder()
}

// GetAccountInfoFromAddr is a function to get account information from address
func GetAccountBalanceFromAddr(address sdk.AccAddress, t *testing.T) banktypes.Balance {
	var balance banktypes.Balance
	coins := tci.Bk.SpendableCoins(tci.Ctx, address)
	balance.Address = address.String()
	balance.Coins = coins
	return balance
}

// GetAccountInfoFromAddr is a function to get account information from address
func GetAccountInfoFromAddr(address sdk.AccAddress, t *testing.T) authtypes.BaseAccount {
	exportedAccInfo := tci.Ak.GetAccount(tci.Ctx, address)
	any, err := codectypes.NewAnyWithValue(exportedAccInfo.GetPubKey())
	if err != nil {
		return authtypes.BaseAccount{}
	}
	accInfo := authtypes.BaseAccount{
		Address:       exportedAccInfo.GetAddress().String(),
		PubKey:        any,
		AccountNumber: exportedAccInfo.GetAccountNumber(),
		Sequence:      exportedAccInfo.GetSequence(),
	}
	return accInfo
}

// GetAccountInfoFromName is a function to get account information from account key
func GetAccountInfoFromName(key string, t *testing.T) authtypes.BaseAccount {
	addr := GetAccountAddr(key, t)
	return GetAccountInfoFromAddr(addr, t)
}

// WaitForNextBlock is a function to wait until next block
func WaitForNextBlock() {
	WaitForBlockInterval(1)
}

// WaitForBlockInterval is a function to wait until block heights to flow
func WaitForBlockInterval(interval int64) {
	tci.Ctx = tci.Ctx.WithBlockHeight(tci.Ctx.BlockHeight() + interval)
}

// CleanFile is a function to remove file
func CleanFile(filePath string, t *testing.T) {
	err := os.Remove(filePath)
	if err != nil {
		t.WithFields(testing.Fields{
			"error":     err,
			"file_path": filePath,
		}).Error("error removing file")
	}
}

// AminoCodecFormatter format structs better by encoding in amino codec
func AminoCodecFormatter(param interface{}) string {
	cdc := GetAminoCdc()
	output, err := cdc.MarshalJSON(param)
	if err == nil {
		return string(output)
	}
	return fmt.Sprintf("%+v", param)
}

// GetLogFieldsFromMsgs fetch mandatory keys from msgs for debugging
func GetLogFieldsFromMsgs(txMsgs []sdk.Msg) log.Fields {
	fields := log.Fields{}
	for idx, msg := range txMsgs {
		ikeypref := fmt.Sprintf("tx_msg%d_", idx)
		if len(txMsgs) == 1 {
			ikeypref = "tx_msg_"
		}
		switch msg := msg.(type) {
		case *types.MsgCreateCookbook:
			fields[ikeypref+"type"] = "MsgCreateCookbook"
			fields[ikeypref+"cb_name"] = msg.Name
			fields[ikeypref+"sender"] = msg.Sender
		case *types.MsgCreateRecipe:
			fields[ikeypref+"type"] = "MsgCreateRecipe"
			fields[ikeypref+"rcp_name"] = msg.Name
			fields[ikeypref+"sender"] = msg.Sender
		case *types.MsgExecuteRecipe:
			fields[ikeypref+"type"] = "MsgCreateRecipe"
			fields[ikeypref+"rcp_id"] = msg.RecipeID
			fields[ikeypref+"sender"] = msg.Sender
		case *types.MsgCheckExecution:
			fields[ikeypref+"type"] = "MsgCheckExecution"
			fields[ikeypref+"exec_id"] = msg.ExecID
			fields[ikeypref+"sender"] = msg.Sender
		case *types.MsgCreateTrade:
			fields[ikeypref+"type"] = "MsgCreateTrade"
			fields[ikeypref+"trade_info"] = msg.ExtraInfo
			fields[ikeypref+"sender"] = msg.Sender
		case *types.MsgFulfillTrade:
			fields[ikeypref+"type"] = "MsgFulfillTrade"
			fields[ikeypref+"trade_id"] = msg.TradeID
			fields[ikeypref+"sender"] = msg.Sender
		case *types.MsgFiatItem:
			fields[ikeypref+"type"] = "MsgFiatItem"
			fields[ikeypref+"sender"] = msg.Sender
		case *types.MsgUpdateItemString:
			fields[ikeypref+"type"] = "MsgUpdateItemString"
			fields[ikeypref+"item_id"] = msg.ItemID
			fields[ikeypref+"sender"] = msg.Sender
		}
	}
	return fields
}

// JSONFormatter format structs better by encoding in amino codec
func JSONFormatter(param interface{}) string {
	output, err := json.Marshal(param)
	if err == nil {
		return string(output)
	}
	return fmt.Sprintf("%+v;jsonMarshalErr=%s", param, err.Error())
}

// Exists check if element exist in an array
func Exists(slice []string, val string) bool {
	for _, item := range slice {
		if item == val {
			return true
		}
	}
	return false
}

// GetTxHashFromLog returns txhash from long list of transaction log
func GetTxHashFromLog(result string) string {
	// use regexp to find txhash from cli command response
	re := regexp.MustCompile(`"txhash":.*"(.*)"`)
	caTxHashSearch := re.FindSubmatch([]byte(result))
	if len(caTxHashSearch) <= 1 {
		return ""
	}
	caTxHash := string(caTxHashSearch[1])
	return caTxHash
}
