package v4_test

import (
	"testing"

	"cosmossdk.io/math"
	"github.com/Pylons-tech/pylons/app/apptesting"
	v4 "github.com/Pylons-tech/pylons/app/upgrades/v4"
	sdk "github.com/cosmos/cosmos-sdk/types"
	bankkeeper "github.com/cosmos/cosmos-sdk/x/bank/keeper"
	"github.com/stretchr/testify/suite"
)

var (
	stakingCoinDenom string    = "ubedrock"
	stripeCoinDenom  string    = "ustripeusd"
	defaultAcctFunds sdk.Coins = sdk.NewCoins(
		sdk.NewCoin(stakingCoinDenom, sdk.NewInt(10000000)),
	)
	defaultAcctFundsStripeCoin sdk.Coins = sdk.NewCoins(
		sdk.NewCoin(stripeCoinDenom, sdk.NewInt(10000000)),
	)
)

type UpgradeTestSuite struct {
	apptesting.KeeperTestHelper
}

func TestUpgradeTestSuite(t *testing.T) {
	s := new(UpgradeTestSuite)
	suite.Run(t, s)
}

func (suite *UpgradeTestSuite) TestBurnToken_Ubedrock() {
	suite.Setup()
	// Fund ubedrock to test account
	for _, acc := range suite.TestAccs {
		suite.FundAcc(acc, defaultAcctFunds)
	}
	// Get delegation
	delegations := suite.App.StakingKeeper.GetAllDelegations(suite.Ctx)
	suite.Require().Equal(1, len(delegations))
	// Create new delegation

	bondedAmount := suite.App.StakingKeeper.GetDelegatorBonded(suite.Ctx, sdk.MustAccAddressFromBech32(delegations[0].DelegatorAddress))
	suite.Require().Equal(bondedAmount, math.NewInt(1000000))
	// Get ubedrock total supply
	totalAmount := suite.App.BankKeeper.GetSupply(suite.Ctx, stakingCoinDenom)
	suite.Require().Equal(totalAmount.Amount, math.NewInt(31000000))
	// Burn ubedrock
	bankBaseKeeper, _ := suite.App.BankKeeper.(bankkeeper.BaseKeeper)
	v4.BurnToken(suite.Ctx, stakingCoinDenom, &suite.App.AccountKeeper, &bankBaseKeeper, &suite.App.StakingKeeper)
	// Check ubedrock total supply (should equal 0)
	totalAmount = suite.App.BankKeeper.GetSupply(suite.Ctx, stakingCoinDenom)
	suite.Require().Equal(totalAmount.Amount, math.ZeroInt())
}

func (suite *UpgradeTestSuite) TestBurnToken_Ustripeusd() {
	suite.Setup()
	// Fund ubedrock to test account
	for _, acc := range suite.TestAccs {
		suite.FundAcc(acc, defaultAcctFundsStripeCoin)
	}
	// Get ubedrock total supply
	totalAmount := suite.App.BankKeeper.GetSupply(suite.Ctx, stripeCoinDenom)
	suite.Require().Equal(totalAmount.Amount, math.NewInt(30000000))
	// Burn ubedrock
	bankBaseKeeper, _ := suite.App.BankKeeper.(bankkeeper.BaseKeeper)
	v4.BurnToken(suite.Ctx, stripeCoinDenom, &suite.App.AccountKeeper, &bankBaseKeeper, &suite.App.StakingKeeper)
	// Check ubedrock total supply (should equal 0)
	totalAmount = suite.App.BankKeeper.GetSupply(suite.Ctx, stripeCoinDenom)
	suite.Require().Equal(totalAmount.Amount, math.ZeroInt())
}

func (suite *UpgradeTestSuite) TestMintUbedrockForInitialAccount() {
	suite.Setup()

	// Burn ubedrock
	bankBaseKeeper, _ := suite.App.BankKeeper.(bankkeeper.BaseKeeper)
	v4.BurnToken(suite.Ctx, stakingCoinDenom, &suite.App.AccountKeeper, &bankBaseKeeper, &suite.App.StakingKeeper)
	totalAmount := suite.App.BankKeeper.GetSupply(suite.Ctx, stakingCoinDenom)
	suite.Require().Equal(totalAmount.Amount, math.ZeroInt())

	// Mint ubedrock for initial account
	v4.MintUbedrockForInitialAccount(suite.Ctx, &bankBaseKeeper)
	totalAmount = suite.App.BankKeeper.GetSupply(suite.Ctx, stakingCoinDenom)
	suite.Require().Equal(totalAmount.Amount, math.NewIntFromUint64(1_000_000_000))
	for _, acc := range v4.Accounts {
		accAmount := suite.App.BankKeeper.GetBalance(suite.Ctx, sdk.MustAccAddressFromBech32(acc), stakingCoinDenom)
		suite.Require().Equal(accAmount.Amount, v4.UbedrockDistribute[acc])
	}
}
