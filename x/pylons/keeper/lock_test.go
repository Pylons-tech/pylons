package keeper_test

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	bankTypes "github.com/cosmos/cosmos-sdk/x/bank/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)


func (suite *IntegrationTestSuite) TestPayFees() {
	k := suite.k
	bk := suite.bankKeeper
	ctx := suite.ctx
	require := suite.Require()

	//Create an initial supply
	coin := sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(100))
	mintAmt := sdk.Coins{}
	mintAmt = mintAmt.Add(coin)
	// set arbitrary initial supply to 100 pylons
	supply := bankTypes.NewSupply(mintAmt)
	bk.SetSupply(ctx, supply)

	//Create a test address
	addrString := types.GenTestBech32FromString("test")
	addr, _ := sdk.AccAddressFromBech32(addrString)

	//Transfer coins to our test address
	err := k.MintCoinsToAddr(ctx, addr, mintAmt)
	require.NoError(err)

	// Pay Fees
	fee := sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(100))
	feeCoins := sdk.Coins{}
	feeCoins = feeCoins.Add(fee)
	err = k.PayFees(ctx, addr, feeCoins)
	require.NoError(err)

	//Check if the balance in the FeeCollectorName module account has changed
	balance := bk.SpendableCoins(ctx, k.FeeCollectorAddress())
	require.True(balance.IsEqual(feeCoins))
}

func (suite *IntegrationTestSuite) TestLockCoinsForExecution() {
	//k, ctx := setupKeeper(t)
	k := suite.k
	bk := suite.bankKeeper
	ctx := suite.ctx
	require := suite.Require()

	//Create an initial supply
	coin := sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(100))
	mintAmt := sdk.Coins{}
	mintAmt = mintAmt.Add(coin)
	// set arbitrary initial supply to 100 pylons
	supply := bankTypes.NewSupply(mintAmt)
	bk.SetSupply(ctx, supply)

	//Create a test address
	addrString := types.GenTestBech32FromString("test")
	addr, _ := sdk.AccAddressFromBech32(addrString)

	//Transfer coins to our test address
	err := k.MintCoinsToAddr(ctx, addr, mintAmt)
	require.NoError(err)

	// Lock coins for execution
	lc := sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(10))
	lockedCoins := sdk.Coins{}
	lockedCoins = lockedCoins.Add(lc)
	err = k.LockCoinsForExecution(ctx, addr, lockedCoins)
	require.NoError(err)

	//Check if the balance in the ExecutionsLockerAddress module account has changed
	balance := bk.SpendableCoins(ctx, k.ExecutionsLockerAddress())
	require.True(balance.IsEqual(lockedCoins))
}

func (suite *IntegrationTestSuite) TestLockCoinsForTrade() {

	//k, ctx := setupKeeper(t)
	k := suite.k
	bk := suite.bankKeeper
	ctx := suite.ctx
	require := suite.Require()

	//Create an initial supply
	coin := sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(100))
	mintAmt := sdk.Coins{}
	mintAmt = mintAmt.Add(coin)
	// set arbitrary initial supply to 100 pylons
	supply := bankTypes.NewSupply(mintAmt)
	bk.SetSupply(ctx, supply)

	//Create a test address
	addrString := types.GenTestBech32FromString("test")
	addr, _ := sdk.AccAddressFromBech32(addrString)

	//Transfer coins to our test address
	err := k.MintCoinsToAddr(ctx, addr, mintAmt)
	require.NoError(err)

	// Lock coins for trade
	lc := sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(10))
	lockedCoins := sdk.Coins{}
	lockedCoins = lockedCoins.Add(lc)
	err = k.LockCoinsForTrade(ctx, addr, lockedCoins)
	require.NoError(err)

	//Check if the balance in the LockCoinsForTrade module account has changed
	balance := bk.SpendableCoins(ctx, k.TradesLockerAddress())
	require.True(balance.IsEqual(lockedCoins))
}

func (suite *IntegrationTestSuite) TestUnlockCoinsForTrade() {

	k := suite.k
	bk := suite.bankKeeper
	ctx := suite.ctx
	require := suite.Require()

	//Create an initial supply
	initialSupply := sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(100))
	coinsOfInitialSupply := sdk.Coins{}
	coinsOfInitialSupply = coinsOfInitialSupply.Add(initialSupply)
	// set arbitrary initial supply to 100 pylons
	supply := bankTypes.NewSupply(coinsOfInitialSupply)
	bk.SetSupply(ctx, supply)

	//Create a test address
	addrString := types.GenTestBech32FromString("test")
	testAddr, _ := sdk.AccAddressFromBech32(addrString)

	//Transfer coins to our test address
	err := k.MintCoinsToAddr(ctx, testAddr, coinsOfInitialSupply)
	require.NoError(err)

	//Save the initial balance to use as validation test later
	initialAddrBalance := bk.SpendableCoins(ctx, testAddr).AmountOf(types.PylonsCoinDenom)

	// Lock coins for trade
	lc := sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(10))
	lockedCoins := sdk.Coins{}
	lockedCoins = lockedCoins.Add(lc)
	err = k.LockCoinsForTrade(ctx, testAddr, lockedCoins)
	require.NoError(err)

	//Verify that the balance of the test address has been debited
	balance := bk.SpendableCoins(ctx, testAddr)
	newBalance := sdk.NewInt(90)
	testAddrBalance := balance.AmountOf(types.PylonsCoinDenom)
	require.True(newBalance.Equal(testAddrBalance))

	//Unlock the coins
	err = k.UnLockCoinsForTrade(ctx, testAddr, lockedCoins)
	require.NoError(err)

	//Assert that the unlocked balance is equal to the previous balance.
	unlockedBalance := bk.SpendableCoins(ctx, testAddr)
	testAddrUnlockedBalance := unlockedBalance.AmountOf(types.PylonsCoinDenom)
	require.True(initialAddrBalance.Equal(testAddrUnlockedBalance))

}

func (suite *IntegrationTestSuite) TestUnlockCoinsForExecution() {

	k := suite.k
	bk := suite.bankKeeper
	ctx := suite.ctx
	require := suite.Require()

	//Create an initial supply
	initialSupply := sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(100))
	coinsOfInitialSupply := sdk.Coins{}
	coinsOfInitialSupply = coinsOfInitialSupply.Add(initialSupply)
	// set arbitrary initial supply to 100 pylons
	supply := bankTypes.NewSupply(coinsOfInitialSupply)
	bk.SetSupply(ctx, supply)

	//Create a test address
	addrString := types.GenTestBech32FromString("test")
	testAddr, _ := sdk.AccAddressFromBech32(addrString)

	//Transfer coins to our test address
	err := k.MintCoinsToAddr(ctx, testAddr, coinsOfInitialSupply)
	require.NoError(err)

	//Save the initial balance to use as validation test later
	initialAddrBalance := bk.SpendableCoins(ctx, testAddr).AmountOf(types.PylonsCoinDenom)

	// Lock coins for execution
	lc := sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(10))
	lockedCoins := sdk.Coins{}
	lockedCoins = lockedCoins.Add(lc)
	err = k.LockCoinsForExecution(ctx, testAddr, lockedCoins)
	require.NoError(err)

	//Verify that the balance of the test address has been debited
	balance := bk.SpendableCoins(ctx, testAddr)
	newBalance := sdk.NewInt(90)
	testAddrBalance := balance.AmountOf(types.PylonsCoinDenom)
	require.True(newBalance.Equal(testAddrBalance))

	//Unlock the coins
	err = k.UnLockCoinsForExecution(ctx, testAddr, lockedCoins)
	require.NoError(err)

	//Assert that the unlocked balance is equal to the previous balance.
	unlockedBalance := bk.SpendableCoins(ctx, testAddr)
	testAddrUnlockedBalance := unlockedBalance.AmountOf(types.PylonsCoinDenom)
	require.True(initialAddrBalance.Equal(testAddrUnlockedBalance))

}

func (suite *IntegrationTestSuite) TestLockItemForExecution() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	orig := createNItem(k, ctx, 1)
	k.LockItemForExecution(ctx, orig[0])
	item, _ := k.GetItem(ctx, orig[0].CookbookID, orig[0].ID)
	require.Equal(item.Owner, k.ExecutionsLockerAddress().String())
}

func (suite *IntegrationTestSuite) TestLockItemForTrade() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	orig := createNItem(k, ctx, 1)
	k.LockItemForTrade(ctx, orig[0])
	item, _ := k.GetItem(ctx, orig[0].CookbookID, orig[0].ID)
	require.Equal(item.Owner, k.TradesLockerAddress().String())
}
