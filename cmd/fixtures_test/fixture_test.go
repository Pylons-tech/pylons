package fixtureTest

import (
	"encoding/json"
	"os"
	"path/filepath"
	"strconv"

	originT "testing"

	testing "github.com/MikeSofaer/pylons/cmd/fixtures_test/evtesting"

	intTest "github.com/MikeSofaer/pylons/cmd/test"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

func PropertyExistCheck(step FixtureStep, t *testing.T) {

	pCheck := step.Output.Property
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
			if exist {
				t.Log("checked existance")
			} else {
				t.Fatal("cookbook with name=", cbName, "does not exist")
			}
		}
	}
	if len(pCheck.Recipes) > 0 {
		for _, rcpName := range pCheck.Recipes {
			guid, err := intTest.GetRecipeGUIDFromName(rcpName, pOwnerAddr)
			intTest.ErrValidation(t, "error checking if recipe already exist %+v", err)

			if len(guid) > 0 {
				t.Log("checked existance")
			} else {
				t.Fatal("recipe with name=", rcpName, "does not exist")
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

			if fitItemExist {
				t.Log("checked item existence")
			} else {
				t.Fatal("no item exist which fit item spec")
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

func ProcessSingleFixtureQueueItem(file string, idx int, step FixtureStep, t *testing.T) {
	t.Run(strconv.Itoa(idx)+"_"+step.ID, func(t *testing.T) {
		t.Parallel()
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
		default:
			t.Fatalf("step with unrecognizable action found %s", step.Action)
		}
		PropertyExistCheck(step, t)
		UpdateWorkQueueStatus(file, idx, step, DONE, t)
	})
}

func RunSingleFixtureTest(file string, t *testing.T) {
	t.Run(file, func(t *testing.T) {
		t.Parallel()
		var fixtureSteps []FixtureStep
		byteValue := ReadFile(file, t)
		json.Unmarshal([]byte(byteValue), &fixtureSteps)

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

func TestFixturesViaCLI(t *originT.T) {
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
