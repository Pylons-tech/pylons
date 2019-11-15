package intTest

import (
	"encoding/hex"
	"testing"

	"github.com/MikeSofaer/pylons/x/pylons/queriers"
	"github.com/MikeSofaer/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

func ListCookbookViaCLI(account string) ([]types.Cookbook, error) {
	queryParams := []string{"query", "pylons", "list_cookbook"}
	if len(account) != 0 {
		queryParams = append(queryParams, "--account", account)
	}
	output, err := RunPylonsCli(queryParams, "")
	if err != nil {
		return []types.Cookbook{}, err
	}
	listCBResp := types.CookbookList{}
	err = GetAminoCdc().UnmarshalJSON(output, &listCBResp)
	if err != nil {
		return []types.Cookbook{}, err
	}
	return listCBResp.Cookbooks, err
}

func ListRecipesViaCLI(account string) ([]types.Recipe, error) {
	queryParams := []string{"query", "pylons", "list_recipe"}
	if len(account) != 0 {
		queryParams = append(queryParams, "--account", account)
	}
	output, err := RunPylonsCli(queryParams, "")
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

func ListExecutionsViaCLI(account string, t *testing.T) ([]types.Execution, error) {
	queryParams := []string{"query", "pylons", "list_executions"}
	if len(account) != 0 {
		queryParams = append(queryParams, "--account", account)
	}
	output, err := RunPylonsCli(queryParams, "")
	if err != nil {
		t.Errorf("error running list_executions cli command ::: %+v", err)
		return []types.Execution{}, err
	}
	var listExecutionsResp queriers.ExecResp
	err = GetAminoCdc().UnmarshalJSON(output, &listExecutionsResp)
	if err != nil {
		t.Errorf("error unmarshaling list executions ::: %+v", err)
		return []types.Execution{}, err
	}
	return listExecutionsResp.Executions, err
}

func ListItemsViaCLI(account string) ([]types.Item, error) {
	queryParams := []string{"query", "pylons", "items_by_sender"}
	if len(account) != 0 {
		queryParams = append(queryParams, "--account", account)
	}
	output, err := RunPylonsCli(queryParams, "")
	if err != nil {
		return []types.Item{}, err
	}
	var itemResp queriers.ItemResp
	err = GetAminoCdc().UnmarshalJSON(output, &itemResp)
	if err != nil {
		return []types.Item{}, err
	}
	return itemResp.Items, err
}

func GetTxError(txhash string, t *testing.T) ([]byte, error) {
	output, err := RunPylonsCli([]string{"query", "tx", txhash}, "")
	if err != nil {
		return []byte{}, err
	}
	var tx sdk.TxResponse
	err = GetAminoCdc().UnmarshalJSON([]byte(output), &tx)
	if err != nil {
		return []byte{}, err
	}
	if len(tx.Logs) > 0 {
		return []byte(tx.Logs[0].Log), nil
	}
	return []byte{}, nil
}

func GetTxData(txhash string, t *testing.T) ([]byte, error) {
	output, err := RunPylonsCli([]string{"query", "tx", txhash}, "")
	if err != nil {
		return []byte{}, err
	}
	var tx sdk.TxResponse
	err = GetAminoCdc().UnmarshalJSON([]byte(output), &tx)
	if err != nil {
		return []byte{}, err
	}
	bs, err := hex.DecodeString(tx.Data)
	if err != nil {
		return []byte{}, err
	}
	return bs, nil
}

func FindCookbookFromArrayByName(cbList []types.Cookbook, name string) (types.Cookbook, bool) {
	for _, cb := range cbList {
		if cb.Name == name {
			return cb, true
		}
	}
	return types.Cookbook{}, false
}

func FindRecipeFromArrayByName(recipes []types.Recipe, name string) (types.Recipe, bool) {
	for _, rcp := range recipes {
		if rcp.Name == name {
			return rcp, true
		}
	}
	return types.Recipe{}, false
}

func FindExecutionByRecipeID(execs []types.Execution, rcpID string) (types.Execution, bool) {
	for _, exec := range execs {
		if exec.RecipeID == rcpID {
			return exec, true
		}
	}
	return types.Execution{}, false
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

// GetCookbookByGUID is to get Cookbook from ID
func GetCookbookByGUID(guid string) (types.Cookbook, error) {
	output, err := RunPylonsCli([]string{"query", "pylons", "get_cookbook", guid}, "")
	if err != nil {
		return types.Cookbook{}, err
	}
	var cookbook types.Cookbook
	err = GetAminoCdc().UnmarshalJSON(output, &cookbook)
	if err != nil {
		return types.Cookbook{}, err
	}
	return cookbook, err
}

func GetCookbookIDFromName(cbName string, account string) (string, bool, error) {
	cbList, err := ListCookbookViaCLI(account)
	if err != nil {
		return "", false, err
	}

	cb, exist := FindCookbookFromArrayByName(cbList, cbName)
	return cb.ID, exist, nil
}

func GetRecipeIDFromName(rcpName string) (string, bool, error) {
	rcpList, err := ListRecipesViaCLI("")
	if err != nil {
		return "", false, err
	}
	rcp, exist := FindRecipeFromArrayByName(rcpList, rcpName)
	return rcp.ID, exist, nil
}

func GetItemIDFromName(itemName string) (string, bool, error) {
	itemList, err := ListItemsViaCLI("")
	if err != nil {
		return "", false, err
	}
	rcp, exist := FindItemFromArrayByName(itemList, itemName)
	return rcp.ID, exist, nil
}

// GetRecipeByGUID is to get Recipe from ID
func GetRecipeByGUID(guid string) (types.Recipe, error) {
	output, err := RunPylonsCli([]string{"query", "pylons", "get_recipe", guid}, "")
	if err != nil {
		return types.Recipe{}, err
	}
	var rcp types.Recipe
	err = GetAminoCdc().UnmarshalJSON(output, &rcp)
	if err != nil {
		return types.Recipe{}, err
	}
	return rcp, err
}

// GetExecutionByGUID is to get Execution from ID
func GetExecutionByGUID(guid string) (types.Execution, error) {
	output, err := RunPylonsCli([]string{"query", "pylons", "get_execution", guid}, "")
	if err != nil {
		return types.Execution{}, err
	}
	var exec types.Execution
	err = GetAminoCdc().UnmarshalJSON(output, &exec)
	if err != nil {
		return types.Execution{}, err
	}
	return exec, err
}

// GetItemByGUID is to get Item from ID
func GetItemByGUID(guid string) (types.Item, error) {
	output, err := RunPylonsCli([]string{"query", "pylons", "get_item", guid}, "")
	if err != nil {
		return types.Item{}, err
	}
	var item types.Item
	err = GetAminoCdc().UnmarshalJSON(output, &item)
	if err != nil {
		return types.Item{}, err
	}
	return item, err
}
