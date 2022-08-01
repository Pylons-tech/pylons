package keeper_test

import (
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
)

func (suite *IntegrationTestSuite) TestFulfillTradeMsgServerSimple() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	wctx := sdk.WrapSDKContext(ctx)
	srv := keeper.NewMsgServerImpl(k)

	creatorA := v1beta1.GenTestBech32FromString("creatorA")
	creatorB := v1beta1.GenTestBech32FromString("creatorB")

	for i := 0; i < 5; i++ {
		msgCreate := &v1beta1.MsgCreateTrade{
			Creator:     creatorA,
			CoinInputs:  nil,
			ItemInputs:  nil,
			CoinOutputs: nil,
			ItemOutputs: nil,
			ExtraInfo:   "extrainfo",
		}

		respCreate, err := srv.CreateTrade(wctx, msgCreate)
		require.NoError(err)
		require.Equal(i, int(respCreate.Id))

		msgFulfill := &v1beta1.MsgFulfillTrade{
			Creator:         creatorB,
			Id:              respCreate.Id,
			CoinInputsIndex: 0,
			Items:           nil,
		}

		_, err = srv.FulfillTrade(wctx, msgFulfill)
		require.NoError(err)
	}
}
