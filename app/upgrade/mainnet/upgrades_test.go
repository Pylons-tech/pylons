package mainnet_test

import (
	"testing"

	"github.com/Pylons-tech/pylons/app/apptesting"
	"github.com/Pylons-tech/pylons/app/upgrade/mainnet"
	sdk "github.com/cosmos/cosmos-sdk/types"
	bankkeeper "github.com/cosmos/cosmos-sdk/x/bank/keeper"
	"github.com/stretchr/testify/suite"
)

var (
	stakingCoinDenom string    = "ubedrock"
	defaultAcctFunds sdk.Coins = sdk.NewCoins(
		sdk.NewCoin(stakingCoinDenom, sdk.NewInt(10000000)),
	)
)

type UpgradeTestSuite struct {
	apptesting.KeeperTestHelper
}

func TestUpgradeTestSuite(t *testing.T) {
	s := new(UpgradeTestSuite)
	suite.Run(t, s)
}

func (suite *UpgradeTestSuite) TestBurnUbedrock() {
	suite.Setup()
	// Fund ubedrock to test account
	for _, acc := range suite.TestAccs {
		suite.FundAcc(acc, defaultAcctFunds)
	}
	// Get balances in test account
	balances := suite.App.BankKeeper.GetBalance(suite.Ctx, suite.TestAccs[0], stakingCoinDenom)
	suite.Require().Equal(balances.Amount, sdk.NewInt(10000000))
	// Get ubedrock total supply
	totalAmount := suite.App.BankKeeper.GetSupply(suite.Ctx, stakingCoinDenom)
	suite.Require().Equal(totalAmount.Amount, sdk.NewInt(30000000))
	// Burn ubedrock
	bankBaseKeeper, _ := suite.App.BankKeeper.(bankkeeper.BaseKeeper)
	mainnet.BurnUbedrock(suite.Ctx, &bankBaseKeeper)
	// Check ubedrock total supply (should equal 0)
	totalAmount = suite.App.BankKeeper.GetSupply(suite.Ctx, stakingCoinDenom)
	suite.Require().Equal(totalAmount.Amount, sdk.ZeroInt())
}
