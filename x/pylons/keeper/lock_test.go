package keeper_test

import (
	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

func (suite *IntegrationTestSuite) TestPayFees() {
	k := suite.k
	bk := suite.bankKeeper
	ctx := suite.ctx
	require := suite.Require()

	// Create an initial supply
	coin := sdk.NewCoin(v1beta1.PylonsCoinDenom, sdk.NewInt(100))
	mintAmt := sdk.NewCoins()
	mintAmt = mintAmt.Add(coin)

	// Create a test address
	addrString := v1beta1.GenTestBech32FromString("test")
	addr, _ := sdk.AccAddressFromBech32(addrString)

	// Transfer coins to our test address
	err := k.MintCoinsToAddr(ctx, addr, mintAmt)
	require.NoError(err)

	// Pay Fees
	fee := sdk.NewCoin(v1beta1.PylonsCoinDenom, sdk.NewInt(100))
	feeCoins := sdk.NewCoins()
	feeCoins = feeCoins.Add(fee)
	err = k.PayFees(ctx, addr, feeCoins)
	require.NoError(err)

	// Check if the balance in the FeeCollectorName module account has changed
	balance := bk.SpendableCoins(ctx, k.FeeCollectorAddress())
	require.True(balance.IsEqual(feeCoins))
}

func (suite *IntegrationTestSuite) TestLockCoinsForExecution() {
	k := suite.k
	bk := suite.bankKeeper
	ctx := suite.ctx
	require := suite.Require()

	// Create an initial supply
	coin := sdk.NewCoin(v1beta1.PylonsCoinDenom, sdk.NewInt(100))
	mintAmt := sdk.NewCoins()
	mintAmt = mintAmt.Add(coin)

	// Create a test address
	addrString := v1beta1.GenTestBech32FromString("test")
	addr, _ := sdk.AccAddressFromBech32(addrString)

	// Transfer coins to our test address
	err := k.MintCoinsToAddr(ctx, addr, mintAmt)
	require.NoError(err)

	// Lock coins for execution
	lc := sdk.NewCoin(v1beta1.PylonsCoinDenom, sdk.NewInt(10))
	lockedCoins := sdk.NewCoins()
	lockedCoins = lockedCoins.Add(lc)
	err = k.LockCoinsForExecution(ctx, addr, lockedCoins)
	require.NoError(err)

	// Check if the balance in the ExecutionsLockerAddress module account has changed
	balance := bk.SpendableCoins(ctx, k.ExecutionsLockerAddress())
	require.True(balance.IsEqual(lockedCoins))
}

func (suite *IntegrationTestSuite) TestLockCoinsForTrade() {
	k := suite.k
	bk := suite.bankKeeper
	ctx := suite.ctx
	require := suite.Require()

	// Create an initial supply
	coin := sdk.NewCoin(v1beta1.PylonsCoinDenom, sdk.NewInt(100))
	mintAmt := sdk.NewCoins()
	mintAmt = mintAmt.Add(coin)

	// Create a test address
	addrString := v1beta1.GenTestBech32FromString("test")
	addr, _ := sdk.AccAddressFromBech32(addrString)

	// Transfer coins to our test address
	err := k.MintCoinsToAddr(ctx, addr, mintAmt)
	require.NoError(err)

	// Lock coins for trade
	lc := sdk.NewCoin(v1beta1.PylonsCoinDenom, sdk.NewInt(10))
	lockedCoins := sdk.NewCoins()
	lockedCoins = lockedCoins.Add(lc)
	err = k.LockCoinsForTrade(ctx, addr, lockedCoins)
	require.NoError(err)

	// Check if the balance in the LockCoinsForTrade module account has changed
	balance := bk.SpendableCoins(ctx, k.TradesLockerAddress())
	require.True(balance.IsEqual(lockedCoins))
}

func (suite *IntegrationTestSuite) TestUnlockCoinsForTrade() {
	k := suite.k
	bk := suite.bankKeeper
	ctx := suite.ctx
	require := suite.Require()

	// Create an initial supply
	initialSupply := sdk.NewCoin(v1beta1.PylonsCoinDenom, sdk.NewInt(100))
	coinsOfInitialSupply := sdk.NewCoins()
	coinsOfInitialSupply = coinsOfInitialSupply.Add(initialSupply)

	// Create a test address
	addrString := v1beta1.GenTestBech32FromString("test")
	testAddr, _ := sdk.AccAddressFromBech32(addrString)

	// Transfer coins to our test address
	err := k.MintCoinsToAddr(ctx, testAddr, coinsOfInitialSupply)
	require.NoError(err)

	// Save the initial balance to use as validation test later
	initialAddrBalance := bk.SpendableCoins(ctx, testAddr).AmountOf(v1beta1.PylonsCoinDenom)

	// Lock coins for trade
	lc := sdk.NewCoin(v1beta1.PylonsCoinDenom, sdk.NewInt(10))
	lockedCoins := sdk.NewCoins()
	lockedCoins = lockedCoins.Add(lc)
	err = k.LockCoinsForTrade(ctx, testAddr, lockedCoins)
	require.NoError(err)

	// Verify that the balance of the test address has been debited
	balance := bk.SpendableCoins(ctx, testAddr)
	newBalance := sdk.NewInt(90)
	testAddrBalance := balance.AmountOf(v1beta1.PylonsCoinDenom)
	require.True(newBalance.Equal(testAddrBalance))

	// Unlock the coins
	err = k.UnLockCoinsForTrade(ctx, testAddr, lockedCoins)
	require.NoError(err)

	// Assert that the unlocked balance is equal to the previous balance.
	unlockedBalance := bk.SpendableCoins(ctx, testAddr)
	testAddrUnlockedBalance := unlockedBalance.AmountOf(v1beta1.PylonsCoinDenom)
	require.True(initialAddrBalance.Equal(testAddrUnlockedBalance))
}

func (suite *IntegrationTestSuite) TestUnlockCoinsForExecution() {
	k := suite.k
	bk := suite.bankKeeper
	ctx := suite.ctx
	require := suite.Require()

	// Create an initial supply
	initialSupply := sdk.NewCoin(v1beta1.PylonsCoinDenom, sdk.NewInt(100))
	coinsOfInitialSupply := sdk.NewCoins()
	coinsOfInitialSupply = coinsOfInitialSupply.Add(initialSupply)

	// Create a test address
	addrString := v1beta1.GenTestBech32FromString("test")
	testAddr, _ := sdk.AccAddressFromBech32(addrString)

	// Transfer coins to our test address
	err := k.MintCoinsToAddr(ctx, testAddr, coinsOfInitialSupply)
	require.NoError(err)

	// Save the initial balance to use as validation test later
	initialAddrBalance := bk.SpendableCoins(ctx, testAddr).AmountOf(v1beta1.PylonsCoinDenom)

	// Lock coins for execution
	lc := sdk.NewCoin(v1beta1.PylonsCoinDenom, sdk.NewInt(10))
	lockedCoins := sdk.NewCoins()
	lockedCoins = lockedCoins.Add(lc)
	err = k.LockCoinsForExecution(ctx, testAddr, lockedCoins)
	require.NoError(err)

	// Verify that the balance of the test address has been debited
	balance := bk.SpendableCoins(ctx, testAddr)
	newBalance := sdk.NewInt(90)
	testAddrBalance := balance.AmountOf(v1beta1.PylonsCoinDenom)
	require.True(newBalance.Equal(testAddrBalance))

	// Unlock the coins
	err = k.UnLockCoinsForExecution(ctx, testAddr, lockedCoins)
	require.NoError(err)

	// Assert that the unlocked balance is equal to the previous balance.
	unlockedBalance := bk.SpendableCoins(ctx, testAddr)
	testAddrUnlockedBalance := unlockedBalance.AmountOf(v1beta1.PylonsCoinDenom)
	require.True(initialAddrBalance.Equal(testAddrUnlockedBalance))
}

func (suite *IntegrationTestSuite) TestLockItemForExecution() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	orig := createNItem(k, ctx, 1, true)
	k.LockItemForExecution(ctx, orig[0])
	item, _ := k.GetItem(ctx, orig[0].CookbookId, orig[0].Id)
	require.Equal(item.Owner, k.ExecutionsLockerAddress().String())
}

func (suite *IntegrationTestSuite) TestUnlockItemForExecution() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	orig := createNItem(k, ctx, 1, true)
	origOwner := orig[0].Owner
	k.LockItemForExecution(ctx, orig[0])
	item, _ := k.GetItem(ctx, orig[0].CookbookId, orig[0].Id)
	require.Equal(item.Owner, k.ExecutionsLockerAddress().String())
	k.UnlockItemForExecution(ctx, item, origOwner)
	item, _ = k.GetItem(ctx, orig[0].CookbookId, orig[0].Id)
	require.Equal(item.Owner, origOwner)
}

func (suite *IntegrationTestSuite) TestLockItemForTrade() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	orig := createNItem(k, ctx, 1, true)
	k.LockItemForTrade(ctx, orig[0])
	item, _ := k.GetItem(ctx, orig[0].CookbookId, orig[0].Id)
	require.Equal(item.Owner, k.TradesLockerAddress().String())
}

func (suite *IntegrationTestSuite) TestUnlockItemForTrade() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	orig := createNItem(k, ctx, 1, true)
	origOwner := orig[0].Owner
	k.LockItemForTrade(ctx, orig[0])
	item, _ := k.GetItem(ctx, orig[0].CookbookId, orig[0].Id)
	require.Equal(item.Owner, k.TradesLockerAddress().String())
	k.UnlockItemForTrade(ctx, item, origOwner)
	item, _ = k.GetItem(ctx, orig[0].CookbookId, orig[0].Id)
	require.Equal(item.Owner, origOwner)
}
