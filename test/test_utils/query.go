package inttest

import (
	"encoding/json"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// ListTradeViaCLI is a function to get list of trades from cli
func ListTradeViaCLI(address sdk.AccAddress) ([]types.Trade, error) {
	return tci.PlnK.GetTradesByCreator(tci.Ctx, address)
}

// GetTradeIDFromExtraInfo is a function to get trade id from trade extra info
func GetTradeIDFromExtraInfo(tradeExtraInfo string) (string, bool, error) {
	trdList, err := ListTradeViaCLI(sdk.AccAddress{})
	if err != nil {
		return "", false, err
	}
	trade, exist := FindTradeFromArrayByExtraInfo(trdList, tradeExtraInfo)
	return trade.ID, exist, nil
}

// ListCookbookViaCLI is a function to list cookbooks via cli
func ListCookbookViaCLI(address sdk.AccAddress) ([]types.Cookbook, error) {
	return tci.PlnK.GetCookbookBySender(tci.Ctx, address)
}

// GetLockedCoinsViaCLI is a function to list locked coins via cli
func GetLockedCoinsViaCLI(address sdk.AccAddress) types.LockedCoin {
	return tci.PlnK.GetLockedCoin(tci.Ctx, address)
}

// GetLockedCoinDetailsViaCLI is a function to list locked coins via cli
func GetLockedCoinDetailsViaCLI(address sdk.AccAddress) types.LockedCoinDetails {
	return tci.PlnK.GetLockedCoinDetails(tci.Ctx, address)
}

// ListRecipesViaCLI is a function to list recipes via cli
func ListRecipesViaCLI(address sdk.AccAddress) []types.Recipe {
	return tci.PlnK.GetRecipesBySender(tci.Ctx, address)
}

// ListExecutionsViaCLI is a function to list executions via cli
func ListExecutionsViaCLI(address sdk.AccAddress) ([]types.Execution, error) {
	return tci.PlnK.GetExecutionsBySender(tci.Ctx, address)
}

// ListItemsViaCLI is a function to list items via cli
func ListItemsViaCLI(address sdk.AccAddress) ([]types.Item, error) {
	return tci.PlnK.GetItemsBySender(tci.Ctx, address)
}

// IsJSON checks if bytes is in json
func IsJSON(str string) bool {
	var js json.RawMessage
	return json.Unmarshal([]byte(str), &js) == nil
}

// FindTradeFromArrayByExtraInfo is a function to find trade from extra info
func FindTradeFromArrayByExtraInfo(trades []types.Trade, extraInfo string) (types.Trade, bool) {
	for _, trade := range trades {
		if trade.ExtraInfo == extraInfo {
			return trade, true
		}
	}
	return types.Trade{}, false
}

// FindCookbookFromArrayByName is a function to cookbook from array by name
func FindCookbookFromArrayByName(cbList []types.Cookbook, name string) (types.Cookbook, bool) {
	for _, cb := range cbList {
		if cb.Name == name {
			return cb, true
		}
	}
	return types.Cookbook{}, false
}

// FindRecipeFromArrayByName is a function to get recipes from array by name
func FindRecipeFromArrayByName(recipes []types.Recipe, name string) (types.Recipe, bool) {
	for _, rcp := range recipes {
		if rcp.Name == name {
			return rcp, true
		}
	}
	return types.Recipe{}, false
}

// FindExecutionByRecipeID is a function to get execution by recipe id
func FindExecutionByRecipeID(execs []types.Execution, rcpID string) (types.Execution, bool) {
	for _, exec := range execs {
		if exec.RecipeID == rcpID {
			return exec, true
		}
	}
	return types.Execution{}, false
}

// FindItemFromArrayByName is a function to get item array by name
func FindItemFromArrayByName(
	items []types.Item, name string,
	includeLockedByRecipe bool,
	includeLockedByTrade bool,
) (types.Item, bool) {
	for _, item := range items {
		itemName, _ := item.FindString("Name")
		if !includeLockedByRecipe && len(item.OwnerRecipeID) != 0 {
			continue
		}
		if !includeLockedByTrade && len(item.OwnerTradeID) != 0 {
			continue
		}
		if itemName == name {
			return item, true
		}
	}
	return types.Item{}, false
}

// GetCookbookByGUID is to get Cookbook from ID
func GetCookbookByGUID(guid string) (types.Cookbook, error) {
	return tci.PlnK.GetCookbook(tci.Ctx, guid)
}

// GetCookbookIDFromName is a function to get cookbook id from name
func GetCookbookIDFromName(cbName string, account sdk.AccAddress) (string, bool, error) {
	cbList, err := ListCookbookViaCLI(account)
	if err != nil {
		return "", false, err
	}

	cb, exist := FindCookbookFromArrayByName(cbList, cbName)
	return cb.ID, exist, nil
}

// GetRecipeIDFromName is a function to get recipe id from name
func GetRecipeIDFromName(rcpName string) (string, bool) {
	rcpList := ListRecipesViaCLI(sdk.AccAddress{})
	rcp, exist := FindRecipeFromArrayByName(rcpList, rcpName)
	return rcp.ID, exist
}

// GetItemIDFromName is a function to get item id from name
func GetItemIDFromName(sender sdk.AccAddress, itemName string, includeLockedByRecipe bool, includeLockedByTrade bool) (string, bool, error) {
	itemList, err := ListItemsViaCLI(sender)
	if err != nil {
		return "", false, err
	}
	rcp, exist := FindItemFromArrayByName(itemList, itemName, includeLockedByRecipe, includeLockedByTrade)
	return rcp.ID, exist, nil
}

// GetRecipeByGUID is to get Recipe from ID
func GetRecipeByGUID(guid string) (types.Recipe, error) {
	return tci.PlnK.GetRecipe(tci.Ctx, guid)
}

// GetExecutionByGUID is to get Execution from ID
func GetExecutionByGUID(guid string) (types.Execution, error) {
	return tci.PlnK.GetExecution(tci.Ctx, guid)
}

// GetItemByGUID is to get Item from ID
func GetItemByGUID(guid string) (types.Item, error) {
	return tci.PlnK.GetItem(tci.Ctx, guid)
}

// GetRecipeGUIDFromName is a function to get recipe id from name
func GetRecipeGUIDFromName(name string, address sdk.AccAddress) string {
	rcpList := ListRecipesViaCLI(address)
	rcp, _ := FindRecipeFromArrayByName(rcpList, name)
	return rcp.ID
}
