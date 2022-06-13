package keeper_test

import (
	"testing"

	"github.com/cosmos/cosmos-sdk/baseapp"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/suite"
	tmproto "github.com/tendermint/tendermint/proto/tendermint/types"

	"github.com/Pylons-tech/pylons/app"
	"github.com/Pylons-tech/pylons/x/epochs/types"
)

type KeeperTestSuite struct {
	suite.Suite

	app         *app.PylonsApp
	ctx         sdk.Context
	queryClient types.QueryClient
}

// TODO: this test needs fixing, too.
func (suite *KeeperTestSuite) SetupTest() {
	pylonsApp := app.New

	ctx := pylonsApp.BaseApp.NewContext(false, tmproto.Header{})

	suite.app = &pylonsApp
	suite.ctx = ctx
	// suite.k = a.PylonsKeeper
	// suite.bankKeeper = a.BankKeeper
	// suite.accountKeeper = a.AccountKeeper

	queryHelper := baseapp.NewQueryServerTestHelper(suite.ctx, suite.app.InterfaceRegistry())
	types.RegisterQueryServer(queryHelper, suite.app.EpochsKeeper)
	suite.queryClient = types.NewQueryClient(queryHelper)
}

func TestKeeperTestSuite(t *testing.T) {
	suite.Run(t, new(KeeperTestSuite))
}
