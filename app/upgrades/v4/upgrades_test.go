package v4_test

import (
	"fmt"
	"testing"

	"cosmossdk.io/math"
	"github.com/Pylons-tech/pylons/app/apptesting"
	v4 "github.com/Pylons-tech/pylons/app/upgrades/v4"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	bankkeeper "github.com/cosmos/cosmos-sdk/x/bank/keeper"
	stakingtypes "github.com/cosmos/cosmos-sdk/x/staking/types"
	"github.com/stretchr/testify/suite"
)

var (
	stakingCoinDenom string    = "ubedrock"
	stripeCoinDenom  string    = "ustripeusd"
	defaultAcctFunds sdk.Coins = sdk.NewCoins(
		sdk.NewCoin(stakingCoinDenom, sdk.NewInt(10_000_000)),
	)
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

func (suite *UpgradeTestSuite) TestBurnToken_Ubedrock() {
	suite.Setup()
	// Fund ubedrock to test account
	for _, acc := range suite.TestAccs {
		suite.FundAcc(acc, defaultAcctFunds)
	}
	// Check genesis delegation
	delegations := suite.App.StakingKeeper.GetAllDelegations(suite.Ctx)
	suite.Require().Equal(1, len(delegations))
	bondedAmount := suite.App.StakingKeeper.GetDelegatorBonded(suite.Ctx, sdk.MustAccAddressFromBech32(delegations[0].DelegatorAddress))
	suite.Require().Equal(bondedAmount, math.NewInt(1_000_000))
	// Create new delegation
	valAddress, err := sdk.ValAddressFromBech32(delegations[0].ValidatorAddress)
	val, found := suite.App.StakingKeeper.GetValidator(suite.Ctx, valAddress)
	suite.Require().True(found)
	suite.Require().NoError(err)
	_, err = suite.App.StakingKeeper.Delegate(
		suite.Ctx,
		suite.TestAccs[0],
		math.NewInt(1_000_000),
		stakingtypes.Unbonded,
		val,
		true,
	)
	suite.Require().NoError(err)
	// Check all delegation
	delegations = suite.App.StakingKeeper.GetAllDelegations(suite.Ctx)
	suite.Require().Equal(2, len(delegations))
	bondedModuleAddress := suite.App.AccountKeeper.GetModuleAddress(stakingtypes.BondedPoolName)
	bondedModuleAmount := suite.App.BankKeeper.GetBalance(suite.Ctx, bondedModuleAddress, stakingCoinDenom)
	suite.Require().Equal(bondedModuleAmount.Amount, math.NewInt(2_000_000))
	// Get ubedrock total supply
	totalAmount := suite.App.BankKeeper.GetSupply(suite.Ctx, stakingCoinDenom)
	suite.Require().Equal(totalAmount.Amount, math.NewInt(31_000_000))
	// Burn ubedrock
	bankBaseKeeper, _ := suite.App.BankKeeper.(bankkeeper.BaseKeeper)
	v4.BurnToken(suite.Ctx, stakingCoinDenom, &suite.App.AccountKeeper, &bankBaseKeeper, &suite.App.StakingKeeper)
	// Check ubedrock total supply (should equal 0)
	totalAmount = suite.App.BankKeeper.GetSupply(suite.Ctx, stakingCoinDenom)
	suite.Require().Equal(totalAmount.Amount, math.ZeroInt())
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
	v4.BurnToken(suite.Ctx, stripeCoinDenom, &suite.App.AccountKeeper, &bankBaseKeeper, &suite.App.StakingKeeper)
	// Check Ustripeusd total supply (should equal 0)
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
	v4.MintUbedrockForInitialAccount(suite.Ctx, &bankBaseKeeper, &suite.App.StakingKeeper)
	totalAmount = suite.App.BankKeeper.GetSupply(suite.Ctx, stakingCoinDenom)
	suite.Require().Equal(totalAmount.Amount, math.NewIntFromUint64(1_000_000_000_000_000))
	// Check vals - each vals should have 1 bedrock = 1_000_000 ubedrock
	vals := suite.App.StakingKeeper.GetAllValidators(suite.Ctx)
	for _, val := range vals {
		token := val.GetTokens()
		suite.Require().Equal(math.NewIntFromUint64(2_000_000), token)
	}
	// Check token in all initial account
	totalDelegation := len(vals)
	totalDelegateAmount := math.NewIntFromUint64(1_000_000).MulRaw(int64(totalDelegation))
	addr := v4.Accounts[0]
	totalAmounts := v4.UbedrockDistribute[addr].Mul(math.NewInt(int64(len(v4.Accounts))))
	totalAmounts = totalAmounts.Sub(totalDelegateAmount)
	accAmount := suite.App.BankKeeper.GetBalance(suite.Ctx, sdk.MustAccAddressFromBech32(addr), stakingCoinDenom)
	suite.Require().Equal(accAmount.Amount, totalAmounts)
	// Check token in bonded pool module, should equal total delegate amount
	bondedModuleAddress := suite.App.AccountKeeper.GetModuleAddress(stakingtypes.BondedPoolName)
	bondedModuleAmount := suite.App.BankKeeper.GetBalance(suite.Ctx, bondedModuleAddress, stakingCoinDenom)
	suite.Require().Equal(bondedModuleAmount.Amount, totalDelegateAmount)
}

func (suite *UpgradeTestSuite) TestCleanUpylons() {
	suite.Setup()

	productID := "pylons_10"
	amountValid := 10_000_000
	amountOfCoinsTest := sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(10_000_000)))

	//create Google IAP order and test addresses
	items := suite.SetUpGoogleIAPOrder(suite.Ctx, 2, productID)
	testAddrs := suite.SetUpTestAddrs(5)

	for _, tc := range []struct {
		desc   string
		amount int
	}{
		{
			desc:   "Balance of account with valid's upylons is smaller than amount of valid upylons issued",
			amount: amountValid - 5_000_000,
		},
		{
			desc:   "Balance of account with valid's upylons is equal to amount of valid upylons issued",
			amount: amountValid,
		},
		{
			desc:   "Balance of account with valid's upylons is greater than amount of valid upylons issued",
			amount: amountValid + 5_000_000,
		},
	} {
		tc := tc
		suite.Run(tc.desc, func() {
			//mint coin to test account
			for _, addr := range testAddrs {
				err := suite.App.PylonsKeeper.MintCoinsToAddr(suite.Ctx, addr, amountOfCoinsTest)
				suite.Require().NoError(err)
			}
			//mint valid coin
			for _, item := range items {
				addr, _ := sdk.AccAddressFromBech32(item.Creator)
				amt := sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(int64(tc.amount))))
				err := suite.App.PylonsKeeper.MintCoinsToAddr(suite.Ctx, addr, amt)
				suite.Require().NoError(err)
			}
			bankBaseKeeper, _ := suite.App.BankKeeper.(bankkeeper.BaseKeeper)
			v4.CleanUpylons(suite.Ctx, &bankBaseKeeper, &suite.App.PylonsKeeper)
			// check balances of test addresses after clean upylons
			for _, addr := range testAddrs {
				check := suite.App.BankKeeper.GetBalance(suite.Ctx, addr, types.PylonsCoinDenom)
				suite.Require().Equal(check.Amount, sdk.ZeroInt())
			}
			// check balances of valid addresses after clean upylons
			for _, item := range items {
				addr, _ := sdk.AccAddressFromBech32(item.Creator)
				accAmount := suite.App.BankKeeper.GetBalance(suite.Ctx, addr, types.PylonsCoinDenom)
				suite.Require().Equal(accAmount.Amount, sdk.NewInt(int64(amountValid)))
			}
		})
	}
}

func (suite *UpgradeTestSuite) TestRefundIAPNFTBUY() {
	// run iap nft buy refund
	suite.Setup()
	productID := "pylons_10"
	amountValid := 10_000_000
	amountOfCoinsTest := sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(10_000_000)))
	// create Google IAP order and test addresses
	items := suite.SetUpGoogleIAPOrder(suite.Ctx, 2, productID)
	testAddrs := suite.SetUpTestAddrs(5)

	// create a cookbook
	creator := testAddrs[0]
	// test cookbook
	cookbook := types.Cookbook{
		Creator:      creator.String(),
		Id:           "cookbook",
		NodeVersion:  1,
		Name:         "Test Cookbook",
		Description:  "Test Cookbook for testing purposes",
		Developer:    "test",
		Version:      "v0.1",
		SupportEmail: "email@g.com",
		Enabled:      true,
	}
	suite.App.PylonsKeeper.SetCookbook(suite.Ctx, cookbook)
	// test recipe
	recipe := types.Recipe{
		CookbookId:  cookbook.Id,
		Id:          "recipe",
		NodeVersion: 1,
		Name:        "Test Recipe",
		Description: "Test Recipe for testing purposes",
		Version:     "v0.1",
		CoinInputs: []types.CoinInput{
			{
				Coins: sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(int64(amountValid)))),
			},
		},
		ItemInputs: nil,
		Entries: types.EntriesList{
			CoinOutputs: nil,
			ItemOutputs: []types.ItemOutput{
				{
					Id:             "Test Item",
					Doubles:        nil,
					Longs:          nil,
					Strings:        nil,
					MutableStrings: nil,
					TransferFee: []sdk.Coin{
						sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(int64(amountValid))),
					},
					TradePercentage: sdk.NewDec(25),
					Quantity:        10,
					AmountMinted:    5,
					Tradeable:       true,
				},
			},
		},
		Outputs: []types.WeightedOutputs{
			{
				EntryIds: []string{"character"},
				Weight:   uint64(1),
			},
		},
		BlockInterval: 0,
		CostPerBlock:  sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(int64(amountValid))),
		Enabled:       true,
		ExtraInfo:     "extraInfo",
		CreatedAt:     v4.Aug8DateUnix + 3600,
		UpdatedAt:     v4.Aug8DateUnix + 3600,
	}
	// adding sample test execute history for recipe
	suite.App.PylonsKeeper.SetRecipe(suite.Ctx, recipe)
	histories := []types.RecipeHistory{}
	histories = append(
		histories,
		types.RecipeHistory{
			ItemId:     fmt.Sprintf("item-%v", 1),
			CookbookId: recipe.CookbookId,
			RecipeId:   recipe.Id,
			Sender:     testAddrs[1].String(),
			SenderName: fmt.Sprintf("testSender%v", 1),
			Receiver:   cookbook.Creator,
			Amount:     sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(int64(amountValid))).String(),
			CreatedAt:  v4.Aug8DateUnix + 7200,
		},
		types.RecipeHistory{
			ItemId:     fmt.Sprintf("item-%v", 2),
			CookbookId: recipe.CookbookId,
			RecipeId:   recipe.Id,
			Sender:     items[0].Creator,
			SenderName: fmt.Sprintf("testSender%v", 2),
			Receiver:   cookbook.Creator,
			Amount:     sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(int64(amountValid))).String(),
			CreatedAt:  v4.Aug8DateUnix + 7200,
		},
	)
	// saving test history
	suite.App.PylonsKeeper.SetExecuteRecipeHis(suite.Ctx, histories[0])
	suite.App.PylonsKeeper.SetExecuteRecipeHis(suite.Ctx, histories[1])

	// setting IAP addresses as valid for IAP based refund
	v4.IAPAddress[items[0].Creator] = true
	v4.IAPAddress[items[1].Creator] = true
	//mint coin to test account
	for _, addr := range testAddrs {
		err := suite.App.PylonsKeeper.MintCoinsToAddr(suite.Ctx, addr, amountOfCoinsTest)
		suite.Require().NoError(err)
	}
	//mint valid coin
	for _, item := range items {
		addr, _ := sdk.AccAddressFromBech32(item.Creator)
		amt := sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(int64(amountValid))))
		err := suite.App.PylonsKeeper.MintCoinsToAddr(suite.Ctx, addr, amt)
		suite.Require().NoError(err)
	}
	// cleaning all the upylons from addresses
	bankBaseKeeper, _ := suite.App.BankKeeper.(bankkeeper.BaseKeeper)
	v4.CleanUpylons(suite.Ctx, &bankBaseKeeper, &suite.App.PylonsKeeper)

	// making IAP based refund for recipe creators
	v4.RefundIAPNFTBUY(suite.Ctx, &suite.App.PylonsKeeper, &suite.App.AccountKeeper, &bankBaseKeeper)

	// check balances of valid addresses after clean refund to owners of recipe creators
	for i, item := range items {
		addr, _ := sdk.AccAddressFromBech32(item.Creator)
		accAmount := suite.App.BankKeeper.GetBalance(suite.Ctx, addr, types.PylonsCoinDenom)
		if i == 0 {
			suite.Require().Equal(accAmount.Amount, sdk.ZeroInt())
		} else {
			suite.Require().Equal(accAmount.Amount, sdk.NewInt(int64(amountValid)))
		}
	}

	for i, addr := range testAddrs {
		accAmount := suite.App.BankKeeper.GetBalance(suite.Ctx, addr, types.PylonsCoinDenom)
		if i == 0 {
			suite.Require().Equal(accAmount.Amount, sdk.NewInt(int64((amountValid))))
		} else {
			suite.Require().Equal(accAmount.Amount, sdk.ZeroInt())
		}
	}
}

func (suite *UpgradeTestSuite) TestRefundLuxFloralis() {
	suite.Setup()
	// Make recipe executions records
	testAddrs := suite.SetUpTestAddrs(5)
	creator := testAddrs[0]
	amountValid := int64(10_000_000)

	histories := []types.RecipeHistory{}
	histories = append(
		histories,
		types.RecipeHistory{
			ItemId:     fmt.Sprintf("item-%v", 1),
			CookbookId: v4.LuxFloralisCookBookID,
			RecipeId:   v4.LuxFloralisRecipeID,
			Sender:     testAddrs[1].String(),
			SenderName: fmt.Sprintf("testSender%v", 1),
			Receiver:   creator.String(),
			Amount:     sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(amountValid)).String(),
			CreatedAt:  v4.Aug8DateUnix + 7200,
		},
		types.RecipeHistory{
			ItemId:     fmt.Sprintf("item-%v", 2),
			CookbookId: v4.LuxFloralisCookBookID,
			RecipeId:   v4.LuxFloralisRecipeID,
			Sender:     testAddrs[0].String(),
			SenderName: fmt.Sprintf("testSender%v", 2),
			Receiver:   creator.String(),
			Amount:     sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(amountValid)).String(),
			CreatedAt:  v4.Aug8DateUnix + 7200,
		},
	)

	// saving test history
	suite.App.PylonsKeeper.SetExecuteRecipeHis(suite.Ctx, histories[0])
	suite.App.PylonsKeeper.SetExecuteRecipeHis(suite.Ctx, histories[1])

	v4.RefundLuxFloralis(suite.Ctx, &suite.App.PylonsKeeper)

	accAmount := suite.App.BankKeeper.GetBalance(suite.Ctx, creator, types.PylonsCoinDenom)
	suite.Require().Equal(accAmount.Amount, sdk.NewInt(int64((amountValid * 2))))
}
