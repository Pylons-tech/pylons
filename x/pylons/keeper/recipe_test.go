package keeper_test

import (
	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	sdk "github.com/cosmos/cosmos-sdk/types"

	transfertypes "github.com/cosmos/ibc-go/v5/modules/apps/transfer/types"
)

func (suite *IntegrationTestSuite) TestRecipeGet() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	cookbooks := createNCookbook(k, ctx, 1)
	items := createNRecipe(k, ctx, cookbooks[0], 10)
	for _, item := range items {
		rst, found := k.GetRecipe(ctx, cookbooks[0].Id, item.Id)
		require.True(found)
		require.Equal(item, rst)
	}
}

func (suite *IntegrationTestSuite) TestRecipeGetAll() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	cookbooks := createNCookbook(k, ctx, 1)
	items := createNRecipe(k, ctx, cookbooks[0], 10)
	require.Equal(items, k.GetAllRecipe(ctx))
}

func (suite *IntegrationTestSuite) TestUpdateCoinsDenom() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	addr := generateAddress()
	coinInputs := sdk.Coins{sdk.Coin{Denom: v1beta1.PylonsCoinDenom, Amount: sdk.NewInt(1)}}

	updatedCoinsInput, err := k.UpdateCoinsDenom(ctx, addr, coinInputs)
	require.NoError(err)

	require.Equal(updatedCoinsInput[0].Denom, v1beta1.PylonsCoinDenom)
}

func (suite *IntegrationTestSuite) TestUpdateCoinsIBCDenom() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	addr := generateAddress()
	coinInputs := sdk.Coins{sdk.Coin{Denom: "ujuno", Amount: sdk.NewInt(1)}}

	denomTrace := transfertypes.DenomTrace{
		BaseDenom: "ujuno",
		Path:      "transfer/channel-0",
	}

	k.SetDenomTrace(ctx, denomTrace)

	coin := sdk.NewCoin("ibc/04F5F501207C3626A2C14BFEF654D51C2E0B8F7CA578AB8ED272A66FE4E48097", sdk.NewInt(100))
	mintAmt := sdk.NewCoins()
	mintAmt = mintAmt.Add(coin)

	err := k.MintCoinsToAddr(ctx, addr, mintAmt)

	updatedCoinsInput, err := k.UpdateCoinsDenom(ctx, addr, coinInputs)
	require.NoError(err)

	require.Equal(updatedCoinsInput[0].Denom, "ibc/04F5F501207C3626A2C14BFEF654D51C2E0B8F7CA578AB8ED272A66FE4E48097")
}
