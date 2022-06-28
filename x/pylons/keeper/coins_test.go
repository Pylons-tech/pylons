package keeper_test

import (
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (suite *IntegrationTestSuite) TestMintCoins() {
	// k, ctx := setupKeeper(t)
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
	// k, ctx := setupKeeper(t)
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
	// k, ctx := setupKeeper(t)
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

	// PaymentsProcessor account has buner permissions
	err = k.BurnCoins(ctx, types.PaymentsProcessorName, mintAmt)
	require.NoError(err)

	addr := k.CoinsIssuerAddress()
	balance := bk.SpendableCoins(ctx, addr)
	require.True(balance.IsEqual(sdk.Coins{}))
}

func (suite *IntegrationTestSuite) TestBurnCoinsFromAddress() {
	// k, ctx := setupKeeper(t)
	k := suite.k
	bk := suite.bankKeeper
	ctx := suite.ctx
	require := suite.Require()

	addrString := types.GenTestBech32FromString("test")
	addr, _ := sdk.AccAddressFromBech32(addrString)

	coin := sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(100))
	mintAmt := sdk.NewCoins()
	mintAmt = mintAmt.Add(coin)

	err := suite.FundAccount(suite.ctx, addr, mintAmt)
	require.NoError(err)

	err = k.BurnCreditFromAddr(suite.ctx, addr, mintAmt)

	balance := bk.SpendableCoins(ctx, addr)
	require.True(balance.IsEqual(sdk.Coins{}))
}

func (suite *IntegrationTestSuite) TestMintCreditToAddr() {
	// k, ctx := setupKeeper(t)
	k := suite.k
	bk := suite.bankKeeper
	ak := suite.accountKeeper
	ctx := suite.ctx
	require := suite.Require()

	addrString := types.GenTestBech32FromString("test")
	addr, _ := sdk.AccAddressFromBech32(addrString)

	amt := sdk.NewInt(100)
	// account for network fees
	burnAmt := amt.ToDec().Mul(types.DefaultProcessorPercentage).RoundInt()
	feesAmt := amt.ToDec().Mul(types.DefaultValidatorsPercentage).RoundInt()

	mintCoins := sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, amt))
	burnCoins := sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, burnAmt))
	feesCoins := sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, feesAmt))

	// Mint credits to account
	err := k.MintCreditToAddr(suite.ctx, addr, mintCoins, burnCoins, feesCoins)
	require.NoError(err)

	// Check account, module balances
	processorAddr := ak.GetModuleAddress(types.PaymentsProcessorName)
	feeCollectorAddr := ak.GetModuleAddress(types.FeeCollectorName)

	processorBalances := bk.SpendableCoins(ctx, processorAddr)
	feeCollectorBalances := bk.SpendableCoins(ctx, feeCollectorAddr)
	userBalance := bk.SpendableCoins(ctx, addr)

	require.True(userBalance.IsEqual(mintCoins.Sub(burnCoins).Sub(feesCoins)))
	require.True(processorBalances.IsEqual(sdk.Coins{}))
	require.True(feeCollectorBalances.IsEqual(feesCoins))

}
