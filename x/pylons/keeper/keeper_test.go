package keeper_test

import (
	"strconv"
	"testing"

	"github.com/cosmos/cosmos-sdk/baseapp"

	"github.com/Pylons-tech/pylons/app"

	"github.com/cosmos/cosmos-sdk/simapp"
	"github.com/stretchr/testify/suite"

	pylonsSimapp "github.com/Pylons-tech/pylons/testutil/simapp"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"

	sdk "github.com/cosmos/cosmos-sdk/types"
	authtypes "github.com/cosmos/cosmos-sdk/x/auth/types"
	tmproto "github.com/tendermint/tendermint/proto/tendermint/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

const (
	// original address: "cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337"
	validBech32AccAddr = "cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337" // nolint: deadcode
	baseAccAddrBech32  = "cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt33"
)

// CreateTestFakeAddressList creates a list of addresses from baseAccAddrBech32.
// Note, they are not valid Bech32 addresses (except the 7th element), so Bech32 decoding on these will fail
func CreateTestFakeAddressList(numAccount uint) []string {
	accounts := make([]string, numAccount)
	for i := uint(0); i < numAccount; i++ {
		addr := baseAccAddrBech32 + strconv.Itoa(int(i))
		accounts[i] = addr
	}

	return accounts
}

type IntegrationTestSuite struct {
	suite.Suite

	app         *app.App
	ctx         sdk.Context
	queryClient types.QueryClient
	k           keeper.Keeper
}

var (
	// module account permissions
	maccPerms = map[string][]string{
		authtypes.FeeCollectorName: nil,
		types.FeeCollectorName:     nil,
		types.TradesLockerName:     nil,
		types.ExecutionsLockerName: nil,
	}
)

func (suite *IntegrationTestSuite) initKeepersWithPerms() keeper.Keeper {
	app := suite.app
	appCodec := simapp.MakeTestEncodingConfig().Marshaler

	maccPerms := simapp.GetMaccPerms()
	maccPerms[authtypes.FeeCollectorName] = nil
	maccPerms[types.FeeCollectorName] = nil
	maccPerms[types.TradesLockerName] = nil
	maccPerms[types.ExecutionsLockerName] = nil

	pylonsKeeper := keeper.NewKeeper(
		appCodec, app.GetKey(types.StoreKey), app.GetKey(types.MemStoreKey),
		app.BankKeeper, app.AccountKeeper, app.GetSubspace(types.ModuleName),
	)

	return pylonsKeeper
}

func (suite *IntegrationTestSuite) SetupTest() {
	cmdApp := pylonsSimapp.New("./")

	var a *app.App
	switch cmdApp.(type) {
	case *app.App:
		a = cmdApp.(*app.App)
	default:
		panic("imported simApp incorrectly")
	}

	ctx := a.BaseApp.NewContext(false, tmproto.Header{})

	a.PylonsKeeper.SetParams(ctx, types.DefaultParams())

	queryHelper := baseapp.NewQueryServerTestHelper(ctx, a.InterfaceRegistry())
	types.RegisterQueryServer(queryHelper, a.PylonsKeeper)
	queryClient := types.NewQueryClient(queryHelper)

	suite.app = a
	suite.ctx = ctx
	suite.queryClient = queryClient
	suite.k = a.PylonsKeeper

}

func TestKeeperTestSuite(t *testing.T) {
	suite.Run(t, new(IntegrationTestSuite))
}
