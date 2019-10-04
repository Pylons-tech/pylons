package main

import (
	"encoding/json"
	"io/ioutil"
	"os"

	"testing"

	"github.com/stretchr/testify/require"
)

type SuccessTxResp struct {
	Height string `json:"height"`
	Txhash string `json:"txhash"`
}

type MsgValueModel struct {
	Description  string
	Developer    string
	Level        string
	Name         string
	Sender       string
	SupportEmail string
	Version      string
}
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
			// pylonscli keys show eugen -a
			eugenAddr := GetAccountAddr("eugen", t)

			txModel := TxModel{
				Type: "auth/StdTx",
				Value: TxValueModel{
					Msg: []MsgModel{MsgModel{
						Type: "pylons/CreateCookbook",
						Value: MsgValueModel{
							Description:  "this has to meet character limits lol",
							Developer:    "SketchyCo",
							Level:        "0",
							Name:         "Morethan8Name",
							Sender:       eugenAddr,
							SupportEmail: "example@example.com",
							Version:      "1.0.0",
						},
					}},
					Fee: FeeModel{
						Amount: nil,
						Gas:    "200000",
					},
					Signatures: nil,
					Memo:       "",
				},
			}
			output, err := json.Marshal(txModel)
			ioutil.WriteFile(tc.txJson, output, 0644)
			if err != nil {
				t.Errorf("error writing raw transaction: %+v --- %+v", string(output), err)
				t.Fatal(err)
			}
			// t.Errorf("eugen addr GET:: %+v", eugenAddr)

			// pylonscli tx sign create_cookbook_tx.json --from cosmos19vlpdf25cxh0w2s80z44r9ktrgzncf7zsaqey2 --chain-id pylonschain > signedCreateCookbookTx.json
			txSignArgs := []string{"tx", "sign", tc.txJson,
				"--from", eugenAddr,
				"--chain-id", "pylonschain",
			}
			output, err = RunPylonsCli(txSignArgs, "11111111\n")
			if err != nil {
				t.Errorf("error signing transaction: %+v --- %+v", string(output), err)
				t.Fatal(err)
			}
			err = ioutil.WriteFile(signedTxFile, output, 0644)
			if err != nil {
				t.Errorf("error writing signed transaction %+v", err)
				t.Fatal(err)
			}

			// pylonscli tx broadcast signedCreateCookbookTx.json
			txBroadcastArgs := []string{"tx", "broadcast", signedTxFile}
			output, err = RunPylonsCli(txBroadcastArgs, "")

			successTxResp := SuccessTxResp{}

			err = json.Unmarshal(output, &successTxResp)
			// t.Errorf("signedCreateCookbookTx.json broadcast result: %+v", successTxResp)
			if err != nil {
				t.Errorf("error unmarshaling json %+v --- %+v", string(output), err)
				t.Fatal(err)
			}
			require.True(t, len(successTxResp.Txhash) == 64)
			require.True(t, len(successTxResp.Height) > 0)

			err = os.Remove(tc.txJson)
			if err != nil {
				t.Errorf("error removing raw tx file json %+v", err)
				t.Fatal(err)
			}
			err = os.Remove(signedTxFile)
			if err != nil {
				t.Errorf("error removing signed tx file json %+v", err)
				t.Fatal(err)
			}
		})
	}
}
