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

// TestGetRewardsDistributionPercentages to perform this test we need to use network simulation, even though it's in keeper
func (suite *IntegrationTestSuite) TestGetRewardsDistributionPercentages() {
	k := suite.k
	sk := suite.stakingKeeper
	ctx := suite.ctx
	require := suite.Require()
	bk := suite.bankKeeper
	ak := suite.accountKeeper

	srv := keeper.NewMsgServerImpl(k)
	wctx := sdk.WrapSDKContext(ctx)
	/*
	* amountToPay := refers to the recipe amount
	* ``
	*	form this amount we will calculate the reward that needs to be distributed to
	*	the delegator of the block
	* ``
	* creator  := create address will be used to create cookbook / recipe
	* executor := will be used to execute recipe, as creator and executor cannot be same
	*
	* upon execution of recipe we have a defined fee,
	* i.e. DefaultRecipeFeePercentage (Set at 0.1 or 10%)
	*
	* feeCollectorAddr := address of you fee collector module
	* this modules receives the fee deducted during recipe execution
	*
	* Pre Req:
	*	1. Create Cookbook
	*	2. Create Recipe
	*	3. Execute Recipe
	*
	*
	* this test case will verify that correct amount of rewards are divided amongst delegator
	*
	* 1. Get `delegator amount percentage` that need to be distributed
	*
	* Criteria: In case the percentages calculated must equal the percentage we have calculated
	*			distrPercentagesToEqual must equal distrPercentages
	*			(Calculated)						(Return form our function)
	*
	 */

	amountToPay := sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(100)))
	creator := types.GenTestBech32FromString("test")
	executor := types.GenTestBech32FromString("executor")
	feeCollectorAddr := ak.GetModuleAddress(types.FeeCollectorName)

	// Required to disable app check enforcement to make an account
	types.UpdateAppCheckFlagTest(types.FlagTrue)

	// create an account for the executor as their account in pylons is required
	srv.CreateAccount(wctx, &types.MsgCreateAccount{
		Creator: executor,
	})

	// enable the app check enforcement again
	types.UpdateAppCheckFlagTest(types.FlagFalse)

	// making an instance of cookbook
	cookbookMsg := &types.MsgCreateCookbook{
		Creator:      creator,
		Id:           "testCookbookID",
		Name:         "testCookbookName",
		Description:  "descdescdescdescdescdesc",
		Version:      "v0.0.1",
		SupportEmail: "test@email.com",
		Enabled:      true,
	}
	// creating a cookbook
	_, err := srv.CreateCookbook(sdk.WrapSDKContext(suite.ctx), cookbookMsg)
	// must not throw any error
	require.NoError(err)
	// making an instance of cookbook
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
	// creating a recipe
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

	// fund account of executer to execute recipe
	suite.FundAccount(suite.ctx, sdk.MustAccAddressFromBech32(executor), amountToPay)

	// execute a recipe
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

	// get reward distribution percentages
	distrPercentages := k.GetRewardsDistributionPercentages(ctx, sk)
	// Now we will calculate what should be the output
	delegations := sk.GetAllSDKDelegations(ctx)
	totalShares := sdk.ZeroDec()
	validators := make(map[string]bool)
	sharesMap := make(map[string]sdk.Dec)

	// calculating total shares for out validators
	for _, delegation := range delegations {
		valAddr := delegation.GetValidatorAddr()
		validator := sk.Validator(ctx, valAddr)
		if _, ok := validators[valAddr.String()]; !ok {
			validators[valAddr.String()] = true
			totalShares = totalShares.Add(validator.GetDelegatorShares())
		}
		addr := delegation.GetDelegatorAddr().String()
		if _, ok := sharesMap[addr]; !ok {
			sharesMap[addr] = sdk.ZeroDec()
		}
	}

	distrPercentagesToEqual := make(map[string]sdk.Dec)
	for _, delegation := range delegations {
		valAddr := delegation.GetValidatorAddr()
		validator := sk.Validator(ctx, valAddr)

		valAccAddr := sdk.AccAddress(valAddr)

		shares := sharesMap[delegation.DelegatorAddress]
		sharesPercentage := shares.Quo(totalShares)
		if _, ok := distrPercentagesToEqual[delegation.DelegatorAddress]; !ok {
			distrPercentagesToEqual[delegation.DelegatorAddress] = sdk.ZeroDec()
		}
		if valAccAddr.String() == delegation.DelegatorAddress {
			distrPercentagesToEqual[delegation.DelegatorAddress] = distrPercentagesToEqual[delegation.DelegatorAddress].Add(sharesPercentage)
		} else {
			commission := validator.GetCommission()
			commissionPercentage := sharesPercentage.Mul(commission)
			actualPercentage := sharesPercentage.Sub(commissionPercentage)
			distrPercentagesToEqual[delegation.DelegatorAddress] = distrPercentages[delegation.DelegatorAddress].Add(actualPercentage)
			// we also add the commission percentage to the validator
			if _, ok := distrPercentagesToEqual[valAccAddr.String()]; !ok {
				// in case the validator was not yet added to the map
				distrPercentagesToEqual[valAccAddr.String()] = sdk.ZeroDec()
			}
			distrPercentagesToEqual[valAccAddr.String()] = distrPercentages[valAccAddr.String()].Add(commissionPercentage)
		}
	}
	for validatorAddr := range distrPercentages {
		require.Equal(distrPercentages[validatorAddr], distrPercentagesToEqual[validatorAddr])
	}
}

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
		Creator: executor,
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

func (suite *IntegrationTestSuite) TestGetHoldersRewardsDistributionPercentages() {
	k := suite.k
	sk := suite.stakingKeeper
	ctx := suite.ctx
	require := suite.Require()
	bk := suite.bankKeeper
	ak := suite.accountKeeper

	srv := keeper.NewMsgServerImpl(k)
	wctx := sdk.WrapSDKContext(ctx)

	type Account struct {
		address       string
		coins         sdk.Coins
		expectedCoins sdk.Coins
	}

	tests := []struct {
		desc     string
		creator  Account
		executer Account
		holder   Account
		err      error
	}{
		{
			desc: "holders distribution percentage test",
			creator: Account{
				address: types.GenTestBech32FromString("creator"),
				coins: sdk.Coins{
					sdk.Coin{Denom: types.PylonsCoinDenom, Amount: sdk.NewInt(0)},
				},
				expectedCoins: sdk.Coins{
					sdk.Coin{Denom: types.PylonsCoinDenom, Amount: sdk.NewInt(90)},
				},
			},
			executer: Account{
				types.GenTestBech32FromString("executer"),
				sdk.Coins{
					sdk.Coin{Denom: types.PylonsCoinDenom, Amount: sdk.NewInt(100)},
				},
				sdk.Coins{
					sdk.Coin{Denom: types.PylonsCoinDenom, Amount: sdk.NewInt(0)},
				},
			},
			holder: Account{
				types.GenTestBech32FromString("holder"),
				sdk.Coins{
					sdk.Coin{Denom: types.StakingCoinDenom, Amount: sdk.NewInt(100)},
				},
				sdk.Coins{
					sdk.Coin{Denom: types.StakingCoinDenom, Amount: sdk.NewInt(100)},
					sdk.Coin{Denom: types.PylonsCoinDenom, Amount: sdk.NewInt(9)},
				},
			},
		},
	}

	for _, tc := range tests {
		suite.Run(tc.desc, func() {

			types.UpdateAppCheckFlagTest(types.FlagTrue)
			// create executor account
			srv.CreateAccount(wctx, &types.MsgCreateAccount{
				Creator: tc.creator.address,
			})

			srv.CreateAccount(wctx, &types.MsgCreateAccount{
				Creator: tc.holder.address,
			})

			srv.CreateAccount(wctx, &types.MsgCreateAccount{
				Creator: tc.executer.address,
			})

			types.UpdateAppCheckFlagTest(types.FlagFalse)
			cookbookMsg := &types.MsgCreateCookbook{
				Creator:      tc.creator.address,
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
				Creator:       tc.creator.address,
				CookbookId:    "testCookbookID",
				Id:            "testRecipeID",
				Name:          "recipeName",
				Description:   "descdescdescdescdescdesc",
				Version:       "v0.0.1",
				BlockInterval: 10,
				CostPerBlock:  sdk.Coin{Denom: "test", Amount: sdk.ZeroInt()},
				CoinInputs: []types.CoinInput{{Coins: sdk.Coins{
					sdk.Coin{
						Denom:  types.PylonsCoinDenom,
						Amount: math.NewInt(100),
					},
				}}},
				Enabled: true,
			}
			_, err = srv.CreateRecipe(sdk.WrapSDKContext(suite.ctx), recipeMsg)
			require.NoError(err)
			// create only one pendingExecution
			msgExecution := &types.MsgExecuteRecipe{
				Creator:         tc.executer.address,
				CookbookId:      "testCookbookID",
				RecipeId:        "testRecipeID",
				CoinInputsIndex: 0,
				ItemIds:         nil,
			}
			// give coins to requester
			suite.FundAccount(suite.ctx, sdk.MustAccAddressFromBech32(tc.executer.address), tc.executer.coins)

			// give coins to holder account
			suite.FundAccount(suite.ctx, sdk.MustAccAddressFromBech32(tc.holder.address), tc.holder.coins)

			resp, err := srv.ExecuteRecipe(sdk.WrapSDKContext(suite.ctx), msgExecution)
			require.NoError(err)
			// manually trigger complete execution - simulate endBlocker
			pendingExecution := k.GetPendingExecution(ctx, resp.Id)
			execution, _, _, err := k.CompletePendingExecution(suite.ctx, pendingExecution)
			require.NoError(err)
			k.ActualizeExecution(ctx, execution)
			delegations := sk.GetAllSDKDelegations(ctx)
			validatorBalance := make(map[string]sdk.Coin)

			// calculating total shares for out validators
			for _, delegation := range delegations {
				validatorBalance[delegation.DelegatorAddress] = bk.GetBalance(ctx, delegation.GetDelegatorAddr(), types.PylonsCoinDenom)
				require.Equal(sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(0)), validatorBalance[delegation.DelegatorAddress])
			}
			distrPercentages := k.GetHoldersRewardsDistributionPercentages(ctx, sk, ak)

			rewardsTotalAmount := bk.SpendableCoins(ctx, k.FeeCollectorAddress())
			if !rewardsTotalAmount.IsZero() {
				holderRewards := make(map[string]sdk.Coins)
				for addr, percentage := range distrPercentages {

					require.Equal(sdk.NewDec(1), percentage)
					totalAmountsForAddr := sdk.NewCoins()
					for _, coin := range rewardsTotalAmount {

						holderRewardPercentage := sdk.NewDec(keeper.BedRockHolderRewardPercentage).Quo(sdk.NewDec(100))
						amount := sdk.NewDec(coin.Amount.Int64())
						availableAmount := amount.Mul(holderRewardPercentage)
						amountForAddr := availableAmount.Mul(percentage)
						if amountForAddr.IsPositive() {
							// only add strictly positive amounts
							totalAmountsForAddr = totalAmountsForAddr.Add(sdk.NewCoin(coin.Denom, amountForAddr.RoundInt()))
						}
					}
					if !totalAmountsForAddr.Empty() {
						holderRewards[addr] = totalAmountsForAddr
					}

				}
				require.Equal(tc.executer.expectedCoins, sdk.Coins{
					sdk.Coin{Denom: types.PylonsCoinDenom, Amount: sdk.NewInt(0)},
				})
				require.Equal(tc.creator.expectedCoins, sdk.Coins{
					sdk.Coin{Denom: types.PylonsCoinDenom, Amount: sdk.NewInt(90)},
				})

				// Checking if delegators Rewards are not empty
				require.NotEqual(len(holderRewards), 0)
			}
		})
	}
}
