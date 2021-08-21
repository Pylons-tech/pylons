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

const (
	// original address: "cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337"
	validBech32AccAddr = "cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337" // nolint: deadcode
	baseAccAddrBech32  = "cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt33"
)

// CreateTestFakeAddressList creates a list of addresses from baseAccAddrBech32.
// Note, they are not valid Bech32 addresses (except the 7th element), so Bech32 decoding on these will fail
func CreateTestFakeAddressList(numAccount uint) []string {
	accounts := make([]string, numAccount)
	for i := uint(0); i < numAccount; i++ {
		addr := baseAccAddrBech32 + strconv.Itoa(int(i))
		accounts[i] = addr
	}

	return accounts
}

func createNCookbook(k keeper.Keeper, ctx sdk.Context, n int) []types.Cookbook {
	items := make([]types.Cookbook, n)
	creators := CreateTestFakeAddressList(uint(n))
	for i := range items {
		items[i].Creator = creators[i]
		items[i].ID = fmt.Sprintf("%d", i)
		items[i].CostPerBlock = sdk.NewCoin("test", sdk.NewInt(1))
		k.SetCookbook(ctx, items[i])
	}
	return items
}

func createNExecution(k keeper.Keeper, ctx sdk.Context, n int) []types.Execution {
	execs := make([]types.Execution, n)
	for i := range execs {
		execs[i].Creator = "any"
		execs[i].ID = strconv.Itoa(i)
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
		Recipe:        types.Recipe{CookbookID: "testCookbookID", ID: "testRecipeID"},
	}

	execs := make([]types.Execution, n)

	for i := range execs {
		execs[i] = exec
		execs[i].Creator = fmt.Sprintf("any%v", i) // ok if different people ran executions
		execs[i].ID = strconv.Itoa(i)
		//k.appendExecution(ctx, execs[i])
		k.SetExecution(ctx, execs[i])

	}

	return execs
}

func createNGoogleIAPOrder(k *keeper.Keeper, ctx sdk.Context, n int) []types.GoogleInAppPurchaseOrder {
	items := make([]types.GoogleInAppPurchaseOrder, n)
	for i := range items {
		items[i].Creator = "any"
		items[i].PurchaseToken = strconv.Itoa(int(i))
		k.AppendGoogleIAPOrder(ctx, items[i])
	}
	return items
}

func createNItem(k *keeper.Keeper, ctx sdk.Context, n int) []types.Item {
	items := make([]types.Item, n)
	coin := sdk.NewCoin("test", sdk.NewInt(1))
	for i := range items {
		items[i].Owner = "any"
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

	app *app.App
	ctx sdk.Context
	k   keeper.Keeper
}

func (suite *IntegrationTestSuite) SetupTest() {
	cmdApp := pylonsSimapp.New("./")

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
}

func TestKeeperTestSuite(t *testing.T) {
	suite.Run(t, new(IntegrationTestSuite))
}
