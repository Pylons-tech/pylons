package v110_test

import (
	"testing"

	"cosmossdk.io/math"
	"github.com/Pylons-tech/pylons/app/apptesting"
	v110 "github.com/Pylons-tech/pylons/app/upgrades/v110"
	sdk "github.com/cosmos/cosmos-sdk/types"
	bankkeeper "github.com/cosmos/cosmos-sdk/x/bank/keeper"
	"github.com/stretchr/testify/suite"
)

var (
	stakingCoinDenom           string    = "ubedrock"
	stripeCoinDenom            string    = "ustripeusd"
	defaultAcctFundsStripeCoin sdk.Coins = sdk.NewCoins(
		sdk.NewCoin(stripeCoinDenom, sdk.NewInt(10_000_000)),
	)
)

type UpgradeTestSuite struct {
	apptesting.KeeperTestHelper
}

func TestUpgradeTestSuite(t *testing.T) {
	s := new(UpgradeTestSuite)
	suite.Run(t, s)
}

func (suite *UpgradeTestSuite) TestBurnToken_Ustripeusd() {
	suite.Setup()
	// Fund Ustripeusd to test account
	for _, acc := range suite.TestAccs {
		suite.FundAcc(acc, defaultAcctFundsStripeCoin)
	}
	// Get Ustripeusd total supply
	totalAmount := suite.App.BankKeeper.GetSupply(suite.Ctx, stripeCoinDenom)
	suite.Require().Equal(totalAmount.Amount, math.NewInt(30_000_000))
	// Burn Ustripeusd
	bankBaseKeeper, _ := suite.App.BankKeeper.(bankkeeper.BaseKeeper)
	v110.BurnToken(suite.Ctx, &suite.App.AccountKeeper, &bankBaseKeeper, &suite.App.StakingKeeper)
	// Check Ustripeusd total supply (should equal 0)
	totalAmount = suite.App.BankKeeper.GetSupply(suite.Ctx, stripeCoinDenom)
	suite.Require().Equal(totalAmount.Amount, math.ZeroInt())
}

func (suite *UpgradeTestSuite) TestMintUbedrockForInitialAccount() {
	suite.Setup()
	// Burn ubedrock
	bankBaseKeeper, _ := suite.App.BankKeeper.(bankkeeper.BaseKeeper)
	// Mint ubedrock for initial account
	v110.MintUbedrockForInitialAccount(suite.Ctx, &bankBaseKeeper, &suite.App.StakingKeeper)
	// Check token in all initial account
	accAmount := suite.App.BankKeeper.GetBalance(suite.Ctx, sdk.MustAccAddressFromBech32(v110.MasterWallet), stakingCoinDenom)
	suite.Require().Equal(accAmount.Amount, v110.MasterWalletbalance)
}
