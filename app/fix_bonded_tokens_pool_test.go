package app_test

import (
	"testing"

	"cosmossdk.io/math"
	"github.com/Pylons-tech/pylons/app"
	"github.com/Pylons-tech/pylons/app/apptesting"
	"github.com/Pylons-tech/pylons/app/params"
	v1 "github.com/Pylons-tech/pylons/app/upgrades/mainnet/v1"
	sdk "github.com/cosmos/cosmos-sdk/types"
	authtypes "github.com/cosmos/cosmos-sdk/x/auth/types"
	bankkeeper "github.com/cosmos/cosmos-sdk/x/bank/keeper"
	stakingtypes "github.com/cosmos/cosmos-sdk/x/staking/types"
	"github.com/stretchr/testify/suite"
)

var (
	stakingCoinDenom            string    = "ubedrock"
	defaultAcctFundsBedrockCoin sdk.Coins = sdk.NewCoins(
		sdk.NewCoin(stakingCoinDenom, sdk.NewInt(10_000_000)),
	)
)

type UpgradeTestSuite struct {
	apptesting.KeeperTestHelper
}

func TestUpgradeTestSuite(t *testing.T) {
	s := new(UpgradeTestSuite)
	suite.Run(t, s)
}

func (suite *UpgradeTestSuite) TestFixBondedTokensPool() {
	suite.Setup()
	// Fund ubedrock to test account
	for _, acc := range suite.TestAccs {
		suite.FundAcc(acc, defaultAcctFundsBedrockCoin)
	}

	multisigAddress := sdk.MustAccAddressFromBech32(app.MasterWallet)
	suite.FundAcc(multisigAddress, defaultAcctFundsBedrockCoin)

	bondedTokensPoolAddress := authtypes.NewModuleAddress(stakingtypes.BondedPoolName)
	bondedTokensPoolBefore := suite.App.BankKeeper.GetBalance(suite.Ctx, bondedTokensPoolAddress, params.StakingBaseCoinUnit)

	// Get ubedrock total supply
	totalAmount := suite.App.BankKeeper.GetSupply(suite.Ctx, stakingCoinDenom)
	suite.Require().Equal(totalAmount.Amount, math.NewInt(41_000_000))

	// Burn ubedrock
	bankBaseKeeper, _ := suite.App.BankKeeper.(bankkeeper.BaseKeeper)
	v1.BurnToken(suite.Ctx, &suite.App.AccountKeeper, &bankBaseKeeper, &suite.App.StakingKeeper)

	// Check ubedrock total supply (should equal 0)
	totalAmount = suite.App.BankKeeper.GetSupply(suite.Ctx, stakingCoinDenom)
	suite.Require().Equal(totalAmount.Amount, math.NewInt(10_000_000))

	// The v1 upgrade handler inadvertently burned the bonded_tokens_pool
	bondedTokensPoolAfter := suite.App.BankKeeper.GetBalance(suite.Ctx, bondedTokensPoolAddress, params.StakingBaseCoinUnit)
	suite.Require().NotEqual(bondedTokensPoolBefore.Amount, bondedTokensPoolAfter.Amount)
	suite.Require().Equal(bondedTokensPoolAfter.Amount, math.ZeroInt())

	// Let's now test the fix
	suite.App.FixBondedTokensPool(suite.Ctx)

	// The bonded_tokens_pool should now be restored.
	bondedTokensPoolFixed := suite.App.BankKeeper.GetBalance(suite.Ctx, bondedTokensPoolAddress, params.StakingBaseCoinUnit)
	suite.Require().NotEqual(bondedTokensPoolBefore.Amount, bondedTokensPoolFixed.Amount)
}
