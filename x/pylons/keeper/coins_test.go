package keeper_test

import (
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (suite *IntegrationTestSuite) TestMintCoins() {
	k := suite.k
	bk := suite.bankKeeper
	ctx := suite.ctx
	require := suite.Require()

	coin := sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(100))
	mintAmt := sdk.NewCoins()
	mintAmt = mintAmt.Add(coin)

	// CoinsIssuer module account has minter permissions
	err := k.MintCoins(ctx, types.CoinsIssuerName, mintAmt)
	require.NoError(err)

	addr := k.CoinsIssuerAddress()
	balance := bk.SpendableCoins(ctx, addr)
	require.True(balance.IsEqual(mintAmt))
}

func (suite *IntegrationTestSuite) TestMintCoinsToAddr() {
	k := suite.k
	bk := suite.bankKeeper
	ctx := suite.ctx
	require := suite.Require()

	addrString := types.GenTestBech32FromString("test")
	addr, _ := sdk.AccAddressFromBech32(addrString)

	coin := sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(100))
	mintAmt := sdk.NewCoins()
	mintAmt = mintAmt.Add(coin)

	err := k.MintCoinsToAddr(ctx, addr, mintAmt)

	require.NoError(err)

	balance := bk.SpendableCoins(ctx, addr)
	require.True(balance.IsEqual(mintAmt))
}

func (suite *IntegrationTestSuite) TestBurnCoins() {
	k := suite.k
	bk := suite.bankKeeper
	ctx := suite.ctx
	require := suite.Require()

	coin := sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(100))
	mintAmt := sdk.NewCoins()
	mintAmt = mintAmt.Add(coin)

	// Mint coins to PaymentProcessor module
	err := k.MintCoins(ctx, types.PaymentsProcessorName, mintAmt)
	require.NoError(err)

	// PaymentsProcessor account has burner permissions
	err = k.BurnCoins(ctx, types.PaymentsProcessorName, mintAmt)
	require.NoError(err)

	addr := k.CoinsIssuerAddress()
	balance := bk.SpendableCoins(ctx, addr)
	require.True(balance.IsEqual(sdk.Coins{}))
}

func (suite *IntegrationTestSuite) TestBurnCoinsFromAddress() {
	k := suite.k
	bk := suite.bankKeeper
	ctx := suite.ctx
	require := suite.Require()

	addrString := types.GenTestBech32FromString("test")
	addr, _ := sdk.AccAddressFromBech32(addrString)

	coin := sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(100))
	mintAmt := sdk.NewCoins()
	mintAmt = mintAmt.Add(coin)

	err := suite.FundAccount(ctx, addr, mintAmt)
	require.NoError(err)

	err = k.BurnCreditFromAddr(ctx, addr, mintAmt)

	balance := bk.SpendableCoins(ctx, addr)
	require.True(balance.IsEqual(sdk.Coins{}))
}

func (suite *IntegrationTestSuite) TestMintCreditToAddr() {
	k := suite.k
	bk := suite.bankKeeper
	ak := suite.accountKeeper
	ctx := suite.ctx
	require := suite.Require()

	addrString := types.GenTestBech32FromString("test")
	addr, _ := sdk.AccAddressFromBech32(addrString)

	amt := sdk.NewDec(100)
	// account for network fees
	burnAmt := amt.Mul(types.DefaultProcessorPercentage)
	feesAmt := amt.Mul(types.DefaultValidatorsPercentage)

	mintCoins := sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, amt))
	burnCoins := sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, burnAmt))
	feesCoins := sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, feesAmt))

	// Mint credits to account
	err := k.MintCreditToAddr(ctx, addr, mintCoins, burnCoins, feesCoins)
	require.NoError(err)

	// Check account, module balances
	processorAddr := ak.GetModuleAddress(types.PaymentsProcessorName)
	feeCollectorAddr := ak.GetModuleAddress(types.FeeCollectorName)

	processorBalances := bk.SpendableCoins(ctx, processorAddr)
	feeCollectorBalances := bk.SpendableCoins(ctx, feeCollectorAddr)
	userBalance := bk.SpendableCoins(ctx, addr)

	require.True(userBalance.IsEqual(mintCoins.Sub(burnCoins[0]).Sub(feesCoins)))
	require.True(processorBalances.IsEqual(sdk.Coins{}))
	require.True(feeCollectorBalances.IsEqual(feesCoins))
}

func (suite *IntegrationTestSuite) TestSendRewardsFromFeeCollector() {
	k := suite.k
	bk := suite.bankKeeper
	ak := suite.accountKeeper
	ctx := suite.ctx
	require := suite.Require()

	addrString := types.GenTestBech32FromString("test")
	collector := types.GenTestBech32FromString("collector")
	addr, _ := sdk.AccAddressFromBech32(addrString)
	collectorAddr, _ := sdk.AccAddressFromBech32(collector)
	feeCollectorAddr := ak.GetModuleAddress(types.FeeCollectorName)

	// First mint credits
	amt := sdk.NewInt(100)
	burnAmt := amt.Mul(types.DefaultProcessorPercentage)
	feesAmt := amt.Mul(types.DefaultValidatorsPercentage)

	mintCoins := sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, amt))
	burnCoins := sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, burnAmt))
	feesCoins := sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, feesAmt))

	err := k.MintCreditToAddr(ctx, addr, mintCoins, burnCoins, feesCoins)
	require.NoError(err)

	// Collector claim reward
	err = k.SendRewardsFromFeeCollector(ctx, addr, feesCoins)
	require.NoError(err)

	// Check balances
	feeCollectorBalances := bk.SpendableCoins(ctx, feeCollectorAddr)
	collectorBalance := bk.SpendableCoins(ctx, collectorAddr)

	require.True(collectorBalance.IsEqual(feesCoins))
	require.True(feeCollectorBalances.IsEqual(sdk.Coins{}))
}
