package keeper_test

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	transfertypes "github.com/cosmos/ibc-go/v4/modules/apps/transfer/types"
)

func (suite *IntegrationTestSuite) TestGetDenomTrace() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()
	denomTrace := transfertypes.DenomTrace{
		BaseDenom: "ujunotest",
		Path:      "transfer/channel-0",
	}

	addr := generateAddress()
	k.SetDenomTrace(ctx, denomTrace)

	coin := sdk.NewCoin("ibc/04F5F501207C3626A2C14BFEF654D51C2E0B8F7CA578AB8ED272A66FE4E48097", sdk.NewInt(100))
	mintAmt := sdk.NewCoins()
	mintAmt = mintAmt.Add(coin)

	err := k.MintCoinsToAddr(ctx, addr, mintAmt)

	_, found := k.GetDenomTrace(ctx, coin)
	require.Equal(false, found)
	require.NoError(err)
}
