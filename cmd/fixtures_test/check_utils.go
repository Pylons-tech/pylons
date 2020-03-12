package fixtureTest

import (
	"encoding/json"
	"os"
	"path/filepath"
	"strconv"

	originT "testing"

	testing "github.com/Pylons-tech/pylons/cmd/fixtures_test/evtesting"
	intTest "github.com/Pylons-tech/pylons/cmd/test"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

type FixtureStep struct {
	ID       string `json:"ID"`
	RunAfter struct {
		PreCondition []string `json:"precondition"`
		BlockWait    int64    `json:"blockWait"`
	} `json:"runAfter"`
	Action        string `json:"action"`
	BlockInterval int64  `json:"blockInterval"`
	ParamsRef     string `json:"paramsRef"`
	Output        struct {
		TxResult struct {
			Status   string `json:"status"`
			Message  string `json:"message"`
			ErrorLog string `json:"errLog"`
		} `json:"txResult"`
		Property []struct {
			Owner          string   `json:"owner"`
			ShouldNotExist bool     `json:"shouldNotExist"`
			Cookbooks      []string `json:"cookbooks"`
			Recipes        []string `json:"recipes"`
			Items          []struct {
				StringKeys   []string                     `json:"stringKeys"`
				StringValues map[string]string            `json:"stringValues"`
				DblKeys      []string                     `json:"dblKeys"`
				DblValues    map[string]types.FloatString `json:"dblValues"`
				LongKeys     []string                     `json:"longKeys"`
				LongValues   map[string]int               `json:"longValues"`
			} `json:"items"`
			Coins []struct {
				Coin   string `json:"denom"`
				Amount int64  `json:"amount"`
			} `json:"coins"`
		} `json:"property"`
	} `json:"output"`
}

type FixtureTestOptions struct {
	IsParallel bool
}

var FixtureTestOpts FixtureTestOptions = FixtureTestOptions{
	IsParallel: true,
}

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

func CheckItemWithDblValues(item types.Item, dblValues map[string]types.FloatString) bool {
	for sK, sV := range dblValues {
		keyExist := false
		for _, sKV := range item.Doubles {
			if sK == sKV.Key && sV.Float() == sKV.Value.Float() {
				keyExist = true
			}
		}
		if !keyExist {
			return false
		}
	}
	return true
}

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

func CheckItemWithLongValues(item types.Item, longValues map[string]int) bool {
	for sK, sV := range longValues {
		keyExist := false
		for _, sKV := range item.Longs {
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

func CheckErrorOnTx(txhash string, t *testing.T) {
	hmrErrMsg := intTest.GetHumanReadableErrorFromTxHash(txhash, t)
	if len(hmrErrMsg) > 0 {
		t.Fatal("txhash=", txhash, "hmrErrMsg=", hmrErrMsg)
	}
}

func PropertyExistCheck(step FixtureStep, t *testing.T) {
	for _, pCheck := range step.Output.Property {
		shouldNotExist := pCheck.ShouldNotExist
		var pOwnerAddr string
		if len(pCheck.Owner) == 0 {
			pOwnerAddr = ""
		} else {
			pOwnerAddr = intTest.GetAccountAddr(pCheck.Owner, t)
		}
		if len(pCheck.Cookbooks) > 0 {
			for _, cbName := range pCheck.Cookbooks {
				_, exist, err := intTest.GetCookbookIDFromName(cbName, pOwnerAddr)
				if err != nil {
					t.Fatal("error checking cookbook exist", err)
				}
				if !shouldNotExist {
					if exist {
						t.Log("checked existance of cookbook name=", cbName)
					} else {
						t.Fatal("cookbook with name=", cbName, "does not exist")
					}
				} else {
					if exist {
						t.Fatal("cookbook with name=", cbName, "should not exist but it exist")
					} else {
						t.Log("cookbook with name=", cbName, "does not exist as expected")
					}
				}
			}
		}
		if len(pCheck.Recipes) > 0 {
			for _, rcpName := range pCheck.Recipes {
				guid, err := intTest.GetRecipeGUIDFromName(rcpName, pOwnerAddr)
				intTest.ErrValidation(t, "error checking if recipe already exist %+v", err)

				if !shouldNotExist {
					if len(guid) > 0 {
						t.Log("checked existence of recipe name=", rcpName)
					} else {
						t.Fatal("recipe with name=", rcpName, "does not exist")
					}
				} else {
					if len(guid) > 0 {
						t.Fatal("recipe with name=", rcpName, "should not exist but it exist")
					} else {
						t.Log("recipe with name=", rcpName, "does not exist as expected")
					}
				}
			}
		}
		if len(pCheck.Items) > 0 {
			for _, itemCheck := range pCheck.Items {
				fitItemExist := false
				// t.Log("Checking item with spec=", itemCheck, "id=", idx)
				items, err := intTest.ListItemsViaCLI(pOwnerAddr)
				intTest.ErrValidation(t, "error listing items %+v", err)
				for _, item := range items {
					if CheckItemWithStringKeys(item, itemCheck.StringKeys) &&
						CheckItemWithStringValues(item, itemCheck.StringValues) &&
						CheckItemWithDblKeys(item, itemCheck.DblKeys) &&
						CheckItemWithDblValues(item, itemCheck.DblValues) &&
						CheckItemWithLongKeys(item, itemCheck.LongKeys) &&
						CheckItemWithLongValues(item, itemCheck.LongValues) {
						fitItemExist = true
					}
				}
				intTest.ErrValidation(t, "error checking items with string keys %+v", err)

				if !shouldNotExist {
					if fitItemExist {
						t.Log("checked item existence")
					} else {
						t.Fatal("no item exist which fit item spec for", pOwnerAddr, itemCheck)
					}
				} else {
					if fitItemExist {
						t.Fatal("item should not be available but available with spec=", pOwnerAddr, itemCheck)
					} else {
						t.Log("item is not available as expected")
					}
				}
			}
		}
		if len(pCheck.Coins) > 0 {
			for _, coinCheck := range pCheck.Coins {
				accInfo := intTest.GetAccountInfoFromName(pCheck.Owner, t)
				// TODO should we have the case of using GTE, LTE, GT or LT ?
				t.MustTrue(accInfo.Coins.AmountOf(coinCheck.Coin).Equal(sdk.NewInt(coinCheck.Amount)))
			}
		}
	}
}

func ProcessSingleFixtureQueueItem(file string, idx int, step FixtureStep, t *testing.T) {
	t.Run(strconv.Itoa(idx)+"_"+step.ID, func(t *testing.T) {
		if FixtureTestOpts.IsParallel {
			t.Parallel()
		}
		WaitForCondition(file, idx, step, t)

		switch step.Action {
		case "fiat_item":
			RunFiatItem(step, t)
		case "create_cookbook":
			RunCreateCookbook(step, t)
		case "create_recipe":
			RunCreateRecipe(step, t)
		case "execute_recipe":
			RunExecuteRecipe(step, t)
		case "check_execution":
			RunCheckExecution(step, t)
		case "create_trade":
			RunCreateTrade(step, t)
		case "fulfill_trade":
			RunFulfillTrade(step, t)
		default:
			t.Fatalf("step with unrecognizable action found %s", step.Action)
		}
		PropertyExistCheck(step, t)
		UpdateWorkQueueStatus(file, idx, step, DONE, t)
	})
}

func RunSingleFixtureTest(file string, t *testing.T) {
	t.Run(file, func(t *testing.T) {
		if FixtureTestOpts.IsParallel {
			t.Parallel()
		}
		var fixtureSteps []FixtureStep
		byteValue := ReadFile(file, t)
		json.Unmarshal([]byte(byteValue), &fixtureSteps)

		CheckSteps(fixtureSteps, t)

		for idx, step := range fixtureSteps {
			workQueues = append(workQueues, FixtureTestQueueItem{
				fixtureFileName: file,
				idx:             idx,
				stepID:          step.ID,
				status:          NOT_STARTED,
			})
		}
		for idx, step := range fixtureSteps {
			UpdateWorkQueueStatus(file, idx, step, IN_PROGRESS, t)
			ProcessSingleFixtureQueueItem(file, idx, step, t)
		}
	})
}

func RunTestScenarios(scenarioDir string, t *originT.T) {
	newT := testing.NewT(t)
	newT.AddEventListener("FAIL", func() {
		workQueueFailed = true
	})

	var files []string

	scenario_directory := "scenarios"
	err := filepath.Walk(scenario_directory, func(path string, info os.FileInfo, err error) error {
		files = append(files, path)
		return nil
	})
	if err != nil {
		t.Fatal(err)
	}
	for _, file := range files {
		if filepath.Ext(file) != ".json" {
			continue
		}
		t.Log("Running scenario path=", file)
		RunSingleFixtureTest(file, &newT)
	}
}
