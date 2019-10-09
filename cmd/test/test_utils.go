package main

import (
	"encoding/json"
	"io/ioutil"
	"os"
	"os/exec"
	"path"
	"path/filepath"
	"testing"
	"time"

	"strings"

	"github.com/stretchr/testify/require"
)

type SuccessTxResp struct {
	Height string `json:"height"`
	TxHash string `json:"txhash"`
}

type MsgValueModel interface{}

type MsgModel struct {
	Type  string        `json:"type"`
	Value MsgValueModel `json:"value"`
}

type FeeModel struct {
	Amount *string `json:"amount"`
	Gas    string  `json:"gas"`
}
type TxValueModel struct {
	Msg        []MsgModel `json:"msg"`
	Fee        FeeModel   `json:"fee"`
	Signatures *string    `json:"signatures"`
	Memo       string     `json:"memo"`
}

type TxModel struct {
	Type  string       `json:"type"`
	Value TxValueModel `json:"value"`
}

func RunPylonsCli(args []string, stdinInput string) ([]byte, error) { // run pylonscli with specific params : helper function
	cmd := exec.Command(path.Join(os.Getenv("GOPATH"), "/bin/pylonscli"), args...)
	cmd.Stdin = strings.NewReader(stdinInput)
	return cmd.CombinedOutput()
}

func GetAccountAddr(account string, t *testing.T) string {
	addrBytes, err := RunPylonsCli([]string{"keys", "show", account, "-a"}, "")
	addr := strings.Trim(string(addrBytes), "\n ")
	if t != nil && err != nil {
		t.Errorf("error getting account address %+v", err)
	}
	return addr
}

func GenTxWithMsg(msgValue MsgValueModel, msgType string) TxModel {
	return TxModel{
		Type: "auth/StdTx",
		Value: TxValueModel{
			Msg: []MsgModel{
				MsgModel{
					Type:  msgType,
					Value: msgValue,
				},
			},
			Fee: FeeModel{
				Amount: nil,
				Gas:    "200000",
			},
			Signatures: nil,
			Memo:       "",
		},
	}
}

func MockCookbook(t *testing.T) {
	eugenAddr := GetAccountAddr("eugen", t)
	TestTxWithMsg(t, CreateCookbookMsgValueModel{
		Description:  "this has to meet character limits lol",
		Developer:    "SketchyCo",
		Level:        "0",
		Name:         "COOKBOOK_MOCK_001",
		Sender:       eugenAddr,
		SupportEmail: "example@example.com",
		Version:      "1.0.0",
	}, "pylons/CreateCookbook")
	time.Sleep(2 * time.Second)
}

func TestTxWithMsg(t *testing.T, msgValue MsgValueModel, msgType string) {
	tmpDir, err := ioutil.TempDir("", "pylons")
	if err != nil {
		panic(err.Error())
	}
	rawTxFile := filepath.Join(tmpDir, "raw_tx.json")
	signedTxFile := filepath.Join(tmpDir, "signed_tx.json")

	eugenAddr := GetAccountAddr("eugen", t) // pylonscli keys show eugen -a

	txModel := GenTxWithMsg(msgValue, msgType)
	output, err := json.Marshal(txModel)

	ioutil.WriteFile(rawTxFile, output, 0644)
	ErrValidation2(t, "error writing raw transaction: %+v --- %+v", output, err)

	// pylonscli tx sign create_cookbook_tx.json --from cosmos19vlpdf25cxh0w2s80z44r9ktrgzncf7zsaqey2 --chain-id pylonschain > signedCreateCookbookTx.json
	txSignArgs := []string{"tx", "sign", rawTxFile,
		"--from", eugenAddr,
		"--chain-id", "pylonschain",
	}
	output, err = RunPylonsCli(txSignArgs, "11111111\n")
	ErrValidation2(t, "error signing transaction: %+v --- %+v", output, err)

	err = ioutil.WriteFile(signedTxFile, output, 0644)
	ErrValidation(t, "error writing signed transaction %+v", err)

	// pylonscli tx broadcast signedCreateCookbookTx.json
	txBroadcastArgs := []string{"tx", "broadcast", signedTxFile}
	output, err = RunPylonsCli(txBroadcastArgs, "")

	successTxResp := SuccessTxResp{}

	err = json.Unmarshal(output, &successTxResp)
	// t.Errorf("signedCreateCookbookTx.json broadcast result: %+v", successTxResp)
	if err != nil { // This can happen when "pylonscli config output json" is not set or when real issue is available
		t.Errorf("error in broadcasting signed transaction output: %+v, err: %+v", string(output), err)
		t.Fatal(err)
	}
	require.True(t, len(successTxResp.TxHash) == 64)
	require.True(t, len(successTxResp.Height) > 0)

	CleanFile(rawTxFile, t)
	CleanFile(signedTxFile, t)
}

func CleanFile(filePath string, t *testing.T) {
	err := os.Remove(filePath)
	if err != nil {
		t.Errorf("error removing raw tx file json %+v", err)
		t.Fatal(err)
	}
}

func ErrValidation(t *testing.T, format string, err error) {
	if err != nil {
		t.Errorf(format, err)
		t.Fatal(err)
	}
}

func ErrValidation2(t *testing.T, format string, bytes []byte, err error) {
	if err != nil {
		t.Errorf(format, string(bytes), err)
		t.Fatal(err)
	}
}
