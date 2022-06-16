package keeper_test

import (
	"fmt"
	"math/rand"
	"strconv"
	"strings"
	"time"

	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/cosmos/cosmos-sdk/crypto/hd"
	"github.com/cosmos/cosmos-sdk/crypto/keyring"
	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	sdknetwork "github.com/cosmos/cosmos-sdk/testutil/network"
	sdk "github.com/cosmos/cosmos-sdk/types"
	bankcli "github.com/cosmos/cosmos-sdk/x/bank/client/cli"
	stakingcli "github.com/cosmos/cosmos-sdk/x/staking/client/cli"
	"github.com/stretchr/testify/require"

	"github.com/Pylons-tech/pylons/app"
	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/cosmos/cosmos-sdk/testutil/network"

	epochtypes "github.com/Pylons-tech/pylons/x/epochs/types"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

type TestDelegation struct {
	address string
	amount  sdk.Int
}

func GenerateAddressesInKeyring(ring keyring.Keyring, n int) []sdk.AccAddress {
	addrs := make([]sdk.AccAddress, n)
	for i := 0; i < n; i++ {
		info, _, _ := ring.NewMnemonic("NewUser"+strconv.Itoa(i), keyring.English, sdk.FullFundraiserPath, keyring.DefaultBIP39Passphrase, hd.Secp256k1)
		addrs[i] = info.GetAddress()
	}
	return addrs
}

func distributionEpochGenesis() *epochtypes.GenesisState {
	epochs := []epochtypes.EpochInfo{
		{
			Identifier:            "thirtySeconds",
			StartTime:             time.Time{},
			Duration:              time.Second * 30,
			CurrentEpoch:          0,
			CurrentEpochStartTime: time.Time{},
			EpochCountingStarted:  false,
		},
	}
	return epochtypes.NewGenesisState(epochs)
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
	config.GenesisState["epochs"] = cdc.MustMarshalJSON(distributionEpochGenesis())
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
		reqq, err := clitestutil.ExecTestCLICmd(clientCtx, bankcli.NewSendTxCmd(), args)
		fmt.Println(reqq)
		req.NoError(err)

		accounts = append(accounts, addr)
	}

	return accounts
}

func generateDistributionMap(validators []*sdknetwork.Validator, numDelegations int, minAmount, maxAmount sdk.Int, accounts []string) map[string][]TestDelegation {
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

func computeDistrPercentages(validators []*sdknetwork.Validator, distrMap map[string][]TestDelegation, bondingTokens, totalStake sdk.Int) (distrPercentages map[string]sdk.Dec) {
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
			percentage := amt.ToDec().Quo(totalStake.ToDec())
			if del.address == valAddr {
				distrPercentages[del.address] = distrPercentages[valAddr].Add(percentage)
			} else {
				// 0.5 is the default value given to validators. see cosmos-sdk/testutil/network/network.go
				commission := percentage.Mul(sdk.MustNewDecFromStr("0.5"))
				actualPercentage := percentage.Sub(commission)
				distrPercentages[del.address] = actualPercentage
				distrPercentages[valAddr] = distrPercentages[valAddr].Add(commission)
			}
		}
	}
	return
}

// TestGetRewardsDistributionPercentages to perform this test we need to use network simulation, even though it's in keeper
func (suite *IntegrationTestSuite) TestGetRewardsDistributionPercentages() {
	req := suite.Require()
	feesAmount := sdk.NewCoin("node0token", sdk.NewInt(42_000_000))
	numAccounts := 10
	numDelegationsPerValidators := 10

	cfg := distributionNetworkConfig(feesAmount)
	net := network.New(suite.T(), cfg)
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
	_, err := clitestutil.ExecTestCLICmd(keyringCtx, cli.CmdUpdateAccount(), args)
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
