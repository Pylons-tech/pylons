package main

import (
	"encoding/json"
	"io/ioutil"
	"strings"

	"testing"

	"github.com/stretchr/testify/require"
)

type CreateCookbookMsgValueModel struct {
	Description  string
	Developer    string
	Level        string
	Name         string
	Sender       string
	SupportEmail string
	Version      string
}

func TestCreateCookbookViaCLI(t *testing.T) {
	tests := []struct {
		name   string
		txJson string
	}{
		{
			"basic flow test",
			"create_cookbook_tx.json",
		},
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			signedTxFile := "signedTx.json"
			eugenAddr := GetAccountAddr("eugen", t) // pylonscli keys show eugen -a

			txModel := GenTxWithMsg(
				CreateCookbookMsgValueModel{
					Description:  "this has to meet character limits lol",
					Developer:    "SketchyCo",
					Level:        "0",
					Name:         "Morethan8Name",
					Sender:       eugenAddr,
					SupportEmail: "example@example.com",
					Version:      "1.0.0",
				},
			)
			output, err := json.Marshal(txModel)
			ioutil.WriteFile(tc.txJson, output, 0644)
			ErrValidation2(t, "error writing raw transaction: %+v --- %+v", output, err)

			// pylonscli tx sign create_cookbook_tx.json --from cosmos19vlpdf25cxh0w2s80z44r9ktrgzncf7zsaqey2 --chain-id pylonschain > signedCreateCookbookTx.json
			txSignArgs := []string{"tx", "sign", tc.txJson,
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
			if err != nil {
				// This is when "pylonscli config output json" is not set not useful now
				StrOutput := string(output)
				require.True(t, strings.Contains(StrOutput, "Response"))
				StrOutput = strings.ReplaceAll(StrOutput, "Response", "")
				require.True(t, strings.Contains(StrOutput, "TxHash"))
				StrOutput = strings.ReplaceAll(StrOutput, "TxHash", "")
				TxHash := strings.Trim(string(StrOutput), ": \n")
				require.True(t, len(TxHash) == 64)
			} else {
				require.True(t, len(successTxResp.TxHash) == 64)
				require.True(t, len(successTxResp.Height) > 0)
			}

			CleanFile(tc.txJson, t)
			CleanFile(signedTxFile, t)
		})
	}
}
