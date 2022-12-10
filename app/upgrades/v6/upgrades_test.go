package v5_test

import (
	"testing"

	"github.com/Pylons-tech/pylons/app/apptesting"
	sdk "github.com/cosmos/cosmos-sdk/types"
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
