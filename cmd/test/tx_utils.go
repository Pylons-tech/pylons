package intTest

import (
	"time"
	"bytes"
	"encoding/json"
	"io/ioutil"
	"net/http"
	"os"
	"path/filepath"
	"strconv"
	"sync"

	testing "github.com/Pylons-tech/pylons/cmd/fixtures_test/evtesting"

	"github.com/Pylons-tech/pylons/x/pylons/types"

	"github.com/cosmos/cosmos-sdk/client/context"
	"github.com/cosmos/cosmos-sdk/x/auth/client/utils"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/x/auth"

	"github.com/spf13/viper"
)

var nonceMux sync.Mutex

const (
	DefaultCoinPerRequest = 500
)

func fileExists(filename string) bool {
	info, err := os.Stat(filename)
	if os.IsNotExist(err) {
		return false
	}
	return !info.IsDir()
}

func GenTxWithMsg(messages []sdk.Msg) (auth.StdTx, error) {
	var err error
	cdc := GetAminoCdc()
	cliCtx := context.NewCLIContext().WithCodec(cdc)

	viper.Set("keyring-backend", "test")
	viper.Set("chain-id", "pylonschain")

	txBldr := auth.NewTxBuilderFromCLI(&bytes.Buffer{}).WithTxEncoder(utils.GetTxEncoder(cdc)).WithChainID("pylonschain")
	if txBldr.SimulateAndExecute() {
		txBldr, err = utils.EnrichWithGas(txBldr, cliCtx, messages)
		if err != nil {
			return auth.StdTx{}, err
		}
	}

	stdSignMsg, err := txBldr.BuildSignMsg(messages)
	if err != nil {
		return auth.StdTx{}, err
	}

	return auth.NewStdTx(stdSignMsg.Msgs, stdSignMsg.Fee, nil, stdSignMsg.Memo), nil
}

func TestQueryListRecipe(t *testing.T) ([]types.Recipe, error) {
	output, err, _ := RunPylonsCli([]string{"query", "pylons", "list_recipe"}, "")
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

func broadcastTxFile(signedTxFile string, maxRetry int, t *testing.T) string {
	if len(CLIOpts.RestEndpoint) == 0 { // broadcast using cli
		// pylonscli tx broadcast signedCreateCookbookTx.json
		txBroadcastArgs := []string{"tx", "broadcast", signedTxFile}
		output, err, logstr := RunPylonsCli(txBroadcastArgs, "")
		output2, _, logstr2 := RunPylonsCli([]string{"query", "account", "cosmos10xgn8t2auxskrf2qjcht0hwq2h5chnrpx87dus"}, "")
		t.Log("transaction broadcast log", logstr, "\npylonscli query account log", logstr2, string(output2))

		txResponse := sdk.TxResponse{}

		err = GetAminoCdc().UnmarshalJSON(output, &txResponse)
		// This can happen when "pylonscli config output json" is not set or when real issue is available
		ErrValidationWithOutputLog(t, "error in broadcasting signed transaction output: %+v, err: %+v", output, err)

		if txResponse.Code != 0 && maxRetry > 0 {
			t.Log("rebroadcasting after 1s...", maxRetry, "left")
			time.Sleep(1 * time.Second)
			return broadcastTxFile(signedTxFile, maxRetry-1, t)
		}
		t.MustTrue(len(txResponse.TxHash) == 64)
		t.MustTrue(txResponse.Code == 0)
		return txResponse.TxHash
	} else { // broadcast using rest endpoint
		signedTx := ReadFile(signedTxFile, t)
		postBodyJSON := make(map[string]interface{})
		json.Unmarshal(signedTx, &postBodyJSON)
		postBodyJSON["tx"] = postBodyJSON["value"]
		postBodyJSON["value"] = nil
		postBodyJSON["mode"] = "sync"
		postBody, err := json.Marshal(postBodyJSON)

		if err != nil {
			t.Fatal(err)
		}
		resp, err := http.Post(CLIOpts.RestEndpoint+"/txs", "application/json", bytes.NewBuffer(postBody))
		if err != nil {
			t.Fatal(err)
		}

		var result map[string]string

		json.NewDecoder(resp.Body).Decode(&result)
		defer resp.Body.Close()
		t.Log("get_pylons_api_response", result)
		t.MustTrue(len(result["txhash"]) == 64)
		return result["txhash"]
	}
}

func TestTxWithMsg(t *testing.T, msgValue sdk.Msg, signer string) string {
	tmpDir, err := ioutil.TempDir("", "pylons")
	if err != nil {
		panic(err.Error())
	}
	rawTxFile := filepath.Join(tmpDir, "raw_tx.json")
	signedTxFile := filepath.Join(tmpDir, "signed_tx.json")

	txModel, err := GenTxWithMsg([]sdk.Msg{msgValue})
	t.MustNil(err)
	output, err := GetAminoCdc().MarshalJSON(txModel)
	t.MustNil(err)

	ioutil.WriteFile(rawTxFile, output, 0644)
	ErrValidationWithOutputLog(t, "error writing raw transaction: %+v --- %+v", output, err)

	// pylonscli tx sign raw_tx.json --from eugen --chain-id pylonschain > signed_tx.json
	txSignArgs := []string{"tx", "sign", rawTxFile,
		"--from", signer,
		"--chain-id", "pylonschain",
	}
	output, err, _ = RunPylonsCli(txSignArgs, "")
	ErrValidationWithOutputLog(t, "error signing transaction: %+v --- %+v", output, err)

	err = ioutil.WriteFile(signedTxFile, output, 0644)
	ErrValidation(t, "error writing signed transaction %+v", err)

	txhash := broadcastTxFile(signedTxFile, 50, t)

	CleanFile(rawTxFile, t)
	CleanFile(signedTxFile, t)

	return txhash
}

func TestTxWithMsgWithNonce(t *testing.T, msgValue sdk.Msg, signer string, isBech32Addr bool) string {
	tmpDir, err := ioutil.TempDir("", "pylons")
	if err != nil {
		panic(err.Error())
	}
	nonceRootDir := "./"
	nonceFile := filepath.Join(nonceRootDir, "nonce.json")
	if !isBech32Addr {
		signer = GetAccountAddr(signer, t)
	}

	accInfo := GetAccountInfoFromAddr(signer, t)
	nonce := accInfo.Sequence

	nonceMap := make(map[string]uint64)

	nonceMux.Lock()

	if fileExists(nonceFile) {
		nonceBytes := ReadFile(nonceFile, t)
		err := json.Unmarshal(nonceBytes, &nonceMap)
		if err != nil {
			ErrValidation(t, "error reading nonce: %+v --- %+v", err)
		}
		nonce = nonceMap[signer]
	} else {
		nonce = accInfo.GetSequence()
	}
	nonceMap[signer] = nonce + 1
	nonceOutput, err := json.Marshal(nonceMap)
	t.MustNil(err)
	ioutil.WriteFile(nonceFile, nonceOutput, 0644)

	txModel, err := GenTxWithMsg([]sdk.Msg{msgValue})
	t.MustNil(err)
	output, err := GetAminoCdc().MarshalJSON(txModel)
	t.MustNil(err)

	rawTxFile := filepath.Join(tmpDir, "raw_tx_"+strconv.FormatUint(nonce, 10)+".json")
	signedTxFile := filepath.Join(tmpDir, "signed_tx_"+strconv.FormatUint(nonce, 10)+".json")
	ioutil.WriteFile(rawTxFile, output, 0644)
	ErrValidationWithOutputLog(t, "error writing raw transaction: %+v --- %+v", output, err)

	// pylonscli tx sign sample_transaction.json --account-number 2 --sequence 10 --offline --from eugen
	txSignArgs := []string{"tx", "sign", rawTxFile,
		"--from", signer,
		"--offline",
		"--chain-id", "pylonschain",
		"--sequence", strconv.FormatUint(nonce, 10),
		"--account-number", strconv.FormatUint(accInfo.GetAccountNumber(), 10),
	}
	output, err, _ = RunPylonsCli(txSignArgs, "")
	// output, err, logstr := RunPylonsCli(txSignArgs, "")
	// t.Log("TX sign:: err", err, ", logstr", logstr)
	ErrValidationWithOutputLog(t, "error signing transaction: %+v --- %+v", output, err)

	err = ioutil.WriteFile(signedTxFile, output, 0644)
	ErrValidation(t, "error writing signed transaction %+v", err)

	nonceMux.Unlock()

	txhash := broadcastTxFile(signedTxFile, 50, t)

	CleanFile(rawTxFile, t)
	CleanFile(signedTxFile, t)

	return txhash
}
