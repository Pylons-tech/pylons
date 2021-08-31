package keeper_test

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	bankTypes "github.com/cosmos/cosmos-sdk/x/bank/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (suite *IntegrationTestSuite) TestMintCoins() {
	//k, ctx := setupKeeper(t)
	k := suite.k
	bk := suite.bankKeeper
	ctx := suite.ctx
	require := suite.Require()

	coin := sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(100))
	mintAmt := sdk.Coins{}
	mintAmt = mintAmt.Add(coin)

	// set arbitrary initial supply to 100 pylons
	supply := bankTypes.NewSupply(mintAmt)
	bk.SetSupply(ctx, supply)

	// CoinsIssuer module account has minter permissions
	err := k.MintCoins(ctx, types.CoinsIssuerName, mintAmt)
	require.NoError(err)

	addr := k.CoinsIssuerAddress()
	balance := bk.SpendableCoins(ctx, addr)
	require.True(balance.IsEqual(mintAmt))
}

func (suite *IntegrationTestSuite) TestMintCoinsToAddr() {
	//k, ctx := setupKeeper(t)
	k := suite.k
	bk := suite.bankKeeper
	ctx := suite.ctx
	require := suite.Require()

	addrString := types.GenTestBech32FromString("test")
	addr, _ := sdk.AccAddressFromBech32(addrString)

	coin := sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(100))
	mintAmt := sdk.Coins{}
	mintAmt = mintAmt.Add(coin)

	// set arbitrary initial supply to 100 pylons
	supply := bankTypes.NewSupply(mintAmt)
	bk.SetSupply(ctx, supply)

	err := k.MintCoinsToAddr(ctx, addr, mintAmt)

	require.NoError(err)

	balance := bk.SpendableCoins(ctx, addr)
	require.True(balance.IsEqual(mintAmt))
}
