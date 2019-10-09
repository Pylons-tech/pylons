package main

import (
	// "encoding/json"
	// "io/ioutil"
	// "strings"
	"encoding/json"
	"testing"

	"github.com/MikeSofaer/pylons/x/pylons/types"
)

type CreateCookbookMsgValueModel struct {
	Description  string
	Developer    string
	Level        string
	Name         string
	Sender       string
	SupportEmail string
	Version      string
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

type CreateRecipeMsgValueModel struct {
	BlockInterval int64 `json:",string"`
	CoinInputs    types.CoinInputList
	CookbookId    string
	Description   string
	Entries       types.WeightedParamList
	ItemInputs    types.ItemInputList
	RecipeName    string
	Sender        string
}

func TestCreateCookbookViaCLI(t *testing.T) {
	tests := []struct {
		name string
	}{
		{
			"basic flow test",
		},
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			eugenAddr := GetAccountAddr("eugen", t)
			TestTxWithMsg(t, CreateCookbookMsgValueModel{
				Description:  "this has to meet character limits lol",
				Developer:    "SketchyCo",
				Level:        "0",
				Name:         "Morethan8Name",
				Sender:       eugenAddr,
				SupportEmail: "example@example.com",
				Version:      "1.0.0",
			}, "pylons/CreateCookbook")
		})
	}
}

func TestCreateRecipeViaCLI(t *testing.T) {
	MockCookbook(t)

	tests := []struct {
		name string
	}{
		{
			"basic flow test",
		},
	}

	cbList, err := ListCookbookViaCLI()
	if err != nil {
		t.Errorf("error getting cookbook list %+v", err)
		t.Fatal(err)
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			eugenAddr := GetAccountAddr("eugen", t)
			TestTxWithMsg(t, CreateRecipeMsgValueModel{
				BlockInterval: 0,
				CoinInputs:    types.GenCoinInputList("wood", 5), // should use GenCoinInput
				CookbookId:    cbList[0].ID,                      // should use mocked ID
				Description:   "this has to meet character limits lol",
				Entries:       types.GenEntries("chair", "Raichu"), // use GenEntries
				ItemInputs:    types.GenItemInputList("Raichu"),    // use GenItem
				RecipeName:    "Recipe00001",
				Sender:        eugenAddr,
			}, "pylons/CreateRecipe")
		})
	}
}
