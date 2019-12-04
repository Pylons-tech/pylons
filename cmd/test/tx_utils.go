package intTest

import (
	"encoding/json"
	"io/ioutil"
	"os"
	"path/filepath"
	"strconv"
	"sync"

	testing "github.com/MikeSofaer/pylons/cmd/fixtures_test/evtesting"

	"github.com/MikeSofaer/pylons/x/pylons/types"

	"github.com/cosmos/cosmos-sdk/client/context"
	"github.com/cosmos/cosmos-sdk/client/utils"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/x/auth"
	authtxb "github.com/cosmos/cosmos-sdk/x/auth/client/txbuilder"
)

type SuccessTxResp struct {
	Height string `json:"height"`
	TxHash string `json:"txhash"`
}

var nonceMux sync.Mutex

type NonceStruct struct {
	Nonce uint64 `json:"nonce"`
}

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
	cliCtx := context.NewCLIContext().WithCodec(cdc).WithAccountDecoder(cdc)

	txBldr := authtxb.NewTxBuilderFromCLI().WithTxEncoder(utils.GetTxEncoder(cdc)).WithChainID("pylons")
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

func broadcastTxFile(signedTxFile string, t *testing.T) string {
	// pylonscli tx broadcast signedCreateCookbookTx.json
	txBroadcastArgs := []string{"tx", "broadcast", signedTxFile}
	output, err := RunPylonsCli(txBroadcastArgs, "")

	successTxResp := SuccessTxResp{}

	err = json.Unmarshal(output, &successTxResp)
	// This can happen when "pylonscli config output json" is not set or when real issue is available
	ErrValidationWithOutputLog(t, "error in broadcasting signed transaction output: %+v, err: %+v", output, err)

	t.MustTrue(len(successTxResp.TxHash) == 64)
	t.MustTrue(len(successTxResp.Height) > 0)
	return successTxResp.TxHash
}

func TestTxWithMsg(t *testing.T, msgValue sdk.Msg, signer string) string {
	tmpDir, err := ioutil.TempDir("", "pylons")
	if err != nil {
		panic(err.Error())
	}
	rawTxFile := filepath.Join(tmpDir, "raw_tx.json")
	signedTxFile := filepath.Join(tmpDir, "signed_tx.json")

	txModel, err := GenTxWithMsg([]sdk.Msg{msgValue})
	t.MustTrue(err == nil)
	output, err := GetAminoCdc().MarshalJSON(txModel)
	t.MustTrue(err == nil)

	ioutil.WriteFile(rawTxFile, output, 0644)
	ErrValidationWithOutputLog(t, "error writing raw transaction: %+v --- %+v", output, err)

	// pylonscli tx sign raw_tx.json --from eugen --chain-id pylonschain > signed_tx.json
	txSignArgs := []string{"tx", "sign", rawTxFile,
		"--from", signer,
		"--chain-id", "pylonschain",
	}
	output, err = RunPylonsCli(txSignArgs, "11111111\n")
	ErrValidationWithOutputLog(t, "error signing transaction: %+v --- %+v", output, err)

	err = ioutil.WriteFile(signedTxFile, output, 0644)
	ErrValidation(t, "error writing signed transaction %+v", err)

	txhash := broadcastTxFile(signedTxFile, t)

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
	var nonceStruct NonceStruct

	nonceMux.Lock()

	if fileExists(nonceFile) {
		nonceBytes := ReadFile(nonceFile, t)
		err := json.Unmarshal(nonceBytes, &nonceStruct)
		if err != nil {
			ErrValidation(t, "error reading nonce: %+v --- %+v", err)
		}
		nonce = nonceStruct.Nonce
	} else {
		nonce = accInfo.GetSequence()
	}
	nonceStruct.Nonce = nonce + 1
	nonceOutput, err := json.Marshal(nonceStruct)
	t.MustTrue(err == nil)
	ioutil.WriteFile(nonceFile, nonceOutput, 0644)

	txModel, err := GenTxWithMsg([]sdk.Msg{msgValue})
	t.MustTrue(err == nil)
	output, err := GetAminoCdc().MarshalJSON(txModel)
	t.MustTrue(err == nil)

	rawTxFile := filepath.Join(tmpDir, "raw_tx_"+strconv.FormatUint(nonce, 10)+".json")
	signedTxFile := filepath.Join(tmpDir, "signed_tx_"+strconv.FormatUint(nonce, 10)+".json")
	ioutil.WriteFile(rawTxFile, output, 0644)
	ErrValidationWithOutputLog(t, "error writing raw transaction: %+v --- %+v", output, err)

	t.Log("TX sign with nonce=", nonce)
	// pylonscli tx sign sample_transaction.json --account-number 2 --sequence 10 --offline --from eugen
	txSignArgs := []string{"tx", "sign", rawTxFile,
		"--from", signer,
		"--offline",
		"--chain-id", "pylonschain",
		"--sequence", strconv.FormatUint(nonce, 10),
		"--account-number", strconv.FormatUint(accInfo.GetAccountNumber(), 10),
	}
	output, err = RunPylonsCli(txSignArgs, "11111111\n")
	// t.Log("TX sign result msg=", msgValue, "output=", string(output))
	ErrValidationWithOutputLog(t, "error signing transaction: %+v --- %+v", output, err)

	err = ioutil.WriteFile(signedTxFile, output, 0644)
	ErrValidation(t, "error writing signed transaction %+v", err)

	nonceMux.Unlock()

	txhash := broadcastTxFile(signedTxFile, t)

	CleanFile(rawTxFile, t)
	CleanFile(signedTxFile, t)

	return txhash
}
