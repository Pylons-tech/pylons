package main

import (
	"encoding/json"
	"errors"
	"io/ioutil"
	"os"
	"os/exec"
	"path"
	"path/filepath"
	"testing"
	"time"

	"strings"

	"github.com/MikeSofaer/pylons/x/pylons/queriers"
	"github.com/MikeSofaer/pylons/x/pylons/types"
	amino "github.com/tendermint/go-amino"
	ctypes "github.com/tendermint/tendermint/rpc/core/types"

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

func GetAminoCdc() *amino.Codec {
	var cdc = amino.NewCodec()
	ctypes.RegisterAmino(cdc)
	return cdc
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

func GetDaemonStatus() (*ctypes.ResultStatus, error) {
	var ds ctypes.ResultStatus

	dsBytes, err := RunPylonsCli([]string{"status"}, "")

	if err != nil {
		return nil, err
	}
	err = GetAminoCdc().UnmarshalJSON(dsBytes, &ds)

	// err = json.Unmarshal(dsBytes, &ds)
	if err != nil {
		return nil, err
	}
	return &ds, nil
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

func MockCookbook(t *testing.T) error {
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
	return WaitForNextBlock()
}

func MockRecipe(t *testing.T) error {
	return MockRecipeWithName("Recipe00001", t)
}

func MockRecipeWithName(name string, t *testing.T) error {
	mCB, err := GetMockedCookbook()
	if err != nil {
		t.Errorf("error getting mocked cookbook %+v", err)
		t.Fatal(err)
	}
	eugenAddr := GetAccountAddr("eugen", t)
	TestTxWithMsg(t, CreateRecipeMsgValueModel{
		BlockInterval: 0,
		CoinInputs:    types.GenCoinInputList("pylon", 5),
		CookbookId:    mCB.ID,
		Description:   "this has to meet character limits lol",
		Entries:       types.GenItemOnlyEntry("Zombie"),
		ItemInputs:    types.ItemInputList{},
		RecipeName:    name,
		Sender:        eugenAddr,
	}, "pylons/CreateRecipe")
	return WaitForNextBlock()
}

func ListCookbookViaCLI() ([]CookbookListModel, error) {
	output, err := RunPylonsCli([]string{"query", "pylons", "list_cookbook"}, "")
	if err != nil {
		return []CookbookListModel{}, err
	}
	listCBResp := ListCookbookRespModel{}
	err = json.Unmarshal(output, &listCBResp)
	if err != nil {
		return []CookbookListModel{}, err
	}
	return listCBResp.Cookbooks, err
}

func ListItemsViaCLI(t *testing.T) ([]types.Item, error) {
	output, err := RunPylonsCli([]string{"query", "pylons", "items_by_sender"}, "")
	if err != nil {
		return []types.Item{}, err
	}
	var itemResp queriers.ItemResp
	// err = json.Unmarshal(output, &itemResp)
	err = GetAminoCdc().UnmarshalJSON(output, &itemResp)
	if err != nil {
		t.Errorf("error unmarshaling itemResp ::: %+v ::: %+v", string(output), err)
		return []types.Item{}, err
	}
	return itemResp.Items, err
}

func FindItemFromArrayByName(items []types.Item, name string) (types.Item, bool) {
	for _, item := range items {
		itemName, _ := item.FindString("Name")
		if itemName == name {
			return item, true
		}
	}
	return types.Item{}, false
}

func FindRecipeFromArrayByName(recipes []types.Recipe, name string) (types.Recipe, bool) {
	for _, rcp := range recipes {
		if rcp.RecipeName == name {
			return rcp, true
		}
	}
	return types.Recipe{}, false
}

func ListRecipesViaCLI() ([]types.Recipe, error) {
	output, err := RunPylonsCli([]string{"query", "pylons", "list_recipe"}, "")
	if err != nil {
		return []types.Recipe{types.Recipe{}}, err
	}
	listRCPResp := types.RecipeList{}
	err = GetAminoCdc().UnmarshalJSON(output, &listRCPResp)
	if err != nil {
		return []types.Recipe{types.Recipe{}}, err
	}
	return listRCPResp.Recipes, err
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

func WaitForNextBlock() error {
	ds, err := GetDaemonStatus()
	if err != nil {
		return err // couldn't get daemon status.
	}
	currentBlock := ds.SyncInfo.LatestBlockHeight

	counter := 1
	for counter < 300 {
		ds, err = GetDaemonStatus()
		if ds.SyncInfo.LatestBlockHeight > currentBlock {
			return nil
		}
		time.Sleep(100 * time.Millisecond)
		counter += 1
	}
	return errors.New("No new block found though waited for 30s")
}

func GetMockedCookbook() (CookbookListModel, error) {
	cbList, err := ListCookbookViaCLI()
	if err != nil {
		return CookbookListModel{}, err
	}
	return cbList[0], nil
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
	ErrValidationWithOutputLog(t, "error writing raw transaction: %+v --- %+v", output, err)

	// pylonscli tx sign create_cookbook_tx.json --from cosmos19vlpdf25cxh0w2s80z44r9ktrgzncf7zsaqey2 --chain-id pylonschain > signedCreateCookbookTx.json
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

func ErrValidationWithOutputLog(t *testing.T, format string, bytes []byte, err error) {
	if err != nil {
		t.Errorf(format, string(bytes), err)
		t.Fatal(err)
	}
}
