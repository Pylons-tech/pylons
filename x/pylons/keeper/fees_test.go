package keeper_test

import (
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

func (suite *IntegrationTestSuite) TestCalculateTxSizeFeeCookbook() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	addr := types.GenTestBech32List(1)


	cookbook := types.Cookbook{
	Creator:      addr[0],
	ID:           "awefioajwefaoiwefjawoifj",
	NodeVersion:  0,
	Name:         "asfawoifawjefawifoawefjiawe",
	Description:  "awefoijawfoiajwfoijawoeif",
	Developer:    "aawoiefjawoijfawiof",
	Version:      "v0.2.1",
	SupportEmail: "asfasf@oaisjfaosif.mail",
	Enabled:      false,
}

	b := k.cdc.MustMarshal(&cookbook)

	addr, _ := sdk.AccAddressFromBech32(cookbook.Creator)
	fee := types.CalculateTxSizeFee(b, types.DefaultSizeLimitBytes, types.DefaultFeePerBytes)
	if fee > 0 {
		// charge fee
		coins := sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(int64(fee))))
		err := k.bankKeeper.SendCoinsFromAccountToModule(ctx, addr, types.FeeCollectorName, coins)
		if err != nil {
			return nil, sdkerrors.Wrapf(sdkerrors.ErrInsufficientFunds, "unable to pay sizeOver fee of %d%s", fee, types.PylonsCoinDenom)
		}
	}

	items := createNExecution(k, ctx, 10)
	for _, item := range items {
		require.Equal(item, k.GetExecution(ctx, item.ID))
	}
}