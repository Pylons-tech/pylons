package main

import (
	"os"
	"os/exec"
	"path"
	"testing"

	"strings"
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

func GenTxWithMsg(msgValue MsgValueModel) TxModel {
	return TxModel{
		Type: "auth/StdTx",
		Value: TxValueModel{
			Msg: []MsgModel{
				MsgModel{
					Type:  "pylons/CreateCookbook",
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
