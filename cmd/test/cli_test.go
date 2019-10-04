package main

import (
	"encoding/json"
	"flag"
	"io/ioutil"
	"os"
	"path/filepath"
	"runtime"

	"testing"

	"github.com/stretchr/testify/require"
)

type SuccessTxResp struct {
	Height string `json:"height"`
	Txhash string `json:"txhash"`
}

var update = flag.Bool("update", false, "update golden files")

var binaryName = "echo-args"

func fixturePath(t *testing.T, fixture string) string {
	_, filename, _, ok := runtime.Caller(0)
	if !ok {
		t.Fatalf("problems recovering caller information")
	}

	return filepath.Join(filepath.Dir(filename), fixture)
}

func writeFixture(t *testing.T, fixture string, content []byte) {
	err := ioutil.WriteFile(fixturePath(t, fixture), content, 0644)
	if err != nil {
		t.Fatal(err)
	}
}

func loadFixture(t *testing.T, fixture string) string {
	content, err := ioutil.ReadFile(fixturePath(t, fixture))
	if err != nil {
		t.Fatal(err)
	}

	return string(content)
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

			// pylonscli tx sign create_cookbook_tx.json --from cosmos19vlpdf25cxh0w2s80z44r9ktrgzncf7zsaqey2 --chain-id pylonschain > signedCreateCookbookTx.json
			txSignArgs := []string{"tx", "sign", tc.txJson,
				"--from", eugenAddr,
				"--chain-id", "pylonschain",
			}
			output, err := RunPylonsCli(txSignArgs, "11111111\n")
			if err != nil {
				t.Errorf("error signing transaction: %+v --- %+v", output, err)
			}
			err = ioutil.WriteFile(signedTxFile, output, 0644)
			if err != nil {
				t.Errorf("error writing signed transaction %+v", err)
			}

			// pylonscli tx broadcast signedCreateCookbookTx.json
			txBroadcastArgs := []string{"tx", "broadcast", signedTxFile}
			output, err = RunPylonsCli(txBroadcastArgs, "")

			successTxResp := SuccessTxResp{}

			err = json.Unmarshal(output, &successTxResp)
			// t.Errorf("signedCreateCookbookTx.json broadcast result: %+v", successTxResp)
			require.True(t, err == nil)
			require.True(t, len(successTxResp.Txhash) == 64)
			require.True(t, len(successTxResp.Height) > 0)

			err = os.Remove(signedTxFile)
			require.True(t, err == nil)
		})
	}
}
