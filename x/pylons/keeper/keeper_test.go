package keeper_test

import (
	"fmt"
	"strconv"
	"testing"

	"github.com/stretchr/testify/suite"

	"github.com/Pylons-tech/pylons/app"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"

	sdk "github.com/cosmos/cosmos-sdk/types"
	tmproto "github.com/tendermint/tendermint/proto/tendermint/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	minttypes "github.com/cosmos/cosmos-sdk/x/mint/types"
)

func generateAddress() sdk.AccAddress {
	addrString := types.GenTestBech32FromString("test")
	addr, _ := sdk.AccAddressFromBech32(addrString)
	return addr
}

func createNCookbook(k keeper.Keeper, ctx sdk.Context, n int) []types.Cookbook {
	items := make([]types.Cookbook, n)
	creators := types.GenTestBech32List(n)
	for i := range items {
		items[i].Creator = creators[i]
		items[i].Id = fmt.Sprintf("%d", i)
		k.SetCookbook(ctx, items[i])
	}
	return items
}

func createNPylonsAccount(k keeper.Keeper, ctx sdk.Context, n int) []types.UserMap {
	items := make([]types.UserMap, n)
	creators := types.GenTestBech32List(n)
	for i := range items {
		items[i].AccountAddr = creators[i]
		items[i].Username = "user" + strconv.Itoa(i)
		k.SetPylonsAccount(ctx, types.AccountAddr{Value: items[i].AccountAddr}, types.Username{Value: items[i].Username})
	}
	return items
}

func createNCookbookForSingleOwner(k keeper.Keeper, ctx sdk.Context, n int) []types.Cookbook {
	items := make([]types.Cookbook, n)
	creator := types.GenTestBech32FromString("any")
	for i := range items {
		items[i].Creator = creator
		items[i].Id = fmt.Sprintf("%d", i)
		k.SetCookbook(ctx, items[i])
	}
	return items
}

func createNExecution(k keeper.Keeper, ctx sdk.Context, n int) []types.Execution {
	execs := make([]types.Execution, n)
	creators := types.GenTestBech32List(n)
	for i := range execs {
		execs[i].Creator = creators[i]
		execs[i].Id = strconv.Itoa(i)
		k.SetExecution(ctx, execs[i])
	}
	return execs
}

func createNExecutionForSingleRecipe(k keeper.Keeper, ctx sdk.Context, n int, cookbookID, recipeID string) []types.Execution {
	execs := make([]types.Execution, n)
	creators := types.GenTestBech32List(n)
	for i := range execs {
		execs[i].Creator = creators[i]
		execs[i].Id = strconv.Itoa(i)
		execs[i].CookbookId = cookbookID
		execs[i].RecipeId = recipeID
		k.SetExecution(ctx, execs[i])
	}
	return execs
}

func createNExecutionForSingleItem(k keeper.Keeper, ctx sdk.Context, n int) []types.Execution {
	exec := types.Execution{
		ItemInputs: []types.ItemRecord{
			{
				Id: "test1",
			},
		},
		ItemOutputIds: []string{"test1"},
		RecipeId:      "testRecipeID",
		CookbookId:    "testCookbookID",
	}

	execs := make([]types.Execution, n)
	creators := types.GenTestBech32List(n)

	for i := range execs {
		execs[i] = exec
		execs[i].Creator = creators[i] // ok if different people ran executions
		execs[i].Id = strconv.Itoa(i)
		k.SetExecution(ctx, execs[i])

	}

	return execs
}

func createNPendingExecutionForSingleItem(k keeper.Keeper, ctx sdk.Context, n int) []types.Execution {
	exec := types.Execution{
		ItemInputs: []types.ItemRecord{
			{
				Id: "test1",
			},
		},
		ItemOutputIds: []string{"test1"},
		RecipeId:      "testRecipeID",
		CookbookId:    "testCookbookID",
	}

	execs := make([]types.Execution, n)
	creators := types.GenTestBech32List(n)

	for i := range execs {
		execs[i] = exec
		execs[i].Creator = creators[i] // ok if different people ran executions
		execs[i].Id = strconv.Itoa(i)
		k.SetPendingExecution(ctx, execs[i])
	}

	return execs
}

// returns (pendingExecs, completedExecs)
func createNMixedExecutionForSingleItem(k keeper.Keeper, ctx sdk.Context, n int) ([]types.Execution, []types.Execution) {
	exec := types.Execution{
		ItemInputs: []types.ItemRecord{
			{
				Id: "test1",
			},
		},
		ItemOutputIds: []string{"test1"},
		RecipeId:      "testRecipeID",
		CookbookId:    "testCookbookID",
	}

	completedExecs := make([]types.Execution, n)
	pendingExecs := make([]types.Execution, n)
	creators := types.GenTestBech32List(n)

	for i := range pendingExecs {
		pendingExecs[i] = exec
		pendingExecs[i].Creator = creators[i] // ok if different people ran executions
		pendingExecs[i].Id = strconv.Itoa(i)
		k.SetPendingExecution(ctx, pendingExecs[i])
	}

	for i := range completedExecs {
		completedExecs[i] = exec
		completedExecs[i].Creator = creators[i] // ok if different people ran executions
		completedExecs[i].Id = strconv.Itoa(i + n)
		k.SetExecution(ctx, completedExecs[i])
	}

	return pendingExecs, completedExecs
}

func createNPendingExecution(k keeper.Keeper, ctx sdk.Context, n int) []types.Execution {
	execs := make([]types.Execution, n)
	creators := types.GenTestBech32List(n)
	for i := range execs {
		execs[i].Creator = creators[i]
		execs[i].Id = k.AppendPendingExecution(ctx, execs[i], 0)
	}
	return execs
}

func createNPendingExecutionForSingleRecipe(k keeper.Keeper, ctx sdk.Context, n int, recipe types.Recipe) []types.Execution {
	execs := make([]types.Execution, n)
	creators := types.GenTestBech32List(n)
	for i := range execs {
		execs[i].Creator = creators[i]
		execs[i].CookbookId = recipe.CookbookId
		execs[i].RecipeId = recipe.Id
		execs[i].RecipeVersion = recipe.Version
		execs[i].Id = k.AppendPendingExecution(ctx, execs[i], recipe.BlockInterval)
	}
	return execs
}

func createNGoogleIAPOrder(k keeper.Keeper, ctx sdk.Context, n int) []types.GoogleInAppPurchaseOrder {
	items := make([]types.GoogleInAppPurchaseOrder, n)
	creators := types.GenTestBech32List(n)
	for i := range items {
		items[i].Creator = creators[i]
		items[i].PurchaseToken = strconv.Itoa(i)
		k.AppendGoogleIAPOrder(ctx, items[i])
	}

	return items
}

func createNAppleIAPOrder(k keeper.Keeper, ctx sdk.Context, n int) []types.AppleInAppPurchaseOrder {
	items := make([]types.AppleInAppPurchaseOrder, n)
	creators := types.GenTestBech32List(n)
	for i := range items {
		items[i].Creator = creators[i]
		items[i].PurchaseId = strconv.Itoa(i)
		k.AppendAppleIAPOrder(ctx, items[i])
	}

	return items
}

func createNPaymentInfo(k keeper.Keeper, ctx sdk.Context, n int) []types.PaymentInfo {
	items := make([]types.PaymentInfo, n)
	creators := types.GenTestBech32List(n)
	for i := range items {
		items[i].PayerAddr = creators[i]
		items[i].PurchaseId = fmt.Sprintf("%d", i)
		items[i].Amount = sdk.OneInt()
		k.SetPaymentInfo(ctx, items[i])
	}
	return items
}

func createNRedeemInfo(k keeper.Keeper, ctx sdk.Context, n int) []types.RedeemInfo {
	items := make([]types.RedeemInfo, n)
	creators := types.GenTestBech32List(n)
	for i := range items {
		items[i].Address = creators[i]
		items[i].Id = fmt.Sprintf("%d", i)
		items[i].Amount = sdk.OneInt()
		k.SetRedeemInfo(ctx, items[i])
	}
	return items
}

func createNItem(k keeper.Keeper, ctx sdk.Context, n int, tradeable bool) []types.Item {
	items := make([]types.Item, n)
	owners := types.GenTestBech32List(n)
	coin := []sdk.Coin{sdk.NewCoin(types.PylonsCoinDenom, sdk.OneInt())}
	for i := range items {
		items[i].Owner = owners[i]
		items[i].CookbookId = fmt.Sprintf("%d", i)
		items[i].TransferFee = coin
		items[i].Tradeable = tradeable
		items[i].TradePercentage = sdk.ZeroDec()
		items[i].Id = k.AppendItem(ctx, items[i])
	}
	return items
}

func createNItemSameOwnerAndCookbook(k keeper.Keeper, ctx sdk.Context, n int, cookbookID string, tradeable bool) []types.Item {
	items := make([]types.Item, n)
	owner := types.GenTestBech32FromString("test")
	coin := []sdk.Coin{sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(100))}
	for i := range items {
		items[i].Owner = owner
		items[i].CookbookId = cookbookID
		items[i].TransferFee = coin
		items[i].Tradeable = tradeable
		items[i].Id = k.AppendItem(ctx, items[i])
	}
	return items
}

func createNItemSingleOwner(k keeper.Keeper, ctx sdk.Context, n int, tradeable bool) []types.Item {
	items := make([]types.Item, n)
	owner := types.GenTestBech32List(1)
	coin := []sdk.Coin{sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(100))}
	for i := range items {
		items[i].Owner = owner[0]
		items[i].CookbookId = fmt.Sprintf("%d", i)
		items[i].TransferFee = coin
		items[i].Tradeable = tradeable
		items[i].TradePercentage = sdk.ZeroDec()
		items[i].Id = k.AppendItem(ctx, items[i])
	}
	return items
}

func createNRecipe(k keeper.Keeper, ctx sdk.Context, cb types.Cookbook, n int) []types.Recipe {
	items := make([]types.Recipe, n)
	for i := range items {
		items[i].CookbookId = cb.Id
		items[i].Id = fmt.Sprintf("%d", i)
		items[i].CostPerBlock = sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(100))

		k.SetRecipe(ctx, items[i])
	}
	return items
}

func createNTrade(k keeper.Keeper, ctx sdk.Context, n int) []types.Trade {
	items := make([]types.Trade, n)
	owners := types.GenTestBech32List(n)

	coinInputs := make([]types.CoinInput, 0)
	coinInputs = append(coinInputs, types.CoinInput{Coins: sdk.Coins{sdk.Coin{Denom: "test", Amount: sdk.NewInt(0)}}})

	for i := range items {
		items[i].Creator = owners[i]
		items[i].CoinInputs = coinInputs
		items[i].CoinOutputs = sdk.Coins{sdk.Coin{Denom: "test", Amount: sdk.NewInt(0)}}
		items[i].Id = k.AppendTrade(ctx, items[i])
	}
	return items
}

func createNTradeSameOwner(k keeper.Keeper, ctx sdk.Context, n int) []types.Trade {
	items := make([]types.Trade, n)
	owners := types.GenTestBech32List(1)

	coinInputs := make([]types.CoinInput, 0)
	coinInputs = append(coinInputs, types.CoinInput{Coins: sdk.Coins{sdk.Coin{Denom: "test", Amount: sdk.NewInt(0)}}})

	for i := range items {
		items[i].Creator = owners[0]
		items[i].CoinInputs = coinInputs
		items[i].CoinOutputs = sdk.Coins{sdk.Coin{Denom: "test", Amount: sdk.NewInt(0)}}
		items[i].Id = k.AppendTrade(ctx, items[i])
	}
	return items
}

type IntegrationTestSuite struct {
	suite.Suite

	pylonsApp     *app.PylonsApp
	ctx           sdk.Context
	k             keeper.Keeper
	bankKeeper    types.BankKeeper
	accountKeeper types.AccountKeeper
	stakingKeeper types.StakingKeeper
}

// TODO: Fisal, Khanh, or Vuong, please fix this test.  Needs simapp.
func (suite *IntegrationTestSuite) SetupTest() {
	pylonsApp := app.Setup(false)

	ctx := pylonsApp.BaseApp.NewContext(false, tmproto.Header{})

	suite.pylonsApp = pylonsApp
	suite.ctx = ctx
	suite.k = pylonsApp.PylonsKeeper
	suite.bankKeeper = pylonsApp.BankKeeper
	suite.accountKeeper = pylonsApp.AccountKeeper
	suite.stakingKeeper = pylonsApp.StakingKeeper
}

func (suite *IntegrationTestSuite) FundAccount( ctx sdk.Context, addr sdk.AccAddress, amounts sdk.Coins) error {
	if err := suite.bankKeeper.MintCoins(ctx, minttypes.ModuleName, amounts); err != nil {
		return err
	}

	return suite.bankKeeper.SendCoinsFromModuleToAccount(ctx, minttypes.ModuleName, addr, amounts)
}

func TestKeeperTestSuite(t *testing.T) {
	suite.Run(t, new(IntegrationTestSuite))
}

func (suite *IntegrationTestSuite) TestKeeperFuncs() {
	k := suite.k
	ctx := suite.ctx

	log := k.Logger(ctx)

	addr := k.FeeCollectorAddress()
	log.Info(addr.String())

	addr = k.TradesLockerAddress()
	log.Info(addr.String())

	addr = k.ExecutionsLockerAddress()
	log.Info(addr.String())

	addr = k.CoinsIssuerAddress()
	log.Info(addr.String())
}
