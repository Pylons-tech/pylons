package keeper_test

import (
	"fmt"
	"strconv"
	"testing"

	"github.com/Pylons-tech/pylons/app"

	"github.com/stretchr/testify/suite"

	pylonsSimapp "github.com/Pylons-tech/pylons/testutil/simapp"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"

	sdk "github.com/cosmos/cosmos-sdk/types"
	tmproto "github.com/tendermint/tendermint/proto/tendermint/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func createNCookbook(k keeper.Keeper, ctx sdk.Context, n int) []types.Cookbook {
	items := make([]types.Cookbook, n)
	creators := types.GenTestBech32List(n)
	for i := range items {
		items[i].Creator = creators[i]
		items[i].ID = fmt.Sprintf("%d", i)
		items[i].CostPerBlock = sdk.NewCoin("test", sdk.NewInt(1))
		k.SetCookbook(ctx, items[i])
	}
	return items
}

func createNCookbookSameCreator(k keeper.Keeper, ctx sdk.Context, n int) []types.Cookbook {
	items := make([]types.Cookbook, n)
	creator := types.GenTestBech32FromString("any")
	for i := range items {
		items[i].Creator = creator
		items[i].ID = fmt.Sprintf("%d", i)
		items[i].CostPerBlock = sdk.NewCoin("test", sdk.NewInt(1))
		k.SetCookbook(ctx, items[i])
	}
	return items
}

func createNExecution(k keeper.Keeper, ctx sdk.Context, n int) []types.Execution {
	execs := make([]types.Execution, n)
	creators := types.GenTestBech32List(n)
	for i := range execs {
		execs[i].Creator = creators[i]
		execs[i].ID = strconv.Itoa(i)
		//k.appendExecution(ctx, execs[i])
		k.SetExecution(ctx, execs[i])
	}
	return execs
}

func createNExecutionForSingleRecipe(k keeper.Keeper, ctx sdk.Context, n int, cookbookID, recipeID string) []types.Execution {
	execs := make([]types.Execution, n)
	creators := types.GenTestBech32List(n)
	for i := range execs {
		execs[i].Creator = creators[i]
		execs[i].ID = strconv.Itoa(i)
		execs[i].CookbookID = cookbookID
		execs[i].RecipeID = recipeID
		//k.appendExecution(ctx, execs[i])
		k.SetExecution(ctx, execs[i])
	}
	return execs
}

func createNExecutionForSingleItem(k keeper.Keeper, ctx sdk.Context, n int) []types.Execution {
	exec := types.Execution{
		ItemInputs: []types.ItemRecord{
			{
				ID: "test1",
			},
		},
		ItemOutputIDs: []string{"test1"},
		RecipeID:      "testRecipeID",
		CookbookID:    "testCookbookID",
	}

	execs := make([]types.Execution, n)
	creators := types.GenTestBech32List(n)

	for i := range execs {
		execs[i] = exec
		execs[i].Creator = creators[i] // ok if different people ran executions
		execs[i].ID = strconv.Itoa(i)
		//k.appendExecution(ctx, execs[i])
		k.SetExecution(ctx, execs[i])

	}

	return execs
}

func createNPendingExecution(k keeper.Keeper, ctx sdk.Context, n int) []types.Execution {
	execs := make([]types.Execution, n)
	creators := types.GenTestBech32List(n)
	for i := range execs {
		execs[i].Creator = creators[i]
		execs[i].ID = k.AppendPendingExecution(ctx, execs[i], 0)
	}
	return execs
}

func createNPendingExecutionForSingleRecipe(k keeper.Keeper, ctx sdk.Context, n int, recipe types.Recipe) []types.Execution {
	execs := make([]types.Execution, n)
	creators := types.GenTestBech32List(n)
	for i := range execs {
		execs[i].Creator = creators[i]
		execs[i].CookbookID = recipe.CookbookID
		execs[i].RecipeID = recipe.ID
		execs[i].ID = k.AppendPendingExecution(ctx, execs[i], recipe.BlockInterval)
	}
	return execs
}

func createNGoogleIAPOrder(k *keeper.Keeper, ctx sdk.Context, n int) []types.GoogleInAppPurchaseOrder {
	items := make([]types.GoogleInAppPurchaseOrder, n)
	creators := types.GenTestBech32List(n)
	for i := range items {
		items[i].Creator = creators[i]
		items[i].PurchaseToken = strconv.Itoa(int(i))
		k.AppendGoogleIAPOrder(ctx, items[i])
	}
	return items
}

func createNItem(k *keeper.Keeper, ctx sdk.Context, n int) []types.Item {
	items := make([]types.Item, n)
	owners := types.GenTestBech32List(n)
	coin := sdk.NewCoin("test", sdk.NewInt(1))
	for i := range items {
		items[i].Owner = owners[i]
		items[i].CookbookID = fmt.Sprintf("%d", i)
		items[i].ID = types.EncodeItemID(uint64(i))
		items[i].TransferFee = coin
		k.SetItem(ctx, items[i])
	}
	return items
}

func createNRecipe(k *keeper.Keeper, ctx sdk.Context, cb types.Cookbook, n int) []types.Recipe {
	items := make([]types.Recipe, n)
	for i := range items {
		items[i].CookbookID = cb.ID
		items[i].ID = fmt.Sprintf("%d", i)
		k.SetRecipe(ctx, items[i])
	}
	return items
}

type IntegrationTestSuite struct {
	suite.Suite

	app           *app.App
	ctx           sdk.Context
	k             keeper.Keeper
	bankKeeper    types.BankKeeper
	accountKeeper types.AccountKeeper
}

func (suite *IntegrationTestSuite) SetupTest() {
	cmdApp := pylonsSimapp.New("./")

	// cast to pylons app
	var a *app.App
	switch cmdApp.(type) {
	case *app.App:
		a = cmdApp.(*app.App)
	default:
		panic("imported simApp incorrectly")
	}

	ctx := a.BaseApp.NewContext(false, tmproto.Header{})
	a.PylonsKeeper.SetParams(ctx, types.DefaultParams())

	suite.app = a
	suite.ctx = ctx
	suite.k = a.PylonsKeeper
	suite.bankKeeper = a.BankKeeper
	suite.accountKeeper = a.AccountKeeper
}

func TestKeeperTestSuite(t *testing.T) {
	suite.Run(t, new(IntegrationTestSuite))
}
