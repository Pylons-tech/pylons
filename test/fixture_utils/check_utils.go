package fixturetest

import (
	"encoding/json"
	"fmt"
	"os"
	"path"
	"path/filepath"
	"strconv"
	"strings"
	"sync"

	originT "testing"

	testutils "github.com/Pylons-tech/pylons/test/test_utils"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	testing "github.com/Pylons-tech/pylons_sdk/cmd/evtesting"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// FixtureStep struct describes what should be done in one fixture testcase
type FixtureStep struct {
	ID       string `json:"ID"`
	RunAfter struct {
		PreCondition []string `json:"precondition"`
		BlockWait    int64    `json:"blockWait"`
	} `json:"runAfter"`
	Action    string `json:"action"`
	ParamsRef string `json:"paramsRef"`
	MsgRefs   []struct {
		Action    string `json:"action"`
		ParamsRef string `json:"paramsRef"`
	} `json:"msgRefs"`
	Output struct {
		TxResult struct {
			Status         string `json:"status"`
			Message        string `json:"message"`
			ErrorLog       string `json:"errLog"`
			BroadcastError string `json:"broadcastError"`
		} `json:"txResult"`
		Property []struct {
			Owner          string   `json:"owner"`
			ShouldNotExist bool     `json:"shouldNotExist"`
			Cookbooks      []string `json:"cookbooks"`
			Recipes        []string `json:"recipes"`
			Items          []struct {
				StringKeys   []string           `json:"stringKeys"`
				StringValues map[string]string  `json:"stringValues"`
				DblKeys      []string           `json:"dblKeys"`
				DblValues    map[string]sdk.Dec `json:"dblValues"`
				LongKeys     []string           `json:"longKeys"`
				LongValues   map[string]int64   `json:"longValues"`
				TransferFee  string             `json:"transferFee"`
			} `json:"items"`
			Coins []struct {
				Coin   string `json:"denom"`
				Amount int64  `json:"amount"`
			} `json:"coins"`
		} `json:"property"`
	} `json:"output"`
}

// TestOptions is options struct to manage test options
type TestOptions struct {
	IsParallel    bool
	AccountNames  []string
	BaseDirectory string
}

var runtimeKeyGenMux sync.Mutex
var runtimeAccountKeys = make(map[string]string)

// FixtureTestOpts is a variable to have fixture test options
var FixtureTestOpts = TestOptions{
	IsParallel: true,
}

// CheckItemWithStringKeys checks if string keys are all available
func CheckItemWithStringKeys(item types.Item, stringKeys []string) bool {
	for _, sK := range stringKeys {
		keyExist := false
		for _, sKV := range item.Strings {
			if sK == sKV.Key {
				keyExist = true
			}
		}
		if !keyExist {
			return false
		}
	}
	return true
}

// CheckItemWithStringValues checks if string value/key set are all available
func CheckItemWithStringValues(item types.Item, stringValues map[string]string) bool {
	for sK, sV := range stringValues {
		keyExist := false
		for _, sKV := range item.Strings {
			if sK == sKV.Key && sV == sKV.Value {
				keyExist = true
			}
		}
		if !keyExist {
			return false
		}
	}
	return true
}

// CheckItemWithDblKeys checks if double keys are all available
func CheckItemWithDblKeys(item types.Item, dblKeys []string) bool {
	for _, sK := range dblKeys {
		keyExist := false
		for _, sKV := range item.Doubles {
			if sK == sKV.Key {
				keyExist = true
			}
		}
		if !keyExist {
			return false
		}
	}
	return true
}

// CheckItemWithDblValues checks if double key/values are all available
func CheckItemWithDblValues(item types.Item, dblValues map[string]sdk.Dec) bool {
	for sK, sV := range dblValues {
		keyExist := false
		for _, sKV := range item.Doubles {
			if sK == sKV.Key && sV.Equal(sKV.Value) {
				keyExist = true
			}
		}
		if !keyExist {
			return false
		}
	}
	return true
}

// CheckItemWithLongKeys checks if long keys are all available
func CheckItemWithLongKeys(item types.Item, longKeys []string) bool {
	for _, sK := range longKeys {
		keyExist := false
		for _, sKV := range item.Longs {
			if sK == sKV.Key {
				keyExist = true
			}
		}
		if !keyExist {
			return false
		}
	}
	return true
}

// CheckItemWithLongValues checks if long key/values are all available
func CheckItemWithLongValues(item types.Item, longValues map[string]int64) bool {
	for sK, sV := range longValues {
		keyExist := false
		for _, sKV := range item.Longs {
			if sK == sKV.Key && int64(sV) == sKV.Value {
				keyExist = true
			}
		}
		if !keyExist {
			return false
		}
	}
	return true
}

// CheckItemWithTransferFee checks if additional item send fee is correct
func CheckItemWithTransferFee(item types.Item, transferFee string, t *testing.T) bool {

	if len(transferFee) > 0 {
		n, err := strconv.Atoi(transferFee)
		if err != nil {
			return false
		}
		return int64(n) == item.TransferFee
	}

	return true
}

// PropertyExistCheck function check if an account has required property that needs to be available
func PropertyExistCheck(step FixtureStep, t *testing.T) {
	for _, pCheck := range step.Output.Property {
		shouldNotExist := pCheck.ShouldNotExist
		var pOwnerAddr sdk.AccAddress
		if len(pCheck.Owner) != 0 {
			pOwnerAddr = GetAccountAddressFromTempName(pCheck.Owner, t)
		}
		if len(pCheck.Cookbooks) > 0 {
			for _, cbName := range pCheck.Cookbooks {
				_, exist, err := testutils.GetCookbookIDFromName(cbName, pOwnerAddr)
				t.MustNil(err, "error checking cookbook existance")
				if !shouldNotExist {
					if exist {
						t.WithFields(testing.Fields{
							"cookbook_name": cbName,
						}).Info("cookbook exist, ok")
					}
					t.WithFields(testing.Fields{
						"cookbook_name": cbName,
					}).MustTrue(exist, "cookbook does not exist, but should exist")
				} else {
					if !exist {
						t.WithFields(testing.Fields{
							"cookbook_name": cbName,
						}).Info("cookbook does not exist as expected, ok")
					}
					t.WithFields(testing.Fields{
						"cookbook_name": cbName,
					}).MustTrue(!exist, "cookbook exist, but shouldn't exist")
				}
			}
		}
		if len(pCheck.Recipes) > 0 {
			for _, rcpName := range pCheck.Recipes {
				guid := testutils.GetRecipeGUIDFromName(rcpName, pOwnerAddr)

				if !shouldNotExist {
					if len(guid) > 0 {
						t.WithFields(testing.Fields{
							"recipe_name": rcpName,
						}).Info("recipe exist, ok")
					}
					t.WithFields(testing.Fields{
						"recipe_name": rcpName,
					}).MustTrue(len(guid) > 0, "recipe with does not exist, but should exist")
				} else {
					if len(guid) == 0 {
						t.WithFields(testing.Fields{
							"recipe_name": rcpName,
						}).Info("recipe does not exist as expected, ok")
					}
					t.WithFields(testing.Fields{
						"recipe_name": rcpName,
					}).MustTrue(len(guid) == 0, "recipe exist but shouldn't exist")
				}
			}
		}
		if len(pCheck.Items) > 0 {
			for _, itemCheck := range pCheck.Items {
				fitItemExist := false
				items, err := testutils.ListItems(pOwnerAddr)
				t.MustNil(err, "error listing items")

				for _, item := range items {
					if CheckItemWithStringKeys(item, itemCheck.StringKeys) &&
						CheckItemWithStringValues(item, itemCheck.StringValues) &&
						CheckItemWithDblKeys(item, itemCheck.DblKeys) &&
						CheckItemWithDblValues(item, itemCheck.DblValues) &&
						CheckItemWithLongKeys(item, itemCheck.LongKeys) &&
						CheckItemWithLongValues(item, itemCheck.LongValues) &&
						CheckItemWithTransferFee(item, itemCheck.TransferFee, t) {
						fitItemExist = true
					}
				}

				if !shouldNotExist {
					if fitItemExist {
						t.WithFields(testing.Fields{
							"owner_address": pOwnerAddr,
							"item_spec":     testutils.JSONFormatter(itemCheck),
						}).Info("checked item existence")
					}
					t.WithFields(testing.Fields{
						"owner_address": pOwnerAddr,
						"item_spec":     testutils.JSONFormatter(itemCheck),
					}).MustTrue(fitItemExist, "no item exist which fit item spec")
				} else {
					if !fitItemExist {
						t.WithFields(testing.Fields{
							"owner_address": pOwnerAddr,
							"item_spec":     testutils.JSONFormatter(itemCheck),
						}).Info("item does not exist as expected, ok")
					}
					t.WithFields(testing.Fields{
						"owner_address": pOwnerAddr,
						"item_spec":     testutils.JSONFormatter(itemCheck),
					}).MustTrue(!fitItemExist, "item exist but shouldn't exist")
				}
			}
		}
		if len(pCheck.Coins) > 0 {
			for _, coinCheck := range pCheck.Coins {
				balance := testutils.GetAccountBalanceFromAddr(pOwnerAddr, t)
				// TODO should we have the case of using GTE, LTE, GT or LT ?
				t.WithFields(testing.Fields{
					"target_balance": coinCheck.Amount,
					"actual_balance": balance.Coins.AmountOf(coinCheck.Coin).Int64(),
				}).MustTrue(balance.Coins.AmountOf(coinCheck.Coin).Equal(sdk.NewInt(coinCheck.Amount)), "account balance is incorrect")
			}
		}
	}
}

// ProcessSingleFixtureQueueItem executes a fixture queue item
func ProcessSingleFixtureQueueItem(file string, idx int, fixtureSteps []FixtureStep, lv1t *testing.T) {
	step := fixtureSteps[idx]
	lv1t.Run(strconv.Itoa(idx)+"_"+step.ID, func(t *testing.T) {
		if FixtureTestOpts.IsParallel {
			t.Parallel()
		}
		if step.RunAfter.BlockWait > 0 {
			testutils.WaitForBlockInterval(step.RunAfter.BlockWait)
		}
		RunActionRunner(step.Action, step, t)
		PropertyExistCheck(step, t)
		UpdateWorkQueueStatus(file, idx, fixtureSteps, Done, t)
	})
}

// RunRegisterWorkQueuesForSingleFixture is function to add queue items before running whole test
func RunRegisterWorkQueuesForSingleFixture(file string, t *testing.T) {
	var fixtureSteps []FixtureStep
	byteValue := ReadFile(file, t)

	err := json.Unmarshal([]byte(byteValue), &fixtureSteps)
	t.WithFields(testing.Fields{
		"raw_json": string(byteValue),
	}).MustNil(err, "error decoding fixture steps")

	CheckSteps(fixtureSteps, t)

	for idx, step := range fixtureSteps {
		workQueues = append(workQueues, QueueItem{
			fixtureFileName: file,
			idx:             idx,
			stepID:          step.ID,
			status:          NotStarted,
		})
	}
}

// RunSingleFixtureTest add a work queue into fixture test runner and execute work queues
func RunSingleFixtureTest(file string, t *testing.T) {
	var fixtureSteps []FixtureStep
	byteValue := ReadFile(file, t)

	err := json.Unmarshal([]byte(byteValue), &fixtureSteps)
	t.WithFields(testing.Fields{
		"raw_json": string(byteValue),
	}).MustNil(err, "error decoding fixture steps")

	t.Run(file, func(t *testing.T) {
		if FixtureTestOpts.IsParallel {
			t.Parallel()
		}

		for idx := range fixtureSteps {
			UpdateWorkQueueStatus(file, idx, fixtureSteps, InProgress, t)
		}
	})
}

// RunTestScenarios execute all scenarios
func RunTestScenarios(scenarioDir string, scenarioFileNames []string, t *originT.T) {
	newT := testing.NewT(t)

	// Register default accounts configured into runtime key mapping
	RegisterDefaultAccountKeys(&newT)

	var files []string

	scenarioDirectory := path.Join(FixtureTestOpts.BaseDirectory, scenarioDir)
	err := filepath.Walk(scenarioDirectory, func(path string, info os.FileInfo, err error) error {
		if filepath.Ext(path) != ".json" {
			return nil
		}
		scenarioName := strings.TrimSuffix(info.Name(), ".json")
		t.Log(fmt.Sprintf("checking %s from %+v", scenarioName, scenarioFileNames))
		if len(scenarioFileNames) != 0 && !testutils.Exists(scenarioFileNames, scenarioName) {
			return nil
		}
		t.Log("added", scenarioName)
		files = append(files, path)
		return nil
	})
	if err != nil {
		t.Fatal("error walking through scenario directory", err)
	}
	for _, file := range files {
		t.Log("Registering work queues for scenario path=", file)
		RunRegisterWorkQueuesForSingleFixture(file, &newT)
	}

	for _, file := range files {
		t.Log("Running scenario path=", file)
		RunSingleFixtureTest(file, &newT)
	}
}
