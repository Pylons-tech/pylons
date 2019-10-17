package main

import (
	"encoding/json"
	"testing"

	"github.com/MikeSofaer/pylons/x/pylons/queriers"
	"github.com/MikeSofaer/pylons/x/pylons/types"
)

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

func ListExecutionsViaCLI(t *testing.T) ([]types.Execution, error) {
	output, err := RunPylonsCli([]string{"query", "pylons", "list_executions"}, "")
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

func ListItemsViaCLI(t *testing.T) ([]types.Item, error) {
	output, err := RunPylonsCli([]string{"query", "pylons", "items_by_sender"}, "")
	if err != nil {
		return []types.Item{}, err
	}
	var itemResp queriers.ItemResp
	err = GetAminoCdc().UnmarshalJSON(output, &itemResp)
	if err != nil {
		t.Errorf("error unmarshaling itemResp ::: %+v ::: %+v", string(output), err)
		return []types.Item{}, err
	}
	return itemResp.Items, err
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
