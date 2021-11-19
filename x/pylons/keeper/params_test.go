package keeper_test

import (
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

const (
	// DefaultMinNameFieldLength is the default minimum character length of a request's name field
	TestDenom string = "PylonsNewDenom"
)

func (suite *IntegrationTestSuite) TestDefaultParams() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	require.Equal(types.DefaultCoinIssuers, k.CoinIssuers(ctx))
	require.Equal(types.DefaultPaymentProcessors, k.PaymentProcessors(ctx))
	require.Equal(types.DefaultRecipeFeePercentage, k.RecipeFeePercentage(ctx))
	require.Equal(types.DefaultItemTransferFeePercentage, k.ItemTransferFeePercentage(ctx))
	require.Equal(types.DefaultUpdateItemStringFee, k.UpdateItemStringFee(ctx))
	require.Equal(types.DefaultMinTransferFee, k.MinTransferFee(ctx))
	require.Equal(types.DefaultMaxTransferFee, k.MaxTransferFee(ctx))
	require.Equal(types.DefaultUpdateUsernameFee, k.UpdateUsernameFee(ctx))

	coinIssuedDenomsList := k.CoinIssuedDenomsList(ctx)
	require.Equal(len(coinIssuedDenomsList), len(types.DefaultCoinIssuers))
	for i, denom := range coinIssuedDenomsList {
		require.Equal(types.DefaultCoinIssuers[i].CoinDenom, denom)
	}

	params := k.GetParams(ctx)
	require.Equal(types.DefaultParams(), params)
}

func (suite *IntegrationTestSuite) TestSetParams() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	// set params to new values
	recipeFeePercentage, _ := sdk.NewDecFromStr("0.20")
	itemTransferFeePercentage, _ := sdk.NewDecFromStr("0.20")

	newParams := types.Params{
		CoinIssuers: []types.CoinIssuer{
			{
				CoinDenom: types.PylonsCoinDenom,
				Packages: []types.GoogleInAppPurchasePackage{
					{PackageName: "com.pylons.loud", ProductID: "pylons_1000", Amount: sdk.NewInt(1000)},
					{PackageName: "com.pylons.loud", ProductID: "pylons_55000", Amount: sdk.NewInt(55000)},
				},
				GoogleInAppPurchasePubKey: "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwZsjhk6eN5Pve9pP3uqz2MwBFixvmCRtQJoDQLTEJo3zTd9VMZcXoerQX8cnDPclZWmMZWkO+BWcN1ikYdGHvU2gC7yBLi+TEkhsEkixMlbqOGRdmNptJJhqxuVmXK+drWTb6W0IgQ9g8CuCjZUiMTc0UjHb5mPOE/IhcuTZ0wCHdoqc5FS2spdQqrohvSEP7gR4ZgGzYNI1U+YZHskIEm2qC4ZtSaX9J/fDkAmmJFV2hzeDMcljCxY9+ZM1mdzIpZKwM7O6UdWRpwD1QJ7yXND8AQ9M46p16F0VQuZbbMKCs90NIcKkx6jDDGbVmJrFnUT1Oq1uYxNYtiZjTp+JowIDAQAB",
				EntityName:                "Pylons_Inc",
			},
			{
				CoinDenom:  types.CosmosCoinDenom,
				EntityName: "Cosmos_Hub",
			},
		},
		RecipeFeePercentage:       recipeFeePercentage,
		ItemTransferFeePercentage: itemTransferFeePercentage,
		UpdateItemStringFee:       sdk.NewCoin(TestDenom, sdk.NewInt(20)),
		MinTransferFee:            sdk.NewInt(2),
		MaxTransferFee:            sdk.NewInt(20000),
		UpdateUsernameFee:         sdk.NewCoin(TestDenom, sdk.NewInt(20)),
		DistrEpochIdentifier:      "day",
	}

	k.SetParams(ctx, newParams)

	// get params and check if equal
	params := k.GetParams(ctx)
	require.Equal(newParams, params)
}
