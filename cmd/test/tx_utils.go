package main

import (
	"encoding/json"
	"io/ioutil"
	"path/filepath"
	"testing"

	"github.com/MikeSofaer/pylons/x/pylons/types"

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

type CookbookListModel struct {
	ID           string
	Description  string
	Developer    string
	Level        string
	Name         string
	Sender       string
	SupportEmail string
	Version      string
}

type ListCookbookRespModel struct {
	Cookbooks []CookbookListModel
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

func TestQueryListRecipe(t *testing.T) ([]types.Recipe, error) {
	output, err := RunPylonsCli([]string{"query", "pylons", "list_recipe"}, "")
	if err != nil {
		return []types.Recipe{types.Recipe{}}, err
	}
	listRCPResp := types.RecipeList{}
	err = GetAminoCdc().UnmarshalJSON(output, &listRCPResp)
	ErrValidationWithOutputLog(t, "error unmarshaling list recipes: %+v --- %+v", output, err)
	if err != nil {
		return []types.Recipe{types.Recipe{}}, err
	}
	return listRCPResp.Recipes, err
}

func TestTxWithMsg(t *testing.T, msgValue MsgValueModel, msgType string) {
	// tmpDir, err := ioutil.TempDir("", "pylons")
	tmpDir := "./"
	// if err != nil {
	// 	panic(err.Error())
	// }
	rawTxFile := filepath.Join(tmpDir, "raw_tx.json")
	signedTxFile := filepath.Join(tmpDir, "signed_tx.json")

	eugenAddr := GetAccountAddr("eugen", t) // pylonscli keys show eugen -a

	txModel := GenTxWithMsg(msgValue, msgType)
	output, err := GetAminoCdc().MarshalJSON(txModel)

	ioutil.WriteFile(rawTxFile, output, 0644)
	ErrValidationWithOutputLog(t, "error writing raw transaction: %+v --- %+v", output, err)

	// pylonscli tx sign raw_tx.json --from cosmos19vlpdf25cxh0w2s80z44r9ktrgzncf7zsaqey2 --chain-id pylonschain > signed_tx.json
	txSignArgs := []string{"tx", "sign", rawTxFile,
		"--from", eugenAddr,
		"--chain-id", "pylonschain",
	}
	output, err = RunPylonsCli(txSignArgs, "11111111\n")
	ErrValidationWithOutputLog(t, "error signing transaction: %+v --- %+v", output, err)

	err = ioutil.WriteFile(signedTxFile, output, 0644)
	ErrValidation(t, "error writing signed transaction %+v", err)

	// pylonscli tx broadcast signedCreateCookbookTx.json
	txBroadcastArgs := []string{"tx", "broadcast", signedTxFile}
	output, err = RunPylonsCli(txBroadcastArgs, "")

	successTxResp := SuccessTxResp{}

	err = json.Unmarshal(output, &successTxResp)
	// This can happen when "pylonscli config output json" is not set or when real issue is available
	ErrValidationWithOutputLog(t, "error in broadcasting signed transaction output: %+v, err: %+v", output, err)

	require.True(t, len(successTxResp.TxHash) == 64)
	require.True(t, len(successTxResp.Height) > 0)

	CleanFile(rawTxFile, t)
	CleanFile(signedTxFile, t)
}
