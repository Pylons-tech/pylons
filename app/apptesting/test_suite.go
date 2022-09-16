package apptesting

import (
	"time"

	"github.com/cosmos/cosmos-sdk/baseapp"
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/crypto/keys/secp256k1"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/tx/signing"
	authsigning "github.com/cosmos/cosmos-sdk/x/auth/signing"
	"github.com/cosmos/cosmos-sdk/x/bank/testutil"
	slashingtypes "github.com/cosmos/cosmos-sdk/x/slashing/types"
	stakingtypes "github.com/cosmos/cosmos-sdk/x/staking/types"
	"github.com/stretchr/testify/suite"
	abci "github.com/tendermint/tendermint/abci/types"
	"github.com/tendermint/tendermint/crypto/ed25519"
	tmproto "github.com/tendermint/tendermint/proto/tendermint/types"

	"github.com/Pylons-tech/pylons/app"
)

type KeeperTestHelper struct {
	suite.Suite

	App         *app.PylonsApp
	Ctx         sdk.Context
	QueryHelper *baseapp.QueryServiceTestHelper
	TestAccs    []sdk.AccAddress
}

func (s *KeeperTestHelper) Setup() {
	s.App = app.Setup(false)
	s.Ctx = s.App.BaseApp.NewContext(false, tmproto.Header{Height: 1, ChainID: "pylons-1", Time: time.Now().UTC()})
	s.QueryHelper = &baseapp.QueryServiceTestHelper{
		GRPCQueryRouter: s.App.GRPCQueryRouter(),
		Ctx:             s.Ctx,
	}

	s.TestAccs = CreateRandomAccounts(3)
}

func (s *KeeperTestHelper) FundAcc(acc sdk.AccAddress, amounts sdk.Coins) {
	err := testutil.FundAccount(s.App.BankKeeper, s.Ctx, acc, amounts)
	s.Require().NoError(err)
}

func (s *KeeperTestHelper) FundModule(moduleName string, amounts sdk.Coins) {
	err := testutil.FundModuleAccount(s.App.BankKeeper, s.Ctx, moduleName, amounts)
	s.Require().NoError(err)
}

func (s *KeeperTestHelper) SetupValidator(bondStatus stakingtypes.BondStatus) sdk.ValAddress {
	valPub := secp256k1.GenPrivKey().PubKey()
	valAddr := sdk.ValAddress(valPub.Address())
	bondDenom := s.App.StakingKeeper.GetParams(s.Ctx).BondDenom
	selfBond := sdk.NewCoins(sdk.Coin{Amount: sdk.NewInt(100), Denom: bondDenom})

	s.FundAcc(sdk.AccAddress(valAddr), selfBond)

	val, found := s.App.StakingKeeper.GetValidator(s.Ctx, valAddr)
	s.Require().True(found)

	val = val.UpdateStatus(bondStatus)
	s.App.StakingKeeper.SetValidator(s.Ctx, val)

	consAddr, err := val.GetConsAddr()
	s.Suite.Require().NoError(err)

	signingInfo := slashingtypes.NewValidatorSigningInfo(
		consAddr,
		s.Ctx.BlockHeight(),
		0,
		time.Unix(0, 0),
		false,
		0,
	)
	s.App.SlashingKeeper.SetValidatorSigningInfo(s.Ctx, consAddr, signingInfo)

	return valAddr
}

func (s *KeeperTestHelper) EndBlock() {
	reqEndBlock := abci.RequestEndBlock{Height: s.Ctx.BlockHeight()}
	s.App.EndBlocker(s.Ctx, reqEndBlock)
}

func (s *KeeperTestHelper) BuildTx(
	txBuilder client.TxBuilder,
	msgs []sdk.Msg,
	sigV2 signing.SignatureV2,
	memo string, txFee sdk.Coins,
	gasLimit uint64,
) authsigning.Tx {
	err := txBuilder.SetMsgs(msgs[0])
	s.Require().NoError(err)

	err = txBuilder.SetSignatures(sigV2)
	s.Require().NoError(err)

	txBuilder.SetMemo(memo)
	txBuilder.SetFeeAmount(txFee)
	txBuilder.SetGasLimit(gasLimit)

	return txBuilder.GetTx()
}

// CreateRandomAccounts is a function return a list of randomly generated AccAddresses
func CreateRandomAccounts(numAccts int) []sdk.AccAddress {
	testAddrs := make([]sdk.AccAddress, numAccts)
	for i := 0; i < numAccts; i++ {
		pk := ed25519.GenPrivKey().PubKey()
		testAddrs[i] = sdk.AccAddress(pk.Address())
	}

	return testAddrs
}
