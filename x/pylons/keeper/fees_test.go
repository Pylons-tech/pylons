package keeper_test

import (
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (suite *IntegrationTestSuite) TestCalculateTxSizeFeeCookbook() {
	cdc := suite.cdc
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

	b := cdc.MustMarshal(&cookbook)

	fee := types.CalculateTxSizeFee(b, int(types.DefaultSizeLimitBytes), types.DefaultFeePerBytes)
	expectedFee := sdk.NewCoin(types.DefaultFeePerBytes.Denom, sdk.NewInt(int64(0)))
	require.Equal(expectedFee, fee)

	fee = types.CalculateTxSizeFee(b, 10, types.DefaultFeePerBytes)
	expectedFeeAmount := (len(b) - 10) * int(types.DefaultFeePerBytesAmount)
	expectedFee = sdk.NewCoin(types.DefaultFeePerBytes.Denom, sdk.NewInt(int64(expectedFeeAmount)))
	require.True(fee.Equal(expectedFee))
}

func (suite *IntegrationTestSuite) TestCalculateTxSizeFeeAndPayCookbook() {
	cdc := suite.cdc
	require := suite.Require()
	ctx := suite.ctx
	k := suite.k
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

	accAddr, err := sdk.AccAddressFromBech32(addr[0])
	require.NoError(err)

	b := cdc.MustMarshal(&cookbook)

	err = k.CalculateTxSizeFeeAndPay(ctx, b, accAddr)
	require.NoError(err)
}
