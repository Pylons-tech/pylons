package keeper_test

import (
	"fmt"
	"math/rand"
	"strconv"
	"time"

	"cosmossdk.io/math"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/crypto/hd"
	"github.com/cosmos/cosmos-sdk/crypto/keyring"
	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	sdknetwork "github.com/cosmos/cosmos-sdk/testutil/network"
	sdk "github.com/cosmos/cosmos-sdk/types"
	bankcli "github.com/cosmos/cosmos-sdk/x/bank/client/cli"
	"github.com/stretchr/testify/require"

	"github.com/Pylons-tech/pylons/app"
	"github.com/cosmos/cosmos-sdk/testutil/network"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

type TestDelegation struct {
	address string
	amount  math.Int
}

func GenerateAddressesInKeyring(ring keyring.Keyring, n int) []sdk.AccAddress {
	addrs := make([]sdk.AccAddress, n)
	for i := 0; i < n; i++ {
		info, _, _ := ring.NewMnemonic("NewUser"+strconv.Itoa(i), keyring.English, sdk.FullFundraiserPath, keyring.DefaultBIP39Passphrase, hd.Secp256k1)
		addrs[i], _ = info.GetAddress()
	}
	return addrs
}

func distributionPylonsGenesis(feesAmount sdk.Coin) *types.GenesisState {
	genState := types.DefaultGenesis()

	// set a high `updateAccount` fee since we'll use it to accumulate balance in the module account
	genState.Params.UpdateUsernameFee = feesAmount
	genState.Params.DistrEpochIdentifier = "thirtySeconds"

	return genState
}

// DefaultConfig will initialize config for the network with custom application,
// genesis and single validator. All other parameters are inherited from cosmos-sdk/testutil/network.DefaultConfig
func distributionNetworkConfig(feesAmount sdk.Coin) network.Config {
	config := app.DefaultConfig()
	config.NumValidators = 1

	cdc := config.Codec
	config.GenesisState["pylons"] = cdc.MustMarshalJSON(distributionPylonsGenesis(feesAmount))

	return config
}

// Give some balance to validators and generate additional accounts with same balance
func generateAccountsWithBalance(numAccounts int, validator *sdknetwork.Validator, coin sdk.Coin, req *require.Assertions) []string {
	accounts := make([]string, 0)
	clientCtx := validator.ClientCtx
	accAddrresses := GenerateAddressesInKeyring(clientCtx.Keyring, numAccounts)
	for i := 0; i < numAccounts; i++ {
		addr := accAddrresses[i].String()
		// send some coins from the validator
		flags := []string{
			fmt.Sprintf("--%s=%s", flags.FlagFrom, validator.Address.String()),
			fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
			fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
		}

		args := []string{validator.Address.String(), addr, coin.String()}
		args = append(args, flags...)
		_, err := clitestutil.ExecTestCLICmd(clientCtx, bankcli.NewSendTxCmd(), args)
		req.NoError(err)

		accounts = append(accounts, addr)
	}

	return accounts
}

func generateDistributionMap(validators []*sdknetwork.Validator, numDelegations int, minAmount, maxAmount math.Int, accounts []string) map[string][]TestDelegation {
	// init random seed
	rand.Seed(time.Now().UnixNano())

	delegations := make(map[string][]TestDelegation)
	accountsCounter := 0
	for _, val := range validators {
		valAddr := val.Address.String()
		delegations[valAddr] = make([]TestDelegation, 0)
		for i := 0; i < numDelegations; i++ {
			// pick an account
			acct := accounts[accountsCounter]
			accountsCounter++
			// pick an amount
			amount := minAmount.Add(sdk.NewInt(rand.Int63n(maxAmount.Int64())))
			del := TestDelegation{
				address: acct,
				amount:  amount,
			}
			delegations[valAddr] = append(delegations[valAddr], del)
		}
		// add additional self-delegation
		amount := minAmount.Add(sdk.NewInt(rand.Int63n(maxAmount.Int64())))
		del := TestDelegation{
			address: valAddr,
			amount:  amount,
		}
		delegations[valAddr] = append(delegations[valAddr], del)
	}

	return delegations
}

func computeDistrPercentages(validators []*sdknetwork.Validator, distrMap map[string][]TestDelegation, bondingTokens, totalStake math.Int) (distrPercentages map[string]sdk.Dec) {
	distrPercentages = make(map[string]sdk.Dec)
	for _, val := range validators {
		valAddr := val.Address.String()
		delegations := distrMap[valAddr]
		distrPercentages[valAddr] = sdk.ZeroDec()
		for _, del := range delegations {
			amt := del.amount
			if del.address == valAddr {
				amt = del.amount.Add(bondingTokens)
			}
			percentage := sdk.NewDecFromInt(amt).Quo(sdk.NewDecFromInt(totalStake))
			if del.address == valAddr {
				distrPercentages[del.address] = distrPercentages[valAddr].Add(percentage)
			} else {
				// 0.5 is the default value given to validators. see cosmos-sdk/testutil/network/network.go

				comm, _ := sdk.NewDecFromStr("0.5")
				commission := percentage.Mul(comm)
				actualPercentage := percentage.Sub(commission)
				distrPercentages[del.address] = actualPercentage
				distrPercentages[valAddr] = distrPercentages[valAddr].Add(commission)
			}
		}
	}
	return
}

/*
// TestGetRewardsDistributionPercentages to perform this test we need to use network simulation, even though it's in keeper
func (suite *IntegrationTestSuite) TestGetRewardsDistributionPercentages() {
	req := suite.Require()
	feesAmount := sdk.NewCoin("node0token", sdk.NewInt(42_000_000))
	numAccounts := 10
	numDelegationsPerValidators := 10

	cfg := distributionNetworkConfig(feesAmount)
	net, err := network.New(suite.T(), suite.T().TempDir(), cfg)
	suite.Require().NoError(err)
	senderValidator := net.Validators[0]
	keyringCtx := senderValidator.ClientCtx
	delegatorsInitialBalance := sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(100_000_000))
	accounts := generateAccountsWithBalance(numAccounts, senderValidator, delegatorsInitialBalance, req)

	distrMap := generateDistributionMap(net.Validators, numDelegationsPerValidators, sdk.NewInt(10_000_000), sdk.NewInt(50_000_000), accounts)

	// initial totalStake is given by sum of all staked tokens by validators
	totalStake := cfg.BondedTokens.Mul(sdk.NewInt(int64(cfg.NumValidators)))

	// by default, validators have same staked amount and some staking token leftover. We add some more stake also
	// for each validator so they have different shares percentage
	for _, val := range net.Validators {
		valAddr := val.Address.String()
		delegations := distrMap[valAddr]
		for _, del := range delegations {
			// send delegation message
			delAddr, _ := sdk.AccAddressFromBech32(del.address)
			clientCtx := keyringCtx
			if del.address == valAddr {
				clientCtx = val.ClientCtx
			}

			flgs := []string{
				fmt.Sprintf("--%s=%s", flags.FlagFrom, delAddr),
				fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
				fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
			}

			args := []string{val.ValAddress.String(), sdk.NewCoin(net.Config.BondDenom, del.amount).String()}
			args = append(args, flgs...)
			_, err := clitestutil.ExecTestCLICmd(clientCtx, stakingcli.NewDelegateCmd(), args)
			req.NoError(err)

			// update total stake
			totalStake = totalStake.Add(del.amount)
		}
	}

	// Delegations set, now pay some fees
	addr := senderValidator.Address.String()
	flgs := []string{
		fmt.Sprintf("--%s=%s", flags.FlagFrom, addr),
		fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
		fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
	}
	args := []string{"testNewUsername"}
	args = append(args, flgs...)
	_, err = clitestutil.ExecTestCLICmd(keyringCtx, cli.CmdUpdateAccount(), args)
	req.NoError(err)

	// simulate waiting for later block heights
	height, err := net.LatestHeight()
	req.NoError(err)
	_, err = net.WaitForHeightWithTimeout(height+5, 30*time.Second)
	req.NoError(err)

	// compute percentages
	distrPercentages := computeDistrPercentages(net.Validators, distrMap, cfg.BondedTokens, totalStake)
	rewardsMap := keeper.CalculateRewardsHelper(distrPercentages, sdk.NewCoins(feesAmount))

	// now check balances
	for _, val := range net.Validators {
		valAddr := val.Address.String()
		delegations := distrMap[valAddr]
		for _, del := range delegations {
			args = []string{del.address}
			flgs = []string{
				fmt.Sprintf("--denom=%s", feesAmount.Denom),
			}
			args = append(args, flgs...)
			out, err := clitestutil.ExecTestCLICmd(keyringCtx, bankcli.GetBalancesCmd(), args)
			req.NoError(err)

			// get amount (a bit hacky, but it works)
			amtStr := strings.Split(out.String(), "amount: \"")[1]
			amtStr = strings.Split(amtStr, "\"")[0]
			amt, _ := strconv.ParseInt(amtStr, 10, 64)
			expected := rewardsMap[del.address].AmountOf(feesAmount.Denom)
			if del.address == senderValidator.Address.String() {
				expected = expected.Add(cfg.AccountTokens).Sub(feesAmount.Amount)
			}
			req.Equal(expected.Int64(), amt)
		}
	}
}
*/

// TestCalculateDelegatorsRewards test cases for calculating delegators rewards
func (suite *IntegrationTestSuite) TestCalculateDelegatorsRewards() {
	k := suite.k
	sk := suite.stakingKeeper
	ctx := suite.ctx
	require := suite.Require()
	bk := suite.bankKeeper
	ak := suite.accountKeeper

	srv := keeper.NewMsgServerImpl(k)
	wctx := sdk.WrapSDKContext(ctx)

	amountToPay := sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(100)))
	creator := types.GenTestBech32FromString("test")
	executor := types.GenTestBech32FromString("executor")
	feeCollectorAddr := ak.GetModuleAddress(types.FeeCollectorName)

	types.UpdateAppCheckFlagTest(types.FlagTrue)

	srv.CreateAccount(wctx, &types.MsgCreateAccount{
		Creator:  executor,
	})

	types.UpdateAppCheckFlagTest(types.FlagFalse)
	cookbookMsg := &types.MsgCreateCookbook{
		Creator:      creator,
		Id:           "testCookbookID",
		Name:         "testCookbookName",
		Description:  "descdescdescdescdescdesc",
		Version:      "v0.0.1",
		SupportEmail: "test@email.com",
		Enabled:      true,
	}
	_, err := srv.CreateCookbook(sdk.WrapSDKContext(suite.ctx), cookbookMsg)
	require.NoError(err)
	recipeMsg := &types.MsgCreateRecipe{
		Creator:       creator,
		CookbookId:    "testCookbookID",
		Id:            "testRecipeID",
		Name:          "recipeName",
		Description:   "descdescdescdescdescdesc",
		Version:       "v0.0.1",
		BlockInterval: 10,
		CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.ZeroInt()},
		CoinInputs:    []types.CoinInput{{Coins: amountToPay}},
		Enabled:       true,
	}
	_, err = srv.CreateRecipe(sdk.WrapSDKContext(suite.ctx), recipeMsg)
	require.NoError(err)

	// create only one pendingExecution
	msgExecution := &types.MsgExecuteRecipe{
		Creator:         executor,
		CookbookId:      "testCookbookID",
		RecipeId:        "testRecipeID",
		CoinInputsIndex: 0,
		ItemIds:         nil,
	}

	// give coins to requester
	suite.FundAccount(suite.ctx, sdk.MustAccAddressFromBech32(executor), amountToPay)

	resp, err := srv.ExecuteRecipe(sdk.WrapSDKContext(suite.ctx), msgExecution)
	require.NoError(err)

	// manually trigger complete execution - simulate endBlocker
	pendingExecution := k.GetPendingExecution(ctx, resp.Id)
	execution, _, _, err := k.CompletePendingExecution(suite.ctx, pendingExecution)
	require.NoError(err)
	k.ActualizeExecution(ctx, execution)

	// verify execution completion and that requester has no balance left,
	// also pay and fee are transfered to cookbook owner and fee collector module
	_ = bk.SpendableCoins(ctx, sdk.MustAccAddressFromBech32(executor))
	_ = bk.SpendableCoins(ctx, sdk.MustAccAddressFromBech32(creator))
	_ = bk.SpendableCoins(ctx, feeCollectorAddr)

	distrPercentages := k.GetRewardsDistributionPercentages(ctx, sk)
	rewardsTotalAmount := bk.SpendableCoins(ctx, k.FeeCollectorAddress())
	if !rewardsTotalAmount.IsZero() {
		delegatorsRewards := make(map[string]sdk.Coins)
		for addr, percentage := range distrPercentages {
			totalAmountsForAddr := sdk.NewCoins()
			for _, coin := range rewardsTotalAmount {
				amountForAddr := sdk.NewDecFromInt(coin.Amount).Mul(percentage).TruncateInt()
				if amountForAddr.IsPositive() {
					// only add strictly positive amounts
					totalAmountsForAddr = totalAmountsForAddr.Add(sdk.NewCoin(coin.Denom, amountForAddr))
				}
			}
			if !totalAmountsForAddr.Empty() {
				delegatorsRewards[addr] = totalAmountsForAddr
				// Comparing amount to pay/10 percent with totalAmounts for address are equal
				require.Equal(totalAmountsForAddr[0].Amount.Int64(), amountToPay[0].Amount.Int64()/10)
			}

		}
		// Checking if delegators Rewards are not empty
		require.NotEqual(len(delegatorsRewards), 0)
	}
}
