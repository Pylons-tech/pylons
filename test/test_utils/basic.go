package testutils

import (
	"encoding/json"
	"fmt"
	"os"
	"regexp"
	"sync"

	"github.com/Pylons-tech/pylons/app"
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	testing "github.com/Pylons-tech/pylons_sdk/cmd/evtesting"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/x/auth"
	log "github.com/sirupsen/logrus"
	amino "github.com/tendermint/go-amino"
)

var tci keep.TestCoinInput

// CLIOptions is a struct to manage pylonscli options
type CLIOptions struct{}

// CLIOpts is a variable to manage pylonscli options
var CLIOpts CLIOptions
var cliMux sync.Mutex

func init() {
	tci = keep.SetupTestCoinInput()
}

// GetTestCoinInput returns test coin input for testing
func GetTestCoinInput() keep.TestCoinInput {
	return tci
}

// GetAminoCdc is a utility function to get amino codec
func GetAminoCdc() *amino.Codec {
	return app.MakeCodec()
}

// GetAccountInfoFromAddr is a function to get account information from address
func GetAccountInfoFromAddr(address sdk.AccAddress, t *testing.T) auth.BaseAccount {
	exportedAccInfo := tci.Ak.GetAccount(tci.Ctx, address)
	accInfo := auth.BaseAccount{
		Address:       exportedAccInfo.GetAddress(),
		Coins:         exportedAccInfo.GetCoins(),
		PubKey:        exportedAccInfo.GetPubKey(),
		AccountNumber: exportedAccInfo.GetAccountNumber(),
		Sequence:      exportedAccInfo.GetSequence(),
	}
	return accInfo
}

// GetAccountInfoFromName is a function to get account information from account key
func GetAccountInfoFromName(key string, t *testing.T) auth.BaseAccount {
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
		case msgs.MsgCreateCookbook:
			fields[ikeypref+"type"] = "MsgCreateCookbook"
			fields[ikeypref+"cb_name"] = msg.Name
			fields[ikeypref+"sender"] = msg.Sender.String()
		case msgs.MsgCreateRecipe:
			fields[ikeypref+"type"] = "MsgCreateRecipe"
			fields[ikeypref+"rcp_name"] = msg.Name
			fields[ikeypref+"sender"] = msg.Sender.String()
		case msgs.MsgExecuteRecipe:
			fields[ikeypref+"type"] = "MsgCreateRecipe"
			fields[ikeypref+"rcp_id"] = msg.RecipeID
			fields[ikeypref+"sender"] = msg.Sender
		case msgs.MsgCheckExecution:
			fields[ikeypref+"type"] = "MsgCheckExecution"
			fields[ikeypref+"exec_id"] = msg.ExecID
			fields[ikeypref+"sender"] = msg.Sender.String()
		case msgs.MsgCreateTrade:
			fields[ikeypref+"type"] = "MsgCreateTrade"
			fields[ikeypref+"trade_info"] = msg.ExtraInfo
			fields[ikeypref+"sender"] = msg.Sender.String()
		case msgs.MsgFulfillTrade:
			fields[ikeypref+"type"] = "MsgFulfillTrade"
			fields[ikeypref+"trade_id"] = msg.TradeID
			fields[ikeypref+"sender"] = msg.Sender.String()
		case msgs.MsgFiatItem:
			fields[ikeypref+"type"] = "MsgFiatItem"
			fields[ikeypref+"sender"] = msg.Sender.String()
		case msgs.MsgUpdateItemString:
			fields[ikeypref+"type"] = "MsgUpdateItemString"
			fields[ikeypref+"item_id"] = msg.ItemID
			fields[ikeypref+"sender"] = msg.Sender.String()
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
